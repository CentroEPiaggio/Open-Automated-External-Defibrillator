/* ========================================
 *
 *  OPEN SOURCE AED
 * This header contains all ECG pattern
 * recognition algorithms functions and
 * Global variable definitions.
 *
 * ========================================
*/
#include "OAED_ECGAlgorithms.h"

/* The algorithms are not described here, for brevity's sake.
   Please refer to the thesis to know more.
 */

bool OAED_TCI(){
    /*
        In order to achieve better performance (in terms of decision making), i
        have decided to use also the data obtained during the last 4 second
        window. This drastically increase the number of data we can use for TCI,
        but require some sort of optimization in order to avoid saving the whole
        ECG window, which would lead to memory/time waste.
        Namely we need to save the TCI values calculated, the T1-T3, and N values
        of the last second of the current ECG window.
        - N is stored in the static variable LastN
        - T1-T3 in the static array LastT[3]
        - TCI are saved in the static array called TCI. In this data is organized
          so as the first ECG_SIGNAL_LENGTH-1 values are those of the current
          ECG window; the last ECG_SIGNAL_LENGTH-1 values are those of the last
          ECG window; and the middle value is the last second of the previous
          window, which can only be evaluated having the subsequent data.

        An example with ECG_SIGNAL_LENGTH = 4 is the following:

        time:           0-+-+-+-4-+-+-+-8-+-+-+-12-+->
        first call      0-+-+-+-4
        TCI values       x'1'2'x
        second call     0-+-+-+-4-+-+-+-8
        TCI values      -x'1'2'3-4'5'6'x-
        third call              4-+-+-+-8-+-+-+-12
        TCI values              -4'5'6'7-8'9'10'x-

                                TCI array content
            position    |  0  |  1  |  2  :  3  :  4  |  5  |  6  |
                        -------------------------------------------
        first call      |  \  |  1  |  2  :  \  :  \  |  \  |  \  |
        second call     |  4  |  5  |  6  :  3  :  1  |  2  |  \  |
        third call      |  8  |  9  | 10  :  7  :  4  |  5  |  6  |
        fourth call     | 12  | 13  | 14  : 11  :  8  |  9  | 10  |
        ...             | y-3 | y-2 | y-1 :  x  : x-3 | x-2 | x-1 |
                        <-------new-------><mid><-------old------->
    */
    /* One array for Tx, each element represent a second in the current segment.
       The last element is an exception because it is swapped with the last
       element of the previous call.
    */
    float   T1[ECG_SIGNAL_LENGTH],
            T2[ECG_SIGNAL_LENGTH],
            T3[ECG_SIGNAL_LENGTH],
            T4[ECG_SIGNAL_LENGTH];
    /* The last Ts are made static in order to use it in the next analysis */
    static float        LastT[3];
    float               Max[ECG_SIGNAL_LENGTH];             // Maximum values
    bool                BinaryECG[ECG_DATA_SIZE];           // Binary ECG
    int16               N[ECG_SIGNAL_LENGTH];               // Number of pulses
    static int16        LastN;                              // Last N of previous
                                                            // analysis
    static float        TCI[2*ECG_SIGNAL_LENGTH - 1];       // TCI values
    float               TCImean = 0;                        // Mean TCI
    uint8               i = 0;                              // For counter
    uint16              j;                                  // For counter

    /* The first step is finding the maximum value for each second */
    for( i = 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        Max[i] = -1;
        for( j = i * ECG_SAMPLING_F; j < (i+1) * ECG_SAMPLING_F ; j++ )
            if(DataECG[j] > Max[i])
                Max[i] = DataECG[j];
    }

    /* The second step is to binarize the ECG signal with a threshold */

    /* By default the threshold is 20% maximum */
    for( i = 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        int16 Threshold = Max[i] * TCI_THRESH;
        for( j = i * ECG_SAMPLING_F; j < (i+1) * ECG_SAMPLING_F ; j++ )
            if(Threshold > 0)
                BinaryECG[j] = (DataECG[j] > Threshold);
            else
                BinaryECG[j] = (DataECG[j] > Max[i] * (2 - TCI_THRESH));
    }

    /* The third step is evaluating the T values */

    /* T2 is defined as the time elapsed until the first value not 0, from the
        beginning of each 1second segment. */
    for( i = 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        for( j = i * ECG_SAMPLING_F; j < (i+1) * ECG_SAMPLING_F ; j++ )
            if(BinaryECG[j]){
                T2[i] = (float)(j) / ECG_SAMPLING_F - i;
                break;
            }
    }

    /* T3 is defined as the time elapsed from the last value not 0 until
        the end for each segment. */
    for( i = 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        for( j = (i+1) * ECG_SAMPLING_F ; j > i * ECG_SAMPLING_F ; j-- ){
            if(BinaryECG[j]){
                T3[i] = i + 1 - (float)(j) / ECG_SAMPLING_F ;
                break;
            }
        }
    }

    /* T1 and T4 are equal to the last T3 and the next T2 respectively. */
    for( i = 0 ; i < ECG_SIGNAL_LENGTH ; i++){
        T1[i] = (i == 0) ? LastT[2] : T3[i-1];
        T4[i] = (i == ECG_SIGNAL_LENGTH) ? 0 : T2[i+1];
    }

    /* The fourth step is pulse counting in the binary ECG for each segment. */
    for( i = (EventCounter == 0) ? 1 : 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        N[i] = 0;
        /* Count each transitions */
        for( j = i * ECG_SAMPLING_F; j < 1 + (i+1) * ECG_SAMPLING_F ; j++ )
            if(BinaryECG[j] != BinaryECG[j+1])
                N[i]++;
        //N[i] = ceil( N[i]/2 );
        N[i] = (N[i]>>1) + N[i]%2;
        /* If a pulse is between two segments, T2 or T3 are zeros. In that case
           there is a odd number of transitions, hence the ceil fix it adding 1.
           If both T3 and T2 are zeros the ceil operator adds nothing, therefore
           we have to add 1 manually.
         */
        if(T2[i] == 0 && T3[i] == 0)
            N[i]++;
    }

    /* The fifth step is the actual TCI calculation. */
    /* The last second can't be evaluated at this time, we save it for the
       next time this function is called. We swap its values with those
       supposedly saved on the last call, so we can use them. In this way the
       last element of each Tx array will contain the Tx related to the last
       second of the last call.
     */
    OAED_SWAP( T1[ECG_SIGNAL_LENGTH - 1], LastT[0] );
    OAED_SWAP( T2[ECG_SIGNAL_LENGTH - 1], LastT[1] );
    OAED_SWAP( T3[ECG_SIGNAL_LENGTH - 1], LastT[2] );
    OAED_SWAP( N[ECG_SIGNAL_LENGTH - 1], LastN );
    T4[ECG_SIGNAL_LENGTH - 1] = T2[0];
    for( i = (EventCounter == 0) ? 1 : 0 ; i < ECG_SIGNAL_LENGTH ; i++ ){
        /* If this is the first registered event we cannot evaluate neither the
           first, nor the last second (which should correspond to the last
           second of the last call).
        */
        if( EventCounter == 0 )
            if( i == ECG_SIGNAL_LENGTH-1 ) break;
        /* If T1/T2 or T3/T4 are zero we must avoid the 0/0 division */
        float t12 = 0;
        float t34 = 0;
        if(T2[i] != 0)
            t12 = T2[i]/( T1[i]+T2[i] );
        if(T3[i] != 0)
            t34 = T3[i]/( T3[i]+T4[i] );
        TCI[i] = 1000 / ( N[i]-1 + t12 + t34 );
    }

    /* The TCI mean is evaluated using also the values from the last call, if
       availables.
    */
    uint8 Count = 0;
    for( i = (EventCounter == 0) ? 1 : 0 ; i < 2 * ECG_SIGNAL_LENGTH - 1 ; i++ ){
        if(EventCounter == 0){
            if(i == ECG_SIGNAL_LENGTH - 1)
                break;
        }
        if(EventCounter == 1)
            if(i == 2 * ECG_SIGNAL_LENGTH - 2)
                break;

        TCImean += TCI[i];
        Count++;
    }
    TCImean /= Count;

    /* Save the TCI values for later */
    j = ECG_SIGNAL_LENGTH;
    for( i = (EventCounter == 0) ? 1 : 0 ; i < ECG_SIGNAL_LENGTH - 1 ; i++){
        TCI[j++] = TCI[i];
    }

    /* The last step is the comparison of the mean TCI value with the pre
       established critical value and the statistical inference.
    */
    if(TCImean >= TCI_CRIT) // if the TCI mean is higher than the critical value
        return false;       // the patient rhythm is normal.

    float F = 0;        /* F calculus */
    if( EventCounter == 0 )
        Count++;
    for( i = (EventCounter == 0) ? 1 : 0 ; i < Count ; i++ ){
        F += (float)(pow((TCI[i] - TCI_MU_VF), 2)) / (float)(TCI_SIGMA2_VF);
        F -= (float)(pow((TCI[i] - TCI_MU_VT), 2)) / (float)(TCI_SIGMA2_VT);
    }
    /* F evaluation */
    if( F >= (TCI_F_VF + Count * TCI_F_VX) )
        return true;        // Ventricular tachicardia
    if( F <= (TCI_F_VT + Count * TCI_F_VX) )
        return true;        // Ventricular fibrillation

    return false;           // Rhythm is not normal, but we can't confirm
                            // neither VT, nor VF.
}

