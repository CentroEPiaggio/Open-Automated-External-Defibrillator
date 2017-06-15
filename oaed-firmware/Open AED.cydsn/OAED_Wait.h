/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all waiting
 * functions prototyes and global variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_WAIT_H
#define OAED_WAIT_H

/* Include */
#include <project.h>
#include "OAED_Common.h"
/* End of include */

/* Function prototypes */
void OAED_WaitLeadOn();
bool OAED_WaitForData();
bool OAED_WaitForCap();
bool OAED_WaitForZ();
/* End of function prototypes */

#endif
/* [] END OF FILE */
