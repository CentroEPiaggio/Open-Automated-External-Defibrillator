/* ========================================
 *
 *  OPEN SOURCE AED
 * This file contains all USB
 * function and global variable
 * definitions.
 *
 * ========================================
*/

#include <project.h>
#include "OAED_USB.h"

/* Function declarations */
void OAED_USBInit(){
    USBUART_Start(USBFS_DEVICE, USBUART_5V_OPERATION);
    OAED_USBConfigure();
    return;
}

void OAED_USBConfigure(){
    if( USBUART_IsConfigurationChanged() != 0 ){
        if( USBUART_GetConfiguration() != 0 ){
            USBUART_CDC_Init();
        }
    }
    return;
}

void OAED_USBSendString(char Message[]){
    /* Check USBUART configuration. */
    OAED_USBConfigure();

    /* Wait CDC to be ready. */
    while( USBUART_CDCIsReady() == 0 ){}

    /* Send the message. */
    USBUART_PutString(Message);
    return;
}

void OAED_USBSendDataVoid(void* data, size_t nsize){
    /* Used with macro OAED_USBSendData(data) defined on header.            */

    /* Treat any data type as int8.
       If data type is wider than 8-bit, it is required a reconstruction on PC
       side. On this purpose LSB is sent first and MSB last.
       */

    OAED_USBSendData8((int8*)data, nsize );
    return;
}

void OAED_USBSendData8(int8 Message[], uint16 n){
    /* Check USBUART configuration. */
    OAED_USBConfigure();

    uint16 BC;              // Byte count
    uint16 MI = 0;          // Message index

    do{
        /* Wait cdc to be ready. */
        while( USBUART_CDCIsReady() == 0 ){}

        /* USBUART_PutData can only transfer 64 byte per call.
           Everything else is lost, so we divide the message in 64 byte
           packages.
           */
        BC = (n>64) ? 64 : n;

        /* Send message package. */
        USBUART_PutData( (const uint8*) &Message[MI], BC);

        /* Update the index and message dimension. */
        MI += BC;
        n -= BC;

    }while( n > 0 ); /* Repeat until the whole message is sent. */

    return;
}

void OAED_USBPrintECG(){    // DEPRECATED
    uint16 i;
    char Message[USBFS_BUFFER_SIZE];

    sprintf(Message,"-- Data ECG\n");
    OAED_USBSendString(Message);

    for( i = 0 ; i < ECG_DATA_SIZE ; i++ ){
        sprintf(Message,"%d - %d\n",i,DataECG[i]);
        OAED_USBSendString(Message);
    }
    OAED_USBSendString("-- Data ECG\n");

    return;
}

void OAED_USBPrintECGB(){    // DEPRECATED
    uint16 i;
    char Message[USBFS_BUFFER_SIZE];

    sprintf(Message,"-- Buffer ECG\n");
    OAED_USBSendString(Message);

    for( i = 0 ; i < ECG_DATA_SIZE ; i++ ){
        if(BufferECG[i] != 0){
            sprintf(Message,"%d - %d\n",i,BufferECG[i]);
            OAED_USBSendString(Message);
        }
    }
    OAED_USBSendString("-- Buffer ECG\n");

    return;
}

void OAED_USBPrintZ(){    // DEPRECATED
    uint16 i;
    char Message[USBFS_BUFFER_SIZE];

    sprintf(Message,"-- Data Z\n");
    OAED_USBSendString(Message);

    for( i = 0 ; i < Z_DATA_SIZE ; i++ ){
        sprintf(Message,"%d - %d\n",i,DataZ[i]);
        OAED_USBSendString(Message);
    }
    OAED_USBSendString("\n");

    return;
}

void OAED_USBPrintTimeStamp(){    // DEPRECATED BUT STILL IN USE
    #if(OAED_TIME)
    OAED_USBSendString("\n");
        OAED_GetTime();
        OAED_USBSendString(TimeStamp);
    OAED_USBSendString("\n");
    #endif
    return;
}

