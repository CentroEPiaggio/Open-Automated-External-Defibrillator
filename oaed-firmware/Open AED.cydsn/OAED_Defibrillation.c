/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all defibrillation
 * related function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_Defibrillation.h"

uint32 OAED_EvaluateDischargeTime(){ // Possibly deprecated
    uint32 Time;
    /* Time formula. */
    Time = (uint32)(- PatientImpedance * C * log( 1 - 2 * U/U_MAX ));
    /* Express Time in ms */
    Time = Time * 1000;
    return Time;
}

void OAED_EnableDefibrillation(){
    /* Pause ECG acquisition.*/
    if(ECG_enabled)
        OAED_AcquisitionECGPause();

    /* Switch inner and outer security relay. */
    CyPins_SetPin(Defibrillation_En_Inner);
    CyPins_SetPin(Defibrillation_En_Outer);

    /* Wait for the relay to set. */
    CyDelay(20);

    return;
}

void OAED_DisableDefibrillation(){
    /* Switch inner and outer security relay. */
    CyPins_ClearPin(Defibrillation_En_Inner);
    CyPins_ClearPin(Defibrillation_En_Outer);

    /* Wait for the relay to set. */
    CyDelay(20);

    return;
}

inline void OAED_ArmDefibrillator(){
    /* Enable defibrillator switch interrupt. */
    isr_Defibrillate_Enable();
}

inline void OAED_DisarmDefibrillator(bool release_charge){
    /* Disable the protection resistor connection. */
    OAED_HBridgeControl( OPEN_CIRCUIT );

    /* Disable defibrillator switch interrupt. */
    isr_Defibrillate_Disable();

    /* If required, activate internal discharge. */
    if(release_charge)
        OAED_InternalDischarge();
    return;
}

void OAED_InternalDischarge(){
    /* Avoid any possibilities to release the charge to the patient.
       Since a lot of current need to be released, the discharge is
       modulated with a PWM like control.

       Avoid any risk of accidental defibrillation.
       */
    OAED_DisableDefibrillation();

    /* The PWM discharge last until the capacitor voltage go below the
       threshold.
    */
    while(capacitor_ready){
        /* Activate a monophasic PWM discharge. */
        OAED_HBridgeControl( OPEN_CIRCUIT );
        CyDelayUs(PWM_OFF);

        OAED_HBridgeControl( PHI_1 );
        CyDelayUs(PWM_ON);
    }
    /* After reaching the threshold it's safe to release the remaining charge
       as a continuous discharge.
    */
    return;
    /* We don't need to wait for the capacitor to fully discharge because
       it's going to need a lot of Time.
       Also, this way is safer since the capacitor can't store energy until
       the circuit is opened again when the next charge command is called.
    */
}

void OAED_MonophasicDefibrillation(){
    uint32 Time;

    /* Get discharge Time. */
    Time = OAED_EvaluateDischargeTime();

    /* Enable patient defibrillation. */
    OAED_EnableDefibrillation();

    /* Start Defibrillation. */
    OAED_HBridgeControl( PHI_1 );
    /* Wait for the charge to be delivered. */
    CyDelay(Time);
    /* Stop Defibrillation */
    OAED_HBridgeControl( OPEN_CIRCUIT );

    /* Disable patient defibrillation. */
    OAED_DisableDefibrillation();

    /* Discharge residual charge. (optional) */
    //OAED_InternalDischarge();

    return;
}

void OAED_PolyphasicDefibrillation(uint8 phase_no){
    uint32 TotalTime;
    uint32 Phase1_Time;
    uint32 PhaseN_Time;
    uint8 i;

    /* Get discharge Time. */
    TotalTime = OAED_EvaluateDischargeTime();
    Phase1_Time = TotalTime / phase_no;
    PhaseN_Time = TotalTime - phase_no * Phase1_Time;

    /* If phase doesn't last enough execute a biphasic instead */
    if(PhaseN_Time <3){
        OAED_BiphasicDefibrillation(50);
        return;
    }

    /* Enable patient defibrillation. */
    OAED_EnableDefibrillation();

    /* Start Defibrillation. */
    OAED_HBridgeControl( PHI_1 );
    /* Wait for the phase 1 charge to be delivered. */
    CyDelay(Phase1_Time);

    /* Stop Defibrillation for 1 msec */
    OAED_HBridgeControl( OPEN_CIRCUIT );
    CyDelay(1);

    for( i=1; i<phase_no ; i++){
        /* Invert phase */
        if(i%2 == 1)
            OAED_HBridgeControl( PHI_2 );
        else
            OAED_HBridgeControl( PHI_1 );
        /* Wait for the charge to be delivered. */
        CyDelay(PhaseN_Time);
        /* Stop Defibrillation. */
        OAED_HBridgeControl( OPEN_CIRCUIT );
        CyDelayUs(500);

    }
    /* Disable patient defibrillation. */
    OAED_DisableDefibrillation();

    /* Discharge residual charge. (optional) */
    //OAED_InternalDischarge();

    return;
}

void OAED_BiphasicDefibrillation(uint8 phase_one_duty){
    uint32 TotalTime;
    uint32 Phase1_Time;
    uint32 phase2_time;

    /* Get discharge Time. */
    TotalTime = OAED_EvaluateDischargeTime();
    Phase1_Time = TotalTime * phase_one_duty / 100;
    phase2_time = TotalTime - Phase1_Time;

    /* Enable patient defibrillation. */
    OAED_EnableDefibrillation();

    /* Start Defibrillation. */
    OAED_HBridgeControl( PHI_1 );
    /* Wait for the phase 1 charge to be delivered. */
    CyDelay(Phase1_Time);
    /* Stop Defibrillation for 1 msec */
    OAED_HBridgeControl( OPEN_CIRCUIT );
    CyDelay(1);
    /* Invert phase */
    OAED_HBridgeControl( PHI_2 );
    /* Wait for the phase 2 charge to be delivered. */
    CyDelay(phase2_time);
    /* Stop Defibrillation. */
    OAED_HBridgeControl( OPEN_CIRCUIT );

    /* Disable patient defibrillation. */
    OAED_DisableDefibrillation();

    /* Discharge residual charge. (optional) */
    //OAED_InternalDischarge();

    return;
}

/* [] END OF FILE */
