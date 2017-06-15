/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all acquisition
 * functions prototyes and global variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_ACQUISITION_H
#define OAED_ACQUISITION_H

/* Include */
#include <project.h>
#include "OAED_Common.h"
/* End of include */

/* Macro */
/* Start ECG acquisition DMA. */
#define OAED_AcquisitionECGStart() OAED_DMAECGStart()
/* Stop ECG acquisition DMA, call this function only in lead-off mode. */
#define OAED_AcquisitionECGStop() OAED_DMAECGStop()
/* End of macro */

/* Function prototypes */
void OAED_AcquisitionInit();

bool OAED_AcquisitionECGUnpause();
inline void OAED_AcquisitionECGPause();

void OAED_AcquisitionZ();
/* End of function prototypes */

#endif
/* [] END OF FILE */