bool OAED_VFfilter(){
    float Den, Num;     // Temporary denominator and numerator
    float L;            // Leakage
    uint16 T2;          // Half-period
    uint16 i;           // For counter

    /* First we find the mean period T. */
    Num = 0;
    Den = 0;
    for( i = 1; i < ECG_DATA_SIZE ; i++ ){
        Num += abs(DataECG[i]);
        Den += abs(DataECG[i] - DataECG[i-1]);
    }
    /* T = 2 * PI * Num / Den + 1 */
    /* We need the half-period T2 = T/2 */
    T2 = floor(PI * Num / Den + 0.5);
    /* Although the variable T may seem to indicate a time, it is actually an
       adimensional number. Hence it indicate a period of samples.
    */

    /* The second step is finding the mean leakage */
    Num = 0;
    Den = 0;
    for( i = T2; i < ECG_DATA_SIZE ; i++ ){
        Num += abs(DataECG[i] + DataECG[i-T2]);
        Den += abs(DataECG[i]) + abs(DataECG[i-T2]);
    }
    L = Num / Den;

    /* The final step is the rhythm assertion. */
    if( L < VFf_CRIT )
        return true;        // VF confirmed
    // else
    return false;           // Normal sinus rhythm
}

bool OAED_TCSC(){
    static  float N[TCSC_NTS];                           // N values
    float   Nmean = 0;                                   // N mean value
    float   Max[TCSC_NTS];                               // ECG maximum
    int16   i;                                           // For counter

    /* A note about the choice made during the writing of this function.
       On the first iteration, the function will save and consider only the first
       part of the array N.
       Starting from the second call, the first part will store the new N values,
       while the second part will the cross evaluated N, and finally the third
       part will contain the old N values.

       Example with default values: Ls = 3 [s], ECG_SIGNAL_LENGTH = 4 [s]
        First call:
              N0
           <----->
           0-+-+-+-4-+-+-+-8->
             <----->
                N1

                   new   cross  old
            N = [ N0 N1 | \ \ | \ \ ]

        Second  Call:
              N0                           N2                          N4
           <----->                      <----->                     <----->
           0-+-+-+-4-+-+-+-8->      0-+-+-+-4-+-+-+-8->     0-+-+-+-4-+-+-+-8->
             <----->                      <----->                     <----->
                N1                           N3                          N5

                   new    cross    old
            N = [ N4 N5 | N2 N3 | N0 N1 ]

       N0 and N1 - are evaluated respectively using the first and the last 3s
                   of the four second window in the first call.
       N2 and N3 - needs both data from the first and the second 4-second window,
                   therefore we need to save the last 2 seconds (Ls-1) of the
                   current ECG window for the next call.
       N4 and N5 - are evaluated with the 4s window of the second call.

       Every call after the first work the same way.
       In this way we use the algorithm with 2 different subsequent acquisitions
       and thus considerably increase the number of Ls window we can evaluate.
    */

    /* Reset N array if this is the first segment */
    if( EventCounter == 0 ){
        for( i = 0 ; i < TCSC_NTS ; i++ )
            N[i] = 0;
    }

    /* Find the absolute maximum for each segment */

    /* New ECG -> first part of N */
    for( i = 0 ; i < TCSC_NS ; i++ ){
        Max[i] = 0;
        int16 j;
        for( j = i * ECG_SAMPLING_F ; j < (i+TCSC_Ls) * ECG_SAMPLING_F ; j++ ){
            if( abs( DataECG[j] ) > Max[i] )
                Max[i] = abs( DataECG[j] );
        }
    }

    /* Combined old and new ECG -> second part of N */
    if( EventCounter != 0 ){
        for( i = TCSC_NS ; i < ECG_SIGNAL_LENGTH ; i++ ){
            Max[i] = 0;
            int16 j;
            /* Old ECG */
            for( j = i * ECG_SAMPLING_F ; j < ECG_DATA_SIZE ; j++ ){
                if( abs( OldECG[j] ) > Max[i] )
                    Max[i] = abs( OldECG[j] );
            }
            /* New ECG */
            for( j = 0 ; j < (i+1 - TCSC_NS) * ECG_SAMPLING_F ; j++ ){
                if( abs( DataECG[j] ) > Max[i] )
                    Max[i] = abs( DataECG[j] );
            }
        }
    }

    /* Evaluate the N for each segment */

    /* New ECG -> first part of N */
    for( i = 0 ; i < TCSC_NS ; i++ ){
        int16 j;
        for( j = i * ECG_SAMPLING_F ; j < (i+TCSC_Ls) * ECG_SAMPLING_F ; j++ ){
            /* TCSC use absolute values */
            float temp = fabs( (float)(DataECG[j]) );

            /* Apply the cosine window if we are in the first or last 0.25 sec*/
            if( (float)(j) / ECG_SAMPLING_F - i < 0.25)
                temp *= OAED_TCSC_COSWIN( (float)(j) / ECG_SAMPLING_F - i);
            if( (float)(j+1) / ECG_SAMPLING_F - i > (float)(TCSC_Ls) - 0.25 )
                temp *= OAED_TCSC_COSWIN( (float)(j+1) / ECG_SAMPLING_F - i);

            /* Check with the threshold */
            if( temp > (float)(TCSC_THRESH * Max[i]) )
                N[i]++;
        }

        /* Ns are weighted on the Ls window */
        N[i] /= (float)(TCSC_Ls * ECG_SAMPLING_F);
        /* Add the N to the mean */
        Nmean += N[i];
    }

    /* Combined old and new ECG -> second part of N */
    if( EventCounter != 0 ){
        for( i = TCSC_NS ; i < ECG_SIGNAL_LENGTH ; i++ ){
            int16 j;

            /* Old ECG */
            for( j = i * ECG_SAMPLING_F ; j < ECG_DATA_SIZE ; j++ ){
                float temp = fabs( (float)(OldECG[j]) );

                /* Apply the cosine window */
                /* In this case only the left side is possible */
                if( (float)(j) / ECG_SAMPLING_F - i < 0.25)
                    temp *= OAED_TCSC_COSWIN( (float)(j) / ECG_SAMPLING_F - i);

                /* Check with the threshold */
                if( temp > (float)(TCSC_THRESH * Max[i]) )
                    N[i]++;
            }

            /* New ECG */
            for( j = 0 ; j < (i+1 - TCSC_NS) * ECG_SAMPLING_F ; j++ ){
                float temp = fabs( (float)(DataECG[j]) );

                /* Apply the cosine window */
                /* In this case only the right side is possible */
                if( (float)(j+1) / ECG_SAMPLING_F >
                                                (float)(i+1 - TCSC_NS) - 0.25 ){
                    temp *= OAED_TCSC_COSWIN(
                        (float)(j+1) / ECG_SAMPLING_F + (i+1 - TCSC_NS) );
                }

                /* Check with the threshold */
                if( temp > (float)(TCSC_THRESH * Max[i]) )
                    N[i]++;
            }

            /* Ns are weighted on the Ls window */
            N[i] /= (float)(TCSC_Ls * ECG_SAMPLING_F);
            /* Add the N to the mean */
            Nmean += N[i];
        }
    }

    if(EventCounter != 0){
        /* Add the older values to the mean */
        for( i = ECG_SIGNAL_LENGTH ; i < TCSC_NTS ; i++ )
            Nmean += N[i];
        Nmean /= (float)(TCSC_NTS);
    }
    else{
        Nmean /= (float)(TCSC_NS);
    }

    /* Overwrite the older N values */
    for( i = 0; i < TCSC_NS ; i++ ){
        N[i + ECG_SIGNAL_LENGTH] = N[i];
    }

    /* Evaluate the rhythm */
    if( Nmean >= TCSC_CRIT )
        return true;                // VF confirmed
    return false;                   // Normal sinus rhythm
}

