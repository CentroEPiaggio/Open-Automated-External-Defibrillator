/* ========================================
 *
 *  OPEN SOURCE AED
 * Main
 *
 * ========================================
*/

#include <project.h>
#include "OAED_Common.h"

int main(){
    /* Local variables declaration */
    char Status = measurement_mode;

    /* System initialization */
    OAED_Init();

    /* Main Loop */
    for(;;){
        /* Enable or disable specific state functionalities */
        OAED_SetSystemStatus(Status);

        /* Check for pc commands */
        OAED_USBGetCommand();

        switch(Status){
            case lead_off:
                Status = OAED_LeadOffMode();
                continue;
            case measurement_mode:
                Status = OAED_MeasurementMode();
                continue;
            case charging_capacitor:
                Status = OAED_ChargingMode();
                continue;
            case discharge_enabled:
                Status = OAED_DischargeEnabledMode();
                continue;
            case internal_discharge:
                Status = OAED_InternalDischargeMode();
                continue;
            default:
                /* This shouldn't happen. */
                Status = lead_off;
                continue;
        }
    }
}

/* [] END OF FILE */
