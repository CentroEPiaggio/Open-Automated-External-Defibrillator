/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all common
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_Common.h"

/* Declaration of global variables */
int16 CacheECG[ECG_CACHE_SIZE] = {0};
#if(RAW_MODE)
int16 CacheRAW[RAW_CACHE_SIZE] = {0};
#endif

int16 BufferECG[ECG_DATA_SIZE]          = {0};
int16 BufferZ[Z_DATA_SIZE]              = {0};

int16 DataECG[ECG_DATA_SIZE]            = {0};
int16 OldECG[ECG_DATA_SIZE]             = {0};
int16 DataZ[Z_DATA_SIZE]                = {0};

double PatientImpedance                 = 0;

uint8 EventCounter = 0;

#if(RAW_MODE)
    int16 DataRAW[RAW_DATA_SIZE]        = {0};
    int16 BufferRAW[RAW_DATA_SIZE]      = {0};
#endif
/* End of global variables declaration */

/* Declaration of system flags */
bool ECG_buffer_full                = false;
bool Z_buffer_full                  = false;
bool ECG_data_pending               = false;

bool ECG_enabled                    = false;
bool Z_enabled                      = false;

bool lead_detected                  = false;
bool capacitor_ready                = false;

bool event_flags[EVENT_NO]          = {false};

bool Continuous_USBECG              = false;
bool Continuous_USBRAW              = false;

#if(RAW_MODE)
bool RAW_buffer_full                = false;
#endif
/* End of system flags declaration */

/* Function declarations */
void OAED_Init(){

    OAED_DMA_Init();        /* DMA Initialization. */
    OAED_AcquisitionInit(); /* Initialize acquisition circuitery. */
    OAED_InitFilter();      /* Initialize filter component. */
    OAED_ResetEvent();      /* Event data initialization. */
    OAED_ISRInit();         /* ISR initialization. */

    /* Secure the defibrillation circuitery. */
    OAED_DisableChargingCircuit();
    OAED_DisableDefibrillation();
    OAED_DisarmDefibrillator(true);

    OAED_USBInit();
    #if(OAED_TIME)
        OAED_InitTime();
    #endif

    CyGlobalIntEnable;      /* Enable global interrupts. */
    return;
}

void OAED_InitFilter(){
    /* Init and start the filter component. */
    Filter_Start();

    /* Set coherency and dalign for 16bit DMA transfer. */
    Filter_SetCoherency(Filter_CHANNEL_A, Filter_KEY_MID);
    Filter_SetCoherency(Filter_CHANNEL_B, Filter_KEY_MID);
    Filter_SetDalign(Filter_STAGEA_DALIGN, Filter_ENABLED);
    Filter_SetDalign(Filter_STAGEB_DALIGN, Filter_ENABLED);
    Filter_SetDalign(Filter_HOLDA_DALIGN, Filter_ENABLED);
    Filter_SetDalign(Filter_HOLDB_DALIGN, Filter_ENABLED);

    return;
}

void OAED_CopyECGBuffer(){
    /* The Buffer is copied on the Data vector and re-initialized to zeroes. */
    uint16 i;

    for(i = 0; i < ECG_DATA_SIZE ; i++){
        OldECG[i] = DataECG[i];
        DataECG[i] = BufferECG[i];
    }

    /* Raw signal */
    #if(RAW_MODE)
    if(RAW_buffer_full){
        for(i = 0; i < RAW_DATA_SIZE ; i++)
            DataRAW[i] = BufferRAW[i];
        RAW_buffer_full = false;
    }
    #endif

    /* Set system flags */
    ECG_buffer_full = false;
    ECG_data_pending = true;

    return;
}

void OAED_CopyZBuffer(){
    /* The Buffer is copied on the Data vector and re-initialized to zeroes. */
    uint16 i;

    for(i = 0; i < Z_DATA_SIZE ; i++){
        DataZ[i] = BufferZ[i];
    }

    /* Set system flag */
    Z_buffer_full = false;

    return;
}

void OAED_Led(bool blue, bool orange, bool green, bool yellow){
    /* Set or clear pins according to the parameters. */
    OAED_PINCONTROL(blue, Status_Led_Blue);         // Evaluating ECG
    OAED_PINCONTROL(orange, Status_Led_Orange);     // Capacitor charging
    OAED_PINCONTROL(green, Status_Led_Green);       // System ready
    OAED_PINCONTROL(yellow, Status_Led_Yellow);     // Lead-off only
    return;
}

void OAED_ResetEvent(){
    /* This function reinitialize the event data. */

    uint8 i;
    for(i = 0 ; i < EVENT_NO ; i++)
        event_flags[i] = false;

    EventCounter = 0;

    ECG_data_pending = false;
    return;
}

bool OAED_CheckFlags(){
    /* Return true in case the positive events registered are equal or */
    /* greater than the required positive events. */

    /* Default settings: */
    /* POSITIVE_EVENT_NO    2 */
    /* EVENT_NO             3 */

    uint8 i;
    uint8 Counter = 0;

    for( i=0 ; i < EVENT_NO ; i++){
        if(event_flags[i])
            Counter++;
        if(Counter == POSITIVE_EVENT_NO)
            return true;
    }
    return false;
}

