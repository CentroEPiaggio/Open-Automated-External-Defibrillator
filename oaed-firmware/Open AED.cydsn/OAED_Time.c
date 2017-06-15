/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all time
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_Time.h"
uint16 mscount      = 0;
uint16 seccount     = 0;
uint16 mincount     = 0;
char   TimeStamp[13];

void OAED_InitTime(){
    uint8 i;

    mscount = 0;
    seccount = 0;
    mincount = 0;

    /* Configure the SysTick timer to generate interrupt every 1 ms and start
       its operation.
       */
    CySysTickStart();

    /* Find unused callback slot and assign it to the custom callback. */
    for ( i = 0 ; i < CY_SYS_SYST_NUM_OF_CALLBACKS ; i++ ){
        if (CySysTickGetCallback(i) == NULL){
            /* Set callback */
            CySysTickSetCallback(i, OAED_SysTickISRCallback);
            break;
        }
    }

    return;
}

void OAED_SysTickISRCallback(){
    /* Add 1 msec and update all the counters. */
    if( ++mscount == 1000 ){
        mscount = 0;
        if( ++seccount == 60 ){
            seccount = 0;
            mincount++;
        }
    }
    return;
}

void OAED_GetTime(){
    sprintf(TimeStamp, "[%3d:%2d:%3d] ", mincount, seccount, mscount);
    return;
}

/* [] END OF FILE */
