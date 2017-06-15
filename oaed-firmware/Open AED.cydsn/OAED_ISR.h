/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all ISR related
 * function prototypes and variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_ISR_H
#define OAED_ISR_H

/* Include */
#include <project.h>
#include <stdbool.h>
#include "OAED_Defibrillation.h"
/* End of Include */

/* Macro */
/* RAW cache interrupt control */
#if(RAW_MODE)
#define OAED_ISRRAWENABLE()  isr_CacheRAWReplenished_Enable()
#define OAED_ISRRAWDISABLE() isr_CacheRAWReplenished_Disable()
#endif
/* End of macro */

/* Custom ISR prototypes */
CY_ISR_PROTO(isr_BufferZRe);
CY_ISR_PROTO(isr_CacheECGRe);
CY_ISR_PROTO(isr_LeadOff);
CY_ISR_PROTO(isr_LeadOn);
CY_ISR_PROTO(isr_CapReady);
CY_ISR_PROTO(isr_CapLow);
CY_ISR_PROTO(isr_Defibrillation);
#if(RAW_MODE)
CY_ISR_PROTO(isr_CacheRAWRe);
#endif
/* End of ISR prototypes */

/* Function prototypes */
void OAED_ISRInit();
/* ECG cache interrupt control */
inline void OAED_ISRECGEnable();
inline void OAED_ISRECGDisable();
/* Z buffer interrupt control */
inline void OAED_ISRZEnable();
inline void OAED_ISRZDisable();
/* End of Function prototypes */

#endif


/* [] END OF FILE */