bool OAED_PSR(){
    bool    Grid[PSR_GRID_N][PSR_GRID_N];               // Grid
    float   d,                                          // d value
            Delta;                                      // Cell size
    uint8   Gx, Gy;                                     // Grid indexes
    int16   ECGmax = -1, ECGmin = 1;                    // Maximum and minimum
    int16   i,j;                                        // For counter

    /* Init grid */
    for( i = 0 ; i < PSR_GRID_N ; i++ )
        for( j = 0 ; j < PSR_GRID_N ; j++ )
            Grid[i][j] = false;

    /* Find the maximum and the minimum */
    for( i = 0 ; i < ECG_DATA_SIZE ; i++ ){
        if(ECGmax < DataECG[i])
            ECGmax = DataECG[i];
        else
            if(ECGmin > DataECG[i])
                ECGmin = DataECG[i];
    }

    /* Calculate cell size */
    Delta = (float)(ECGmax - ECGmin)/PSR_GRID_N;
    Delta = ceil(Delta);

    /* Light the grid */
    for( i = 0 ; i < ECG_DATA_SIZE - PSR_TAU_N ; i = i+2 ){
        Gx = (uint8) floor( (float)(DataECG[i] - ECGmin) / Delta );
        Gy = (uint8) floor( (float)
                           (DataECG[(int16)(i + PSR_TAU_N)] - ECGmin) / Delta );
        Grid[Gx][Gy] = true;
    }

    /* Calculate d */
    d = 0;
    for( i = 0 ; i < PSR_GRID_N ; i++ )
        for( j = 0 ; j < PSR_GRID_N ; j++ )
            if(Grid[i][j])
                d++;
    d /= (PSR_GRID_N * PSR_GRID_N);

    /* Evaluate rhythm */
    if( d > PSR_D0 )
        return true;        // VF confirmed
    return false;           // VF not confirmed
}

