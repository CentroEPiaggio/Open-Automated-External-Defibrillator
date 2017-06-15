/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all system status
 * functions prototyes and global variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_SYSTEMSTATUS
#define OAED_SYSTEMSTATUS

/* Include */
#include <project.h>
#include "OAED_Common.h"
/* Include */

/* System Status */
enum system_status {
    lead_off,                                // Lead-off
    measurement_mode,                        // Lead detected, but no VT/VF
    charging_capacitor,                      // VT/VF detected
    discharge_enabled,                       // VT/VF detected, capacitor ready
    internal_discharge                       // Safety mode
};
/* End of System status */

/* Function prototypes */
char OAED_LeadOffMode();
char OAED_MeasurementMode();
char OAED_ChargingMode();
char OAED_DischargeEnabledMode();
char OAED_InternalDischargeMode();

void OAED_SetSystemStatus(char);
/* End of Function prototypes */

#endif

/* [] END OF FILE */
