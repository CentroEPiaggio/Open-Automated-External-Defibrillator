/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all time
 * functions prototyes and global variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_TIME_H
#define OAED_TIME_H

/* Include */
#include <project.h>
#include <stdio.h>
#include "OAED_Common.h"
/* End of Include */

/* Global Variables */
extern uint16   mscount;
extern uint16   seccount;
extern uint16   mincount;
extern char     TimeStamp[];
/* End of global variables */

/* Function prototypes */
void OAED_InitTime();
void OAED_SysTickISRCallback();
void OAED_GetTime();
/* End of function prototypes */

#endif

/* [] END OF FILE */