bool OAED_HILB(){
    bool    Grid[HILB_GRID_N][HILB_GRID_N];             // Grid
    float   d,                                          // d value
            DeltaIm,                                    // Cell size
            DeltaRe;                                    // Cell size
    uint8   Gx, Gy;                                     // Grid indexes
    uint16  i,j;                                        // For counter

    int32                       MaxRe = -1;             // Real maximum
    int32                       MaxIm = -1;             // Imag maximum
    int32                       MinRe = 1;              // Real minimum
    int32                       MinIm = 1;              // Imag minimum
    q31_t                       EcgQ31[(uint16)FFTN*2]; // q31 analytic signal

    /* Init grid */
    for( i = 0 ; i < HILB_GRID_N ; i++ )
        for( j = 0 ; j < HILB_GRID_N ; j++ )
            Grid[i][j] = false;

    /* Calculate analytic signal from ECG */
    /* Find the maximum to upscale ECG values */
    for( i = 0; i < ECG_DATA_SIZE ; i++ )
        if( MaxRe < DataECG[i])
            MaxRe = DataECG[i];

    /* The FFT in CMSIS-DSP downscale data in order to avoid saturation. Because
       of the fixed point arithmetics this also mean a loss of information (up to
       12 bit). I wanted to limit data loss, hence i used 32 bit numbers
       upscaling them to cover all the available values.
    */

    /* This cycle convert int16 ECG into q31 ECG upscaling to 31bit (keep the
       sign). Also add zero padding. Remember that this is a complex signal,
       hence real values are stored in even elements whilst imaginary values (all
       zeros for now) are stored in odd elements.
    */
    for( i = 0 ; i < FFTN ; i++ )
        EcgQ31[2*i] =
                (i < ECG_DATA_SIZE) ? (q31_t)(DataECG[i] * pow(2,31)/MaxRe ) : 0;
    for( i = 0 ; i < FFTN ; i++ )
        EcgQ31[2*i+1] = 0;

    /* Perfor 32bit FFT on ECG data */
    arm_cfft_q31(&arm_cfft_sR_q31_len2048, EcgQ31, FORWARD_FFT, 1);

    /* The analytic signal is then obtained modifying the FFT data (X) with the
       following transform (Z) :
                /   X[0]            m = 0
                |   2X[m]           1 <= m <= N/2 - 1
      Z[m] =   <    X[N/2]          m = N/2
                |   0               N/2 + 1 <= m <= N - 1
                \
       Always remember that arm_xfft functions returns complex arrays where even
       elements contain the real part, and odd ones contain the imaginary part.
    */
    for( i = 2 ; i < FFTN ; i++ )
        EcgQ31[i] *= 2;
    for( i = FFTN + 2 ; i < 2*FFTN ; i++ )
        EcgQ31[i] = 0;

    /* Return in time domain performing the inverse transform */
    arm_cfft_q31(&arm_cfft_sR_q31_len2048, EcgQ31, INVERSE_FFT, 1);
    /* ECGQ31 now contains the analytic signal */

    /* Find real and complex maximum and minimum */
    MaxRe = -1; // Re-init MaxRe
    for( i = 0; i < 2*FFTN - 1 ; i ++ ){
        // Real
        if(MaxRe < EcgQ31[i])
            MaxRe = EcgQ31[i];
        else
            if(MinRe > EcgQ31[i])
                MinRe = EcgQ31[i];
        // Imag
        i++;
        if(MaxIm < EcgQ31[i])
            MaxIm = EcgQ31[i];
        else
            if(MinIm > EcgQ31[i])
                MinIm = EcgQ31[i];
    }

    /* Calculate cell size */
    DeltaRe = (float)(MaxRe - MinRe)/HILB_GRID_N;
    DeltaIm = (float)(MaxIm - MinIm)/HILB_GRID_N;
    DeltaRe = ceil(DeltaRe);
    DeltaIm = ceil(DeltaIm);

    /* Light the grid */
    for( i = 0 ; i < 2*FFTN - 1 ; i = i+3 ){
        Gx = (uint8) floor( (float)(EcgQ31[i] - MinRe) / DeltaRe );
        Gy = (uint8) floor( (float)(EcgQ31[++i] - MinIm) / DeltaIm );
        Grid[Gx][Gy] = true;
    }

    /* Calculate d */
    d = 0;
    for( i = 0 ; i < HILB_GRID_N ; i++ )
        for( j = 0 ; j < HILB_GRID_N ; j++ )
            if(Grid[i][j])
                d++;

    d /= (HILB_GRID_N * HILB_GRID_N);

    /* Evaluate rhythm */
    if( d > HILB_D0 )
        return true;        // VF confirmed
    return false;           // VF not confirmed

}

bool OAED_ECGAnalysis(){
    /* This function call various algorithms and assert SCA based on how many
       return positive.
    */
    uint8 i = 0;

    if( OAED_TCI() )
        i++;
    if( OAED_VFfilter() )
        i++;
    if( OAED_TCSC() )
        i++;
    if( OAED_PSR() )
        i++;
    if( OAED_HILB() )
        i++;

    /* Check SCA, by default it is 3 positive  on 5 */
    if( i >= OAED_POSITIVETHRESH )
        return true;
    return false;
}

/* [] END OF FILE */