void OAED_USBPrintSystemImage(){    // DEPRECATED BUT STILL IN USE
    char Message[USBFS_BUFFER_SIZE];
    bool tmp;

    OAED_USBPrintTimeStamp();
    OAED_USBSendString("\n");
    sprintf(Message,"-- System Status\n");
    OAED_USBSendString(Message);
    sprintf(Message,"ECG_buffer_full    : %1d\n",ECG_buffer_full);
    OAED_USBSendString(Message);
    sprintf(Message,"ECG_data_pending   : %1d\n",ECG_data_pending);
    OAED_USBSendString(Message);
    sprintf(Message,"Z_buffer_full      : %1d\n",Z_buffer_full);
    OAED_USBSendString(Message);
    sprintf(Message,"lead_detected      : %1d\n",lead_detected);
    OAED_USBSendString(Message);
    sprintf(Message,"capacitor_ready    : %1d\n",capacitor_ready);
    OAED_USBSendString(Message);
    sprintf(Message,"ECG_enabled        : %1d\n",ECG_enabled);
    OAED_USBSendString(Message);

    sprintf(Message,"Patient Impedance  : %ld\n",(int32)floor(PatientImpedance));
    OAED_USBSendString(Message);

    OAED_USBSendString("\n");
    sprintf(Message,"-- Pin Status\n");
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Status_Led_Blue) != 0;
    sprintf(Message,"Blue led            : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Status_Led_Orange) != 0;
    sprintf(Message,"orange led         : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Status_Led_Green) != 0;
    sprintf(Message,"Green led          : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Charge_En_0) != 0;
    sprintf(Message,"Charge EN          : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Defibrillation_En_Inner) != 0;
    sprintf(Message,"Inner Defib EN     : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Defibrillation_En_Outer) != 0;
    sprintf(Message,"Outer Defib EN     : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Phase_Pin_Phi1) != 0;
    sprintf(Message,"H-Bridge Phase 1   : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Phase_Pin_Phi2) != 0;
    sprintf(Message,"H-Bridge Phase 2   : %1d\n",tmp);
    OAED_USBSendString(Message);
    /*
    tmp = CyPins_ReadPin(Comp_Pin_n) != 0;
    sprintf(Message,"n-Comparator       : %1d\n",tmp);
    OAED_USBSendString(Message);
    tmp = CyPins_ReadPin(Comp_Pin_p) != 0;
    sprintf(Message,"p-Comparator       : %1d\n",tmp);
    */
    OAED_USBSendString(Message);
    OAED_USBSendString("\n");


    return;
}

void OAED_USBSendI(){    // DEPRECATED
    char Message[USBFS_BUFFER_SIZE];
    //bool tmp;

    OAED_USBPrintTimeStamp();
    //OAED_USBSendString("\n");

    sprintf(Message,"Patient Impedance  : %ld\n",(int32)(1000 * PatientImpedance));
    OAED_USBSendString(Message);
    OAED_USBSendString("\n");
    return;
}

void OAED_USBSendSystemImage(){
    int16 data = 0;

    data = OAED_ShiftNAdd(data, ECG_buffer_full );
    data = OAED_ShiftNAdd(data, Z_buffer_full );
    data = OAED_ShiftNAdd(data, lead_detected );
    data = OAED_ShiftNAdd(data, ECG_data_pending );
    data = OAED_ShiftNAdd(data, capacitor_ready );
    data = OAED_ShiftNAdd(data, ECG_enabled );
    data = OAED_ShiftNAdd(data, Z_enabled );
    data = OAED_ShiftNAdd(data, CyPins_ReadPin(Charge_En_0) !=0 );
    data = OAED_ShiftNAdd(data, CyPins_ReadPin(Phase_Pin_Phi1) !=0 );
    data = OAED_ShiftNAdd(data, CyPins_ReadPin(Phase_Pin_Phi2) !=0 );
    //data = OAED_ShiftNAdd(data, CyPins_ReadPin(Comp_Pin_n) !=0 );
    OAED_USBSendData16(&data,1);

    return;
}

inline int16 OAED_ShiftNAdd(int16 data, bool flag){
    return (data<<1) + flag;
}

void OAED_USBSendECG(){
    /* OAED_USBSendData need explicit definition of what is sending. */
    extern int16 DataECG[ECG_DATA_SIZE];
    OAED_USBSendData(DataECG);
    return;
}

#if(RAW_MODE)
void OAED_USBSendRAW(){
    /* OAED_USBSendData need explicit definition of what is sending. */
    extern int16 DataRAW[RAW_DATA_SIZE];
    OAED_USBSendData16(DataRAW, 2000);
    OAED_USBSendData16(DataRAW + 4000, 2000);
    return;
}
#endif

void OAED_USBSendZ(){
    /* OAED_USBSendData need explicit definition of what is sending. */
    extern int16 DataZ[Z_DATA_SIZE];
    //OAED_USBSendData(DataZ);
    OAED_USBSendData16(DataZ, 2000);
    OAED_USBSendData16(DataZ + 4000, 2000);
    return;
}

void OAED_USBSendBuffer(){
    /* OAED_USBSendData need explicit definition of what is sending. */
    extern int16 BufferECG[ECG_DATA_SIZE];
    extern int16 BufferZ[Z_DATA_SIZE];
    OAED_USBSendData(BufferECG);
    OAED_USBSendData(BufferZ);
    return;
}

uint16 OAED_USBGetData(uint8 Message[], bool echo){
    /* Check USBUART configuration. */
    OAED_USBConfigure();

    /* This is a non-blocking function, so long there's no data to get. */
    if( USBUART_DataIsReady() == 0 ){
        return 0;
    }

    uint16 count;

    /* Get data. */
    count = USBUART_GetAll(Message);

    /* Echo the message received. */
    if(echo){
        char command;
        command = Message[0];
        OAED_USBSendString("\n");
        OAED_USBSendString(&command);
        OAED_USBSendString("\n");
    }
    return count;
}

bool OAED_USBGetCommand(){
    uint16 count;
    uint8 Message[USBFS_BUFFER_SIZE] = {' '};

    /* Fetch data. */
    count = OAED_USBGetData(Message, OAED_USB_ECHO);

    /* This is a non-blocking function, so long there's no data to get.     */
    if(count == 0) return false;

    /* The first character is reserved for the command. */
    switch(Message[0]){
        case 'S':
            /* Send System State Flags. */
            OAED_USBSendSystemImage();
            return true;
        #if(RAW_MODE)
        case 'R':
            OAED_USBSendRAW();
            return true;
        #endif
        case 'E':
            /* Send ECG Data array. */
            OAED_USBSendECG();
            return true;
        case 'Z':
            /* Send Z Data array. */
            OAED_USBSendZ();
            return true;
        case 'B':
            /* Send Z and ECG buffer array. */
            OAED_USBSendBuffer();
            return true;
        case 'K':
            /* Print System image as string. */
            OAED_USBPrintSystemImage();
            return true;
        case 'A':
            /* Send both ECG and RAW data */
            OAED_USBSendECG();
            #if(RAW_MODE)
                OAED_USBSendRAW();
            #endif
            return true;
        case 'C':
            Continuous_USBRAW = !Continuous_USBRAW;
            return true;
        case 'I':
            OAED_USBSendI();
            return true;
        default:
            return true;
    }

    return true;
}


void OAED_USBReceiveData(int16 Data[], uint16 n){
    int16 i = 0;
    int16 m = 0;
    int16 Count;
    int16 Temp;
    uint8 Message[512];

    while( m < n ){

        Count = OAED_USBGetData(Message, false);

        if(Count == 0)
            continue;

        i = 0;
        while(Count > 0){
            Temp = Message[i+1];
            Temp = Temp<<8;
            Temp = Message[i] + Temp;
            Data[m++] = Temp;

            Count -= 2 ;
            i += 2 ;
        }
    }
    return;
}

/* [] END OF FILE */
