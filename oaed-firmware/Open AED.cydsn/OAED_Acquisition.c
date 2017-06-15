/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all acquisition
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_Acquisition.h"

/* Function declarations */
void OAED_AcquisitionInit(){

    /* Never stop DelSig ADC or Z DMA. */
    /* Power up and initialize DelSig ADC */
    ADC_DelSig_Start();
    /* Disable the Delta Sigma ADC ISR as it is not required */
    ADC_DelSig_IRQ_Disable();
    /* Start ADC conversions */
    ADC_DelSig_StartConvert();
    /* Start Z DMA */
    OAED_DMAZStart();
    /* Start ECG DMA */
    OAED_AcquisitionECGStart();

    /* Start IDAC source and drain for lead off detection. */
    /* This should also trigger the lead-on/off interrupt. */
    IDAC_Drain_Start();
    IDAC_Source_Start();

    /* Start p and n lead-on/off comparators. */
    Comp_n_Start();

    return;
}

void OAED_AcquisitionZ(){
    /* If already running return. */
    if(Z_enabled)
        return;

    /* Check buffer status */
    if(Z_buffer_full)
        OAED_CopyZBuffer();

    /* Enable Z interrupt */
    OAED_ISRZEnable();
    return;
}

bool OAED_AcquisitionECGUnpause(){
    /* Unpause ECG acquisition. */

    /* If lead-off detected return false. */
    if(!lead_detected)
        return false;

    /* Start Z acquisition */
    OAED_AcquisitionZ();

    /* Check if ECG is already functioning. */
    if(ECG_enabled)
        return true;

    /* Enable ECG cache interrupt */
    OAED_ISRECGEnable();
    #if(RAW_MODE)
    OAED_ISRRAWENABLE();
    #endif

    return true;
}

inline void OAED_AcquisitionECGPause(){
    /* Pause ECG acquisition. */
    /* Check if ECG acquisition isn't running, then proceede to stop it. */
    if(ECG_enabled){
        OAED_ISRECGDisable();
        #if(RAW_MODE)
        OAED_ISRRAWDISABLE();
        #endif
    }
}

/* End of function declarations */

/* [] END OF FILE */
