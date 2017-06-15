/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all DMA related
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include "OAED_DMA.h"

/* Variable declarations for DMA_DelSig_ECG */
uint8 DMA_DelSig_ECG_Chan;
uint8 DMA_DelSig_ECG_TD[1];

/* Variable declarations for DMA_DelSig_Z */
uint8 DMA_DelSig_Z_Chan;
uint8 DMA_DelSig_Z_TD[1];

#if(RAW_MODE)
/* Variable declarations for DMA_DelSig_RAW */
uint8 DMA_DelSig_RAW_Chan;
uint8 DMA_DelSig_RAW_TD[1];
#endif

/* Variable declarations for DMA_Filter_ECG */
uint8 DMA_Filter_ECG_Chan;
uint8 DMA_Filter_ECG_TD[1];

/* Variable declarations for DMA_Filter_Z */
uint8 DMA_Filter_Z_Chan;
uint8 DMA_Filter_Z_TD[4];

void OAED_DMA_Init(){

    /* DMA Configuration for DMA_DelSig */
    DMA_DelSig_ECG_Chan = DMA_DelSig_ECG_DmaInitialize(
        DMA_DelSig_ECG_BYTES_PER_BURST,
        DMA_DelSig_ECG_REQUEST_PER_BURST,
        HI16(DMA_DelSig_ECG_SRC_BASE),
        HI16(DMA_DelSig_ECG_DST_BASE)
    );
    DMA_DelSig_ECG_TD[0] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(
        DMA_DelSig_ECG_TD[0],
        DMA_DelSig_ECG_BYTES_PER_BURST,
        DMA_DelSig_ECG_TD[0],
        0
    );
    CyDmaTdSetAddress(
        DMA_DelSig_ECG_TD[0],
        LO16((uint32)ADC_DelSig_DEC_SAMP_PTR),
        LO16((uint32)Filter_STAGEA_PTR)
    );
    CyDmaChSetInitialTd(
        DMA_DelSig_ECG_Chan,
        DMA_DelSig_ECG_TD[0]
    );

    /* DMA Configuration for DMA_DelSig_Z */
    DMA_DelSig_Z_Chan = DMA_DelSig_Z_DmaInitialize(
        DMA_DelSig_Z_BYTES_PER_BURST,
        DMA_DelSig_Z_REQUEST_PER_BURST,
        HI16(DMA_DelSig_Z_SRC_BASE),
        HI16(DMA_DelSig_Z_DST_BASE)
    );
    DMA_DelSig_Z_TD[0] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(
        DMA_DelSig_Z_TD[0],
        DMA_DelSig_Z_BYTES_PER_BURST,
        DMA_DelSig_Z_TD[0],
        0
    );
    CyDmaTdSetAddress(
        DMA_DelSig_Z_TD[0],
        LO16((uint32)ADC_DelSig_DEC_SAMP_PTR),
        LO16((uint32)Filter_STAGEB_PTR)
    );
    CyDmaChSetInitialTd(
        DMA_DelSig_Z_Chan,
        DMA_DelSig_Z_TD[0]
    );

#if(RAW_MODE)
    /* DMA Configuration for DMA_DelSig_RAW */
    DMA_DelSig_RAW_Chan = DMA_DelSig_RAW_DmaInitialize(
        DMA_DelSig_RAW_BYTES_PER_BURST,
        DMA_DelSig_RAW_REQUEST_PER_BURST,
        HI16(DMA_DelSig_RAW_SRC_BASE),
        HI16(DMA_DelSig_RAW_DST_BASE)
    );
    DMA_DelSig_RAW_TD[0] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(
        DMA_DelSig_RAW_TD[0],
        DMA_DelSig_RAW_BYTES_PER_BURST * RAW_CACHE_SIZE,
        DMA_DelSig_RAW_TD[0],
        DMA_DelSig_RAW__TD_TERMOUT_EN | CY_DMA_TD_INC_DST_ADR
    );
    CyDmaTdSetAddress(
        DMA_DelSig_RAW_TD[0],
        LO16((uint32)ADC_DelSig_DEC_SAMP_PTR),
        LO16((uint32)CacheRAW)
    );
    CyDmaChSetInitialTd(
        DMA_DelSig_RAW_Chan,
        DMA_DelSig_RAW_TD[0]
    );
#endif

    /* DMA Configuration for DMA_Filter_ECG */
    DMA_Filter_ECG_Chan = DMA_Filter_ECG_DmaInitialize(
        DMA_Filter_ECG_BYTES_PER_BURST,
        DMA_Filter_ECG_REQUEST_PER_BURST,
        HI16(DMA_Filter_ECG_SRC_BASE),
        HI16(DMA_Filter_ECG_DST_BASE)
    );
    DMA_Filter_ECG_TD[0] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(
        DMA_Filter_ECG_TD[0],
        DMA_Filter_ECG_BYTES_PER_BURST * ECG_CACHE_SIZE,
        DMA_Filter_ECG_TD[0],
        DMA_Filter_ECG__TD_TERMOUT_EN | TD_INC_DST_ADR
    );
    CyDmaTdSetAddress(
        DMA_Filter_ECG_TD[0],
        LO16((uint32)Filter_HOLDA_PTR),
        LO16((uint32)CacheECG)
    );
    CyDmaChSetInitialTd(
        DMA_Filter_ECG_Chan,
        DMA_Filter_ECG_TD[0]
    );

    /* DMA Configuration for DMA_Filter_Z */
    DMA_Filter_Z_Chan = DMA_Filter_Z_DmaInitialize(
        DMA_Filter_Z_BYTES_PER_BURST,
        DMA_Filter_Z_REQUEST_PER_BURST,
        HI16(DMA_Filter_Z_SRC_BASE),
        HI16(DMA_Filter_Z_DST_BASE)
    );
    DMA_Filter_Z_TD[0] = CyDmaTdAllocate();
    DMA_Filter_Z_TD[1] = CyDmaTdAllocate();
    DMA_Filter_Z_TD[2] = CyDmaTdAllocate();
    DMA_Filter_Z_TD[3] = CyDmaTdAllocate();
    CyDmaTdSetConfiguration(
        DMA_Filter_Z_TD[0],
        (DMA_Filter_Z_BYTES_PER_BURST * Z_DATA_SIZE) / 4,
        DMA_Filter_Z_TD[1],
        TD_INC_DST_ADR
    );
    CyDmaTdSetConfiguration(
        DMA_Filter_Z_TD[1],
        (DMA_Filter_Z_BYTES_PER_BURST * Z_DATA_SIZE) / 4,
        DMA_Filter_Z_TD[2],
        TD_INC_DST_ADR
    );
    CyDmaTdSetConfiguration(
        DMA_Filter_Z_TD[2],
        (DMA_Filter_Z_BYTES_PER_BURST * Z_DATA_SIZE) / 4,
        DMA_Filter_Z_TD[3],
        TD_INC_DST_ADR
    );
    CyDmaTdSetConfiguration(
        DMA_Filter_Z_TD[3],
        (DMA_Filter_Z_BYTES_PER_BURST * Z_DATA_SIZE) / 4,
        DMA_Filter_Z_TD[0],
        DMA_Filter_Z__TD_TERMOUT_EN | TD_INC_DST_ADR
    );
    CyDmaTdSetAddress(
        DMA_Filter_Z_TD[0],
        LO16((uint32)Filter_HOLDB_PTR),
        LO16((uint32)BufferZ)
    );
    CyDmaTdSetAddress(
        DMA_Filter_Z_TD[1],
        LO16((uint32)Filter_HOLDB_PTR),
        LO16((uint32)(BufferZ + Z_DATA_SIZE / 4))
    );
    CyDmaTdSetAddress(
        DMA_Filter_Z_TD[2],
        LO16((uint32)Filter_HOLDB_PTR),
        LO16((uint32)(BufferZ + Z_DATA_SIZE / 2))
    );
    CyDmaTdSetAddress(
        DMA_Filter_Z_TD[3],
        LO16((uint32)Filter_HOLDB_PTR),
        LO16((uint32)(BufferZ + Z_DATA_SIZE * 3 / 4))
    );
    CyDmaChSetInitialTd(
        DMA_Filter_Z_Chan,
        DMA_Filter_Z_TD[0]
    );

    return;
}

