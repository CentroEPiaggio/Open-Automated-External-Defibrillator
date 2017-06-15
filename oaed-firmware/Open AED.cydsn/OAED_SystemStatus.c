/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all system status
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_SystemStatus.h"

/* Function declarations */
char OAED_LeadOffMode(){
    /* While in lead-off mode the system will wait for lead
       detection.
       */

    /* First we need to reset the event data. Lead off mode means that the
       patient may have changed.
       */
    OAED_ResetEvent();

    /* Stop ECG acquisition */
    if(ECG_enabled)
        OAED_AcquisitionECGStop();

    /* Then the system lock until leads are attached again. */
    OAED_WaitLeadOn();

    /* Another layer of protection is to evaluate the patient impedance. */

    if(OAED_WaitForZ())
        return measurement_mode;

    /* Leads detected */
    if(lead_detected){
        OAED_AcquisitionECGStart();
        return measurement_mode;
    }

    /* No leads detected */
    return lead_off;
}

char OAED_MeasurementMode(){
    /* While in measurement mode the system checks for, lead-off, patient
       impedance and VT or VF.
       */

    /* Start ECG acquisition and check for lead-off */
    if(!OAED_AcquisitionECGUnpause())
        return lead_off;

    /* Check for new data */
    if(ECG_data_pending){
        /* If new data is available the system evaluate the rhytm and if */
        /* VF/VT are found the system start charging the capacitor. */
        if(OAED_EvaluateRhythm())
            return charging_capacitor;
    }

    /* Wait for new data */
    if(!OAED_WaitForData())
        return lead_off;

    /* Lead are still on and no VT/VF were found */
    return measurement_mode;
}

char OAED_ChargingMode(){
    /* In this mode of operation the system works the same as in measurement
       mode, but the capacitor charging circuit is enabled.
       This mode is only entered if VF or VT are detected for 2 out of 3 period
       of time. (DEFAULT SETTINGS)
       */
    static uint8 FalsePositiveCount = 0; /* Init the false positive counter */

    /* Start ECG acquisition and check for lead-off */
    if(!OAED_AcquisitionECGUnpause()){
        FalsePositiveCount = 0;
        return internal_discharge;
        /* In case the system can't detect the leads on it activate the internal
           discharge to avoid possible hazardous situations.
           */
    }

    /* Check for new data */
    if(ECG_data_pending){
        /* If new data is available the system evaluate the rhytm. */
        if(!OAED_EvaluateRhythm()){
            /* If no VF/VT are found the false positive counter is increased.
               Then if in the last 5 time period no VT/VF events are found, it
               means that it was a false positive.
               */
            if(++FalsePositiveCount > 5){
                FalsePositiveCount = 0;
                return internal_discharge;
            }
        }
    }
    /* If VF/VT is detected the system wait for the capacitor to charge. */
    if(OAED_WaitForCap()){
        /* If the capacitor is charged before new data is available the system
           reset the positive count and switch to discharge enabled mode.
           */
        FalsePositiveCount = 0;
        return discharge_enabled;
    }
    /* WaitForCap return false in case data is ready before the capacitor is,
       but also in case a lead-off is detected.
       */
    if(!lead_detected){
        FalsePositiveCount = 0;
        return internal_discharge;
    }

    return charging_capacitor;
}

char OAED_DischargeEnabledMode(){
    /* In this mode the capacitor is charged and the system is waiting for the
       operator to push the discharge button.
       */

    /* Start ECG acquisition and check for lead-off */
    if(!OAED_AcquisitionECGUnpause())
        /* In case the system can't detect the leads on it activate the internal
           discharge to avoid possible hazardous situations.
           */
        return internal_discharge;

    /* Check for new data */
    if(ECG_data_pending){
        /* If new data is available the system evaluate the rhytm. */
        if(!OAED_EvaluateRhythm())
            /* If no VF/VT are found the system go back in charging mode.
               After 5 more period of time without VT/VF its assumed it was a
               false positive.
               */
            return charging_capacitor;
    }

    /* Wait for new data */
    if(!OAED_WaitForData())
        /* In case of Lead-off */
        return internal_discharge;

    /* Nothing relevant happened, the system remain in discharge enabled mode. */
    return discharge_enabled;
}

char OAED_InternalDischargeMode(){
    /* This mode is entered when the charge of the capacitor is no longer
       needed, or is potentially dangerous (ie lead off detected).
       */

    /* Stop ECG acquisition before releasing the charge. */
    OAED_AcquisitionECGPause();

    /* Disarm and release the charge. */
    OAED_DisarmDefibrillator(true);

    if(!lead_detected)
        /* If no leads detected return lead off mode */
        return lead_off;

    return measurement_mode;
}

void OAED_SetSystemStatus(char Status){
    static char OldStatus = -1;

    /* If the status has not changed, return */
    if(OldStatus == Status)
        return;

    switch(Status){
        case charging_capacitor:
            OAED_Led(true, true, false, false);    // Blue and orange

            /* Enable charging circuit. */
            OAED_EnableChargingCircuit();
            return;
        case discharge_enabled:
            OAED_Led(true, true, true, false);     // Blue, orange and green

            /* Charging circuit should be already operative. */
            /* Arm the defibrillator. */
            OAED_ArmDefibrillator();
            return;
        case internal_discharge:
            OAED_Led(false, false, false, false);  // No led

            OAED_DisableChargingCircuit();
            return;
        case measurement_mode:
            OAED_Led(true, false, false, false);   // Only blue

            OAED_DisableChargingCircuit();
            return;
        default:
            OAED_Led(false, false, false, false);  // No led

            /* Lead-Off. */
            OAED_DisableChargingCircuit();
            return;
    }
}

/* End of function declarations */

/* [] END OF FILE */
