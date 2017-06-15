/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all ECG pattern
 * recognition algorithms functions
 * prototyes and global variable
 * declarations.
 *
 * ========================================
*/


#ifndef OAED_ECGALGORITHMS_H
#define OAED_ECGALGORITHMS_H

/* Include */
#include <project.h>
#include <math.h>
#include <stdlib.h>
#include "OAED_Common.h"
/* End of include */

/* Numeric constants */
//TCI
#define TCI_THRESH              0.2          // TCI binarization threshold
#define TCI_CRIT                400          // TCI critical value [ms]

#define TCI_MU_VF               105          // Maan TCI for VF [ms]
#define TCI_SIGMA_VF            6.5          // Standard deviation for VF [ms]
#define TCI_SIGMA2_VF           (TCI_SIGMA_VF * TCI_SIGMA_VF)

#define TCI_MU_VT               220          // Maan TCI for VT [ms]
#define TCI_SIGMA_VT            16.5         // Standard deviation for VT [ms]
#define TCI_SIGMA2_VT           (TCI_SIGMA_VT * TCI_SIGMA_VT)

#define TCI_ALFA                0.01         // Alfa
#define TCI_BETA                0.01         // Beta
                                             // The next are just umeric
                                             // constants pre-calculated to ease
                                             // real-time evaluations.
#define TCI_F_VT                (2 * log((1-TCI_BETA) / TCI_ALFA))
#define TCI_F_VF                (2 * log(TCI_BETA / (1-TCI_ALFA)))
#define TCI_F_VX                (2 * log(TCI_SIGMA_VT / TCI_SIGMA_VF))

// VF filter
#define VFf_CRIT                0.625       // Critical leakage

// TCSC
#define TCSC_Ls                 3           // Segment width [s]
#define TCSC_NS                 (ECG_SIGNAL_LENGTH - TCSC_Ls + 1)
                                            // Number of segments in one window
#define TCSC_NTS                (ECG_SIGNAL_LENGTH + TCSC_NS)
                                            // Total number of segments
#define TCSC_THRESH             0.2         // TCSC binarization threshold
#define TCSC_CRIT               0.48        // TCSC N critical value
                                            // 48% is high specificity setting
                                            // for more sensibility it is
                                            // possible to use 25% < CRIT < 35%

// PSR
#define PSR_TAU                 0.5         // Tau [s]
#define PSR_D0                  0.20        // Critical value
#define PSR_GRID_N              40          // Grid divisions
#define PSR_TAU_N               (0.5 * ECG_SAMPLING_F)

// HILB
#define HILB_D0                 0.25        // Critical value
#define HILB_GRID_N             40          // Grid divisions

// FFT
#define FFTN                    2048
#define FORWARD_FFT             false
#define INVERSE_FFT             true

// SCA evaluation
#define OAED_POSITIVETHRESH     3           // Number of positive algorithms
                                            // positive to assert SCA
/* End of numeric constants */

/* Macro */
#define OAED_TCSC_COSWIN(t)     (0.5 * (1 - cos(4*PI*(t)) ))
/* End of macro */

/* Variable definitions */
/* End of variable definitions */

/* Function prototypes */
bool OAED_TCI();
bool OAED_VFfilter();
bool OAED_TCSC();
bool OAED_PSR();
bool OAED_HILB();

bool OAED_ECGAnalysis();

#endif

/* [] END OF FILE */
