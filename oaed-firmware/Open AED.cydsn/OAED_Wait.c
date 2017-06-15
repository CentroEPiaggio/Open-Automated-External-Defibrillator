/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all common
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_Wait.h"

/* Function declarations */


void OAED_WaitLeadOn(){
    /* ~~~ WARNING: THIS IS A BLOCKING FUNCTION ~~~ */
    /* ~~~ EXTRA WARNING: THIS ONLY WORK FOR DC LEAD OFF DETECTION ~~~ */

    /* This function wait indefinitely until the electrodes are attached to */
    /* the patient. */

    /* The system blinks the blue led while waiting for the patient. */
    bool yellow_led = false;
    uint8 i;

    while(!lead_detected){
        /* Blink the blue led with a period of 1sec. */
        for(i = 0 ; i<5 ; i++){
            /* Check for lead detection every 100ms. */
            if(lead_detected){
                return;
            }
            CyDelay(100);
        }
        yellow_led = !yellow_led;
        OAED_Led(false, false, false, yellow_led);
    }
}

bool OAED_WaitForData(){
    /* ~~~ WARNING: THIS IS A BLOCKING FUNCTION ~~~ */

    /* Return false if detect lead-off, otherwise return true when new data */
    /* is available. */

    while(!ECG_buffer_full){

        if(!lead_detected)
            return false;
        /* Check for z Data */
        if(Z_buffer_full){
            OAED_CopyZBuffer();
            if(!OAED_EvaluateImpedanceDC())
                return false;
            OAED_AcquisitionZ();
        }
        /* Wait 10 ms */
        CyDelay(10);
    }

    /* Get data */
    OAED_CopyECGBuffer();

    return true;
}

bool OAED_WaitForZ(){
    /* ~~~ WARNING: THIS IS A BLOCKING FUNCTION ~~~ */

    /* Return false if detect lead-off, otherwise return true. */

    OAED_AcquisitionZ();
    /* Wait for data */
    while(!Z_buffer_full){
        if(!lead_detected)
            return false;
    }

    /* Get data */
    OAED_CopyZBuffer();

    /* Evaluate data and return true if a lead-on is assumed. */
    return OAED_EvaluateImpedanceDC();
}

bool OAED_WaitForCap(){
    /* ~~~ WARNING: THIS IS A BLOCKING FUNCTION ~~~ */
    /* Wait until the capacitor is ready. If meanwhile new data is available or
       a lead-off is detected return false.
       */
    while(!ECG_buffer_full){
        if(!lead_detected)
            return false;
        /* Check for new Z data */
        if(Z_buffer_full){
            OAED_CopyZBuffer();
            if(!OAED_EvaluateImpedanceDC())
                return false;
            OAED_AcquisitionZ();
        }
        /* Check for capacitor ready */
        if(capacitor_ready)
            return true;
        /* Wait 10 ms */
        CyDelay(10);
    }

    /* Get Data */
    OAED_CopyECGBuffer();
    return false;
}

/* End of function declarations */

/* [] END OF FILE */