void OAED_DMAECGStart(){
    /* Clear ECG DMA requests */
    CyDmaClearPendingDrq(DMA_DelSig_ECG_Chan);
    CyDmaClearPendingDrq(DMA_Filter_ECG_Chan);

    /* Enable ECG DMA */
    CyDmaChEnable(DMA_DelSig_ECG_Chan, 1);
    CyDmaChEnable(DMA_Filter_ECG_Chan, 1);

    #if(RAW_MODE)
    CyDmaChEnable(DMA_DelSig_RAW_Chan, 1);
    #endif

    return;

}

void OAED_DMAECGStop(){

    OAED_AcquisitionECGPause();

    /* Disable ECG DMA */
    CyDmaChDisable(DMA_DelSig_ECG_Chan);
    CyDmaChDisable(DMA_Filter_ECG_Chan);

    #if(RAW_MODE)
    CyDmaChDisable(DMA_DelSig_RAW_Chan);
    #endif

    return;
}

void OAED_DMAZStart(){
    /* Clear Z DMA requests */
    CyDmaClearPendingDrq(DMA_DelSig_Z_Chan);
    CyDmaClearPendingDrq(DMA_Filter_Z_Chan);

    /* Enable Z DMA */
    CyDmaChEnable(DMA_DelSig_Z_Chan, 1);
    CyDmaChEnable(DMA_Filter_Z_Chan, 1);

    return;
}

void OAED_DMAZStop(){
    /* Disable Z DMA */
    CyDmaChDisable(DMA_DelSig_Z_Chan);
    CyDmaChDisable(DMA_Filter_Z_Chan);

    return;
}

/* [] END OF FILE */
