/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all defibrillation
 * related function prototypes and variable
 * declarations.
 *
 * ========================================
*/

#ifndef OAED_DEFIBRILLATION_H
#define OAED_DEFIBRILLATION_H

/* include */
#include <project.h>
#include <stdbool.h>
#include <math.h>
#include "OAED_Common.h"
/* End of include */

/* Numeric constants */
#define OPEN_CIRCUIT    (uint8)(0b00000000)
#define PHI_1           (uint8)(0b00000010)
#define PHI_2           (uint8)(0b00000001)

#define PWM_LENGTH      5000                                        // [us]
#define PWM_DUTY        50                                          // [%]
#define PWM_ON          (uint16)( PWM_LENGTH * PWM_DUTY / 100 )
#define PWM_OFF         (uint16)( PWM_LENGTH - PWM_ON )

#define OAED_DISCHARGE_TIME (- Patient_impedance * C * log( 1 - 2 * U/U_MAX ))
                                                                    // [s]
#define OAED_DISCHARGE_TIME_MS (1000 * OAED_DISCHARGE_TIME)         // [ms]
#define OAED_DISCHARGE_TIME_US (1000 * OAED_DISCHARGE_TIMEms)       // [us]
/* End of numeric constants */

/* Macro */
#define OAED_HBridgeControl(phase) (Phase_Reg_Write( phase ))
/* End of Macro*/

/* Function prototypes */
void OEAD_EnableDefibrillation();   // Need new name
void OAED_DisableDefibrillation();  // Same

inline void OAED_ArmDefibrillator();
inline void OAED_DisarmDefibrillator(bool);

uint32 OAED_EvaluateDischargeTime();

void OAED_InternalDischarge();
void OAED_MonophasicDefibrillation();
void OAED_BiphasicDefibrillation(uint8);
void OAED_PolyphasicDefibrillation(uint8);
/* End of function prototypes */

#endif



/* [] END OF FILE */