bool OAED_EvaluateRhythm(){
    /* Evaluate the Data vector, update the event flags and return true */
    /* if VT/VF is detected. */

    OAED_ECGAnalysis();

    return OAED_CheckFlags();
}

bool OAED_EvaluateImpedanceAC(){
    /* Evaluate the patient impedance from data and store it in */
    /* patient_impedance variable. */
    /* This function return false if a lead off is assumed, otherwise true.*/
    uint16 i;                           // DataZ index
    uint16 iZmax = 5 * Z_PERIOD;        // Maximum index
    uint16 Count = 0;                   // Sum count
    double NewImpedance = 0;           // Temporary impedance

    /* Find first maximum index */
    for( i = iZmax + 1 ; (i < iZmax + Z_PERIOD) && (i < Z_DATA_SIZE) ; i++)
        if( DataZ[i] > DataZ[iZmax] )
            iZmax = i;

    if(i >= Z_DATA_SIZE / 2)
        return false;

    /* Data Z contains voltages count used to evaluate the impedance. */
    /* First sum up all peak to peak values */
    for( i = iZmax ; (i + Z_PERIOD / 2) < Z_DATA_SIZE ; i += Z_PERIOD ){
        /* Correct sampling misalignment */
        iZmax = i;
        while( DataZ[i] < DataZ[i+1] ){
            if(i > iZmax + Z_PERIOD)
                break;
            else
                i++;
        }
        while( DataZ[i] < DataZ[i-1] ){
            if(i < iZmax - Z_PERIOD)
                break;
            else
                i--;
        }
        if(fabs(i - iZmax) > Z_PERIOD){
            /* No peak detected, try again in the next 5th period */
            i = iZmax + 5 * Z_PERIOD;
            continue;
        }
        /* Peak to peak = max - min */
        NewImpedance += DataZ[i] - DataZ[i + Z_PERIOD / 2];
        Count++;
    }
    /* If more than 50% periods doesn't have a maximum, something is wrong. */
    if(Count < (Z_DATA_SIZE/Z_PERIOD) * 0.5 )
        return false;

    /* Get the mean value. */
    NewImpedance /= Count;
    /* Divide peak to peak mean value by 2 */
    NewImpedance /= 2;
    /* Remove the ADC buffer gain */
    NewImpedance /= ADC_BUFFER_GAIN;

    /* Get the voltage value from the ADC counts */
    //NewImpedance = (double)(ADC_DelSig_CountsTo_uVolts((int32)NewImpedance));

    /* Calculate the impedance from the 2 IDAC current (expressed in 1/8 uA). */
    NewImpedance /= ( (double)(IDAC_Drain_Data) * 2 / 8 );
    NewImpedance *= 10;

    if(!OAED_ValidateImpedance(NewImpedance)){
        PatientImpedance = 0;
        lead_detected = false;
        return false;
    }

    /* If the impedance calculations are correct, overwrite the old impedance */
    PatientImpedance = NewImpedance;
    return true;
}

bool OAED_EvaluateImpedanceDC(){
    uint16 i;                          // For index
    double NewImpedance = 0;           // Temporary impedance

    /* Find first maximum index */
    for( i = 0 ; i < Z_DATA_SIZE ; i++)
        NewImpedance += ((double)(DataZ[i])/Z_DATA_SIZE);

    /* Calculate the impedance from the 2 IDAC current (expressed in 1/8 uA). */
    NewImpedance /= ( (double)(IDAC_Drain_Data) / 8 );
    NewImpedance /= 32768;              // 16bit = 2^15 max
    NewImpedance *= 32000;              // ADC input range [uV]

    if(!OAED_ValidateImpedance(NewImpedance)){
        PatientImpedance = 0;
        lead_detected = false;
        return false;
    }

    /* If the impedance calculations are correct, overwrite the old impedance */
    PatientImpedance = fabs(NewImpedance);
    return true;
}

bool OAED_ValidateImpedance(double Impedance){
    /* If the new impedance is outside the human limits it means that the
       electrodes may not be attached to the patient. Therefore we assume
       a lead-off.
       */
    if(Impedance < Z_MIN || Impedance > Z_MAX)
        return false;

    /* This is optional, but enabled by default. */
    /* If the last acquisition was drastically different it is likely that the
       electrodes went off.
       */
    if(PatientImpedance != 0){
        double imp_ratio = Impedance / PatientImpedance;
        if(imp_ratio > 1 + IMPEDANCE_DEVIATION)
            return false;

        if(imp_ratio < 1 - IMPEDANCE_DEVIATION)
            return false;
    }
    return true;
}

void OAED_EnableChargingCircuit(){

    /* Disarm Defibrillator. */
    OAED_DisarmDefibrillator(false);

    /* Enable the charging circuit. */
    OAED_PINCONTROL(true, Charge_En_0);

    /* Enable capacitor sense. */
    Comp_CapReady_Start();
    Comp_CapLow_Start();
    isr_CapReady_Enable();

    return;
}

void OAED_DisableChargingCircuit(){
    /* Disable Charging circuit. */
    OAED_PINCONTROL(false, Charge_En_0);

    /* Disarm Defibrillator. */
    OAED_DisarmDefibrillator(false);

    /* Disable capacitor sense. */
    isr_CapReady_Disable();
    Comp_CapReady_Stop();
    Comp_CapLow_Stop();

    return;
}
/* End of function declarations */

/* [] END OF FILE */
