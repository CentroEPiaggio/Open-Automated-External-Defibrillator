/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all DMA related
 * function prototypes and variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_DMA_H
#define OAED_DMA_H

/* Include */
#include <project.h>
#include "OAED_Common.h"
/* End of Include*/

/* Numeric constants */
/* Defines for DMA_DelSig */
#define DMA_DelSig_ECG_BYTES_PER_BURST 2
#define DMA_DelSig_ECG_REQUEST_PER_BURST 1
#define DMA_DelSig_ECG_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_DelSig_ECG_DST_BASE (CYDEV_PERIPH_BASE)

/* Defines for DMA_DelSig_Z */
#define DMA_DelSig_Z_BYTES_PER_BURST 2
#define DMA_DelSig_Z_REQUEST_PER_BURST 1
#define DMA_DelSig_Z_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_DelSig_Z_DST_BASE (CYDEV_PERIPH_BASE)

#if(RAW_MODE)
/* Defines for DMA_DelSig_RAW */
#define DMA_DelSig_RAW_BYTES_PER_BURST 2
#define DMA_DelSig_RAW_REQUEST_PER_BURST 1
#define DMA_DelSig_RAW_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_DelSig_RAW_DST_BASE (CYDEV_SRAM_BASE)
#endif

/* Defines for DMA_Filter_ECG */
#define DMA_Filter_ECG_BYTES_PER_BURST 2
#define DMA_Filter_ECG_REQUEST_PER_BURST 1
#define DMA_Filter_ECG_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_Filter_ECG_DST_BASE (CYDEV_SRAM_BASE)

/* Defines for DMA_Filter_Z */
#define DMA_Filter_Z_BYTES_PER_BURST 2
#define DMA_Filter_Z_REQUEST_PER_BURST 1
#define DMA_Filter_Z_SRC_BASE (CYDEV_PERIPH_BASE)
#define DMA_Filter_Z_DST_BASE (CYDEV_SRAM_BASE)
/* End of numeric constants */

/* Function prototypes */
void OAED_DMA_Init();
void OAED_DMAECGStart();
void OAED_DMAECGStop();
void OAED_DMAZStart();
void OAED_DMAZStop();
/* End of Function prototypes */

#endif
/* [] END OF FILE */
