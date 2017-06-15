/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all USB
 * functions prototyes and global variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_USB_H
#define OAED_USB_H

/* Include */
#include <project.h>
#include <stdio.h>
#include "OAED_Common.h"
#if(OAED_TIME)
    #include "OAED_Time.h"
#endif
/* End of include */

/* Numeric Constants */
#define USBFS_DEVICE        0       // Device
#define USBFS_BUFFER_SIZE   512     // Buffer Size (max 512)
#define OAED_USB_ECHO       false   // GetData echoes (Default false)
/* End of numeric constants */

/* Macro */
/* Send data as 8-bit array. LSB first. */
#define OAED_USBSendData(message)({\
                        uint16 _n = sizeof(message)/sizeof(message[0]);\
                        int8 _tmp[3];\
                        _tmp[0] = 8*(int8)(sizeof(message[0]));\
                        _tmp[1] = (int8)(_n&0x00ff);\
                        _tmp[1] = (int8)(_n>>8);\
                        OAED_USBSendData8(_tmp, 3);\
                        OAED_USBSendDataVoid(message, _n);\
                    })
#define OAED_USBSendData16(message, n)({\
                        int8 _tmp[3];\
                        _tmp[0] = (16);\
                        _tmp[1] = n&0x00ff;\
                        _tmp[2] = n>>8;\
                        OAED_USBSendData8(_tmp, 3);\
                        OAED_USBSendData8((int8*) message, (uint16)(2*n));\
                    })
#define OAED_USBSendData32(message, n)({\
                        int8 _tmp[3];\
                        _tmp[0] = (16);\
                        _tmp[1] = n&0x00ff;\
                        _tmp[2] = n>>8;\
                        OAED_USBSendData8(_tmp, 3);\
                        OAED_USBSendData8((int8*) message, (uint16)(4*n));\
                    })
/* End of Macro*/

/* Global variables */
/* End of global variables */

/* Function prototypes */

    /* WARNING: Any Send/Print function is a blocking function. */

/* Basic functions */
void OAED_USBInit();
void OAED_USBConfigure();
void OAED_USBSendString(char[]);
void OAED_USBSendData8(int8[], uint16);
void OAED_USBSendDataVoid(void*, size_t);
bool OAED_USBGetCommand();

/* Send data as String. MOSTLY DEPRECATED. */
void OAED_USBPrintECG();
void OAED_USBPrintECGB();
void OAED_USBPrintZ();
void OAED_USBPrintSystemImage();
void OAED_USBPrintTimeStamp();

/* Interactive functions */
uint16 OAED_USBGetData(uint8[], bool);
void OAED_USBReceiveData(int16[], uint16);

/* Send data */
void OAED_USBSendSystemImage();
void OAED_USBSendECG();
void OAED_USBSendZ();
void OAED_USBSendBuffer();
inline int16 OAED_ShiftNAdd(int16,bool);

#if(RAW_MODE)
void OAED_USBSendRAW();
#endif
/* End of function prototypes */

#endif

/* [] END OF FILE */
