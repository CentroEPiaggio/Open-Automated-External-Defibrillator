EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:references
LIBS:relays
LIBS:OAED-library
LIBS:High-Voltage-board-cache
EELAYER 25 0
EELAYER END
$Descr A4 8268 11693 portrait
encoding utf-8
Sheet 3 4
Title "Discharging Circuit"
Date "2016-09-16"
Rev "0.2"
Comp ""
Comment1 "This circuit discharges the capacitor with a biphasic waveform"
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 3800 850  0    98   Input ~ 0
COUT
$Comp
L Q_NIGBT_GCE Q2
U 1 1 57D1B6F3
P 3050 2650
F 0 "Q2" H 3350 2700 50  0000 R CNN
F 1 "IRG7PH35UD" H 3825 2950 98  0000 R CNN
F 2 "" H 3250 2750 50  0000 C CNN
F 3 "" H 3050 2650 50  0000 C CNN
	1    3050 2650
	1    0    0    -1  
$EndComp
$Comp
L TLP250 U3
U 1 1 57D27385
P 2000 2650
F 0 "U3" H 1750 3150 50  0000 C CNN
F 1 "TLP250" H 2000 2150 98  0000 C CNN
F 2 "DIP-8" H 1850 2250 50  0000 L CIN
F 3 "" H 1845 2650 50  0000 L CNN
	1    2000 2650
	1    0    0    -1  
$EndComp
Text HLabel 1100 2550 0    98   Input ~ 0
Φ1
Text HLabel 1100 2750 0    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U2
U 1 1 57D27DC9
P 2000 1800
F 0 "U2" H 2000 1550 60  0000 C CNN
F 1 "R1SE/H2_0515" H 2000 2050 60  0000 C CNN
F 2 "" H 2000 1800 60  0000 C CNN
F 3 "" H 2000 1800 60  0000 C CNN
	1    2000 1800
	1    0    0    -1  
$EndComp
Text HLabel 1100 1900 0    98   UnSpc ~ 0
GND
Text HLabel 1100 1700 0    98   Input ~ 0
+5V
$Comp
L C C1
U 1 1 57D27E9F
P 2750 2450
F 0 "C1" H 2775 2550 50  0000 L CNN
F 1 "C" H 2775 2350 50  0000 L CNN
F 2 "" H 2788 2300 50  0000 C CNN
F 3 "" H 2750 2450 50  0000 C CNN
	1    2750 2450
	1    0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q3
U 1 1 57D2823D
P 3050 4450
F 0 "Q3" H 3350 4500 50  0000 R CNN
F 1 "IRG7PH35UD" H 3825 4775 98  0000 R CNN
F 2 "" H 3250 4550 50  0000 C CNN
F 3 "" H 3050 4450 50  0000 C CNN
	1    3050 4450
	1    0    0    -1  
$EndComp
$Comp
L TLP250 U5
U 1 1 57D28244
P 2000 4450
F 0 "U5" H 1750 4950 50  0000 C CNN
F 1 "TLP250" H 2000 3900 98  0000 C CNN
F 2 "DIP-8" H 1850 4050 50  0000 L CIN
F 3 "" H 1845 4450 50  0000 L CNN
	1    2000 4450
	1    0    0    -1  
$EndComp
Text HLabel 1100 4350 0    98   Input ~ 0
Φ1
Text HLabel 1100 4550 0    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U4
U 1 1 57D2824D
P 2000 3600
F 0 "U4" H 2000 3350 60  0000 C CNN
F 1 "R1SE/H2_0515" H 2000 3850 60  0000 C CNN
F 2 "" H 2000 3600 60  0000 C CNN
F 3 "" H 2000 3600 60  0000 C CNN
	1    2000 3600
	1    0    0    -1  
$EndComp
Text HLabel 1100 3700 0    98   UnSpc ~ 0
GND
Text HLabel 1100 3500 0    98   Input ~ 0
+5V
$Comp
L C C2
U 1 1 57D28256
P 2750 4250
F 0 "C2" H 2775 4350 50  0000 L CNN
F 1 "C" H 2775 4150 50  0000 L CNN
F 2 "" H 2788 4100 50  0000 C CNN
F 3 "" H 2750 4250 50  0000 C CNN
	1    2750 4250
	1    0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q6
U 1 1 57D28766
P 5250 2650
F 0 "Q6" H 5550 2700 50  0000 R CNN
F 1 "IRG7PH35UD" H 6075 2950 98  0000 R CNN
F 2 "" H 5450 2750 50  0000 C CNN
F 3 "" H 5250 2650 50  0000 C CNN
	1    5250 2650
	-1   0    0    -1  
$EndComp
$Comp
L TLP250 U10
U 1 1 57D2876D
P 6300 2650
F 0 "U10" H 6050 3150 50  0000 C CNN
F 1 "TLP250" H 6325 2150 98  0000 C CNN
F 2 "DIP-8" H 6150 2250 50  0000 L CIN
F 3 "" H 6145 2650 50  0000 L CNN
	1    6300 2650
	-1   0    0    -1  
$EndComp
Text HLabel 7200 2550 2    98   Input ~ 0
Φ2
Text HLabel 7200 2750 2    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U9
U 1 1 57D28776
P 6300 1800
F 0 "U9" H 6300 1550 60  0000 C CNN
F 1 "R1SE/H2_0515" H 6300 2050 60  0000 C CNN
F 2 "" H 6300 1800 60  0000 C CNN
F 3 "" H 6300 1800 60  0000 C CNN
	1    6300 1800
	-1   0    0    -1  
$EndComp
Text HLabel 7200 1900 2    98   UnSpc ~ 0
GND
Text HLabel 7200 1700 2    98   Input ~ 0
+5V
$Comp
L C C5
U 1 1 57D2877F
P 5550 2450
F 0 "C5" H 5575 2550 50  0000 L CNN
F 1 "C" H 5575 2350 50  0000 L CNN
F 2 "" H 5588 2300 50  0000 C CNN
F 3 "" H 5550 2450 50  0000 C CNN
	1    5550 2450
	-1   0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q7
U 1 1 57D28799
P 5250 4450
F 0 "Q7" H 5550 4500 50  0000 R CNN
F 1 "IRG7PH35UD" H 6075 4775 98  0000 R CNN
F 2 "" H 5450 4550 50  0000 C CNN
F 3 "" H 5250 4450 50  0000 C CNN
	1    5250 4450
	-1   0    0    -1  
$EndComp
$Comp
L TLP250 U12
U 1 1 57D287A0
P 6300 4450
F 0 "U12" H 6050 4950 50  0000 C CNN
F 1 "TLP250" H 6300 3925 98  0000 C CNN
F 2 "DIP-8" H 6150 4050 50  0000 L CIN
F 3 "" H 6145 4450 50  0000 L CNN
	1    6300 4450
	-1   0    0    -1  
$EndComp
Text HLabel 7200 4350 2    98   Input ~ 0
Φ2
Text HLabel 7200 4550 2    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U11
U 1 1 57D287A9
P 6300 3600
F 0 "U11" H 6300 3350 60  0000 C CNN
F 1 "R1SE/H2_0515" H 6300 3850 60  0000 C CNN
F 2 "" H 6300 3600 60  0000 C CNN
F 3 "" H 6300 3600 60  0000 C CNN
	1    6300 3600
	-1   0    0    -1  
$EndComp
Text HLabel 7200 3700 2    98   UnSpc ~ 0
GND
Text HLabel 7200 3500 2    98   Input ~ 0
+5V
$Comp
L C C6
U 1 1 57D287B2
P 5550 4250
F 0 "C6" H 5575 4350 50  0000 L CNN
F 1 "C" H 5575 4150 50  0000 L CNN
F 2 "" H 5588 4100 50  0000 C CNN
F 3 "" H 5550 4250 50  0000 C CNN
	1    5550 4250
	-1   0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q4
U 1 1 57D2A858
P 3050 7000
F 0 "Q4" H 3350 7050 50  0000 R CNN
F 1 "IRG7PH35UD" H 3825 7300 98  0000 R CNN
F 2 "" H 3250 7100 50  0000 C CNN
F 3 "" H 3050 7000 50  0000 C CNN
	1    3050 7000
	1    0    0    -1  
$EndComp
$Comp
L TLP250 U7
U 1 1 57D2A85E
P 2000 7000
F 0 "U7" H 1750 7500 50  0000 C CNN
F 1 "TLP250" H 2025 6475 98  0000 C CNN
F 2 "DIP-8" H 1850 6600 50  0000 L CIN
F 3 "" H 1845 7000 50  0000 L CNN
	1    2000 7000
	1    0    0    -1  
$EndComp
Text HLabel 1100 6900 0    98   Input ~ 0
Φ2
Text HLabel 1100 7100 0    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U6
U 1 1 57D2A866
P 2000 6150
F 0 "U6" H 2000 5900 60  0000 C CNN
F 1 "R1SE/H2_0515" H 2000 6400 60  0000 C CNN
F 2 "" H 2000 6150 60  0000 C CNN
F 3 "" H 2000 6150 60  0000 C CNN
	1    2000 6150
	1    0    0    -1  
$EndComp
Text HLabel 1100 6250 0    98   UnSpc ~ 0
GND
Text HLabel 1100 6050 0    98   Input ~ 0
+5V
$Comp
L C C3
U 1 1 57D2A86E
P 2750 6800
F 0 "C3" H 2775 6900 50  0000 L CNN
F 1 "C" H 2775 6700 50  0000 L CNN
F 2 "" H 2788 6650 50  0000 C CNN
F 3 "" H 2750 6800 50  0000 C CNN
	1    2750 6800
	1    0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q5
U 1 1 57D2A887
P 3050 8800
F 0 "Q5" H 3350 8850 50  0000 R CNN
F 1 "IRG7PH35UD" H 3825 9150 98  0000 R CNN
F 2 "" H 3250 8900 50  0000 C CNN
F 3 "" H 3050 8800 50  0000 C CNN
	1    3050 8800
	1    0    0    -1  
$EndComp
$Comp
L TLP250 U8
U 1 1 57D2A88D
P 2000 8800
F 0 "U8" H 1750 9300 50  0000 C CNN
F 1 "TLP250" H 2000 8300 98  0000 C CNN
F 2 "DIP-8" H 1850 8400 50  0000 L CIN
F 3 "" H 1845 8800 50  0000 L CNN
	1    2000 8800
	1    0    0    -1  
$EndComp
Text HLabel 1100 8700 0    98   Input ~ 0
Φ2
Text HLabel 1100 8900 0    98   UnSpc ~ 0
GND
Text HLabel 1100 7850 0    98   Input ~ 0
+15V
$Comp
L C C4
U 1 1 57D2A89D
P 2750 8500
F 0 "C4" H 2775 8600 50  0000 L CNN
F 1 "C" H 2775 8400 50  0000 L CNN
F 2 "" H 2788 8350 50  0000 C CNN
F 3 "" H 2750 8500 50  0000 C CNN
	1    2750 8500
	1    0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q8
U 1 1 57D2A8B6
P 5250 7000
F 0 "Q8" H 5550 7050 50  0000 R CNN
F 1 "IRG7PH35UD" H 6075 7300 98  0000 R CNN
F 2 "" H 5450 7100 50  0000 C CNN
F 3 "" H 5250 7000 50  0000 C CNN
	1    5250 7000
	-1   0    0    -1  
$EndComp
$Comp
L TLP250 U14
U 1 1 57D2A8BC
P 6300 7000
F 0 "U14" H 6050 7500 50  0000 C CNN
F 1 "TLP250" H 6275 6475 98  0000 C CNN
F 2 "DIP-8" H 6150 6600 50  0000 L CIN
F 3 "" H 6145 7000 50  0000 L CNN
	1    6300 7000
	-1   0    0    -1  
$EndComp
Text HLabel 7200 6900 2    98   Input ~ 0
Φ1
Text HLabel 7200 7100 2    98   UnSpc ~ 0
GND
$Comp
L R1SE/H2_0515 U13
U 1 1 57D2A8C4
P 6300 6150
F 0 "U13" H 6300 5900 60  0000 C CNN
F 1 "R1SE/H2_0515" H 6300 6400 60  0000 C CNN
F 2 "" H 6300 6150 60  0000 C CNN
F 3 "" H 6300 6150 60  0000 C CNN
	1    6300 6150
	-1   0    0    -1  
$EndComp
Text HLabel 7200 6250 2    98   UnSpc ~ 0
GND
Text HLabel 7200 6050 2    98   Input ~ 0
+5V
$Comp
L C C7
U 1 1 57D2A8CC
P 5550 6800
F 0 "C7" H 5575 6900 50  0000 L CNN
F 1 "C" H 5575 6700 50  0000 L CNN
F 2 "" H 5588 6650 50  0000 C CNN
F 3 "" H 5550 6800 50  0000 C CNN
	1    5550 6800
	-1   0    0    -1  
$EndComp
$Comp
L Q_NIGBT_GCE Q9
U 1 1 57D2A8E5
P 5250 8800
F 0 "Q9" H 5550 8850 50  0000 R CNN
F 1 "IRG7PH35UD" H 6075 9150 98  0000 R CNN
F 2 "" H 5450 8900 50  0000 C CNN
F 3 "" H 5250 8800 50  0000 C CNN
	1    5250 8800
	-1   0    0    -1  
$EndComp
$Comp
L TLP250 U15
U 1 1 57D2A8EB
P 6300 8800
F 0 "U15" H 6050 9300 50  0000 C CNN
F 1 "TLP250" H 6300 8275 98  0000 C CNN
F 2 "DIP-8" H 6150 8400 50  0000 L CIN
F 3 "" H 6145 8800 50  0000 L CNN
	1    6300 8800
	-1   0    0    -1  
$EndComp
Text HLabel 7200 8700 2    98   Input ~ 0
Φ1
Text HLabel 7200 8900 2    98   UnSpc ~ 0
GND
$Comp
L C C8
U 1 1 57D2A8FB
P 5550 8500
F 0 "C8" H 5575 8600 50  0000 L CNN
F 1 "C" H 5575 8400 50  0000 L CNN
F 2 "" H 5588 8350 50  0000 C CNN
F 3 "" H 5550 8500 50  0000 C CNN
	1    5550 8500
	-1   0    0    -1  
$EndComp
Text HLabel 3800 9450 0    98   UnSpc ~ 0
GND
Text HLabel 7200 7850 2    98   Input ~ 0
+15V
Text HLabel 3825 5700 2    98   Output ~ 0
+VOUT
Text HLabel 4525 5900 0    98   Output ~ 0
-VOUT
Wire Wire Line
	2400 2550 2450 2550
Wire Wire Line
	2450 2550 2450 2650
Wire Wire Line
	2450 2650 2450 2750
Wire Wire Line
	2450 2750 2400 2750
Wire Wire Line
	2450 2650 2850 2650
Connection ~ 2450 2650
Wire Wire Line
	1100 2550 1600 2550
Wire Wire Line
	1100 2750 1600 2750
Wire Wire Line
	2400 2950 2550 2950
Wire Wire Line
	2550 2950 2750 2950
Wire Wire Line
	2750 2950 3150 2950
Connection ~ 3150 2950
Wire Wire Line
	1100 1700 1450 1700
Wire Wire Line
	1450 1900 1100 1900
Connection ~ 2750 2950
Wire Wire Line
	2550 1700 2750 1700
Wire Wire Line
	3150 2850 3150 2950
Wire Wire Line
	3150 2950 3150 4250
Wire Wire Line
	2400 4350 2450 4350
Wire Wire Line
	2450 4350 2450 4450
Wire Wire Line
	2450 4450 2450 4550
Wire Wire Line
	2450 4550 2400 4550
Wire Wire Line
	2450 4450 2850 4450
Connection ~ 2450 4450
Wire Wire Line
	1100 4350 1600 4350
Wire Wire Line
	1100 4550 1600 4550
Wire Wire Line
	2400 4750 2550 4750
Wire Wire Line
	2550 4750 2750 4750
Wire Wire Line
	2750 4750 3150 4750
Connection ~ 3150 4750
Wire Wire Line
	1100 3500 1450 3500
Wire Wire Line
	1450 3700 1100 3700
Connection ~ 2750 4750
Wire Wire Line
	2550 3500 2750 3500
Wire Wire Line
	3150 4650 3150 4750
Wire Wire Line
	3150 4750 3150 5800
Wire Wire Line
	3150 5800 3150 6800
Wire Wire Line
	5900 2550 5850 2550
Wire Wire Line
	5850 2550 5850 2650
Wire Wire Line
	5850 2650 5850 2750
Wire Wire Line
	5850 2750 5900 2750
Wire Wire Line
	5850 2650 5450 2650
Connection ~ 5850 2650
Wire Wire Line
	7200 2550 6700 2550
Wire Wire Line
	7200 2750 6700 2750
Wire Wire Line
	5150 2950 5550 2950
Wire Wire Line
	5550 2950 5750 2950
Wire Wire Line
	5750 2950 5900 2950
Connection ~ 5150 2950
Wire Wire Line
	7200 1700 6850 1700
Wire Wire Line
	6850 1900 7200 1900
Connection ~ 5550 2950
Wire Wire Line
	5750 1700 5550 1700
Wire Wire Line
	5150 2850 5150 2950
Wire Wire Line
	5150 2950 5150 4250
Wire Wire Line
	5900 4350 5850 4350
Wire Wire Line
	5850 4350 5850 4450
Wire Wire Line
	5850 4450 5850 4550
Wire Wire Line
	5850 4550 5900 4550
Wire Wire Line
	5850 4450 5450 4450
Connection ~ 5850 4450
Wire Wire Line
	7200 4350 6700 4350
Wire Wire Line
	7200 4550 6700 4550
Wire Wire Line
	5150 4750 5550 4750
Wire Wire Line
	5550 4750 5750 4750
Wire Wire Line
	5750 4750 5900 4750
Connection ~ 5150 4750
Wire Wire Line
	7200 3500 6850 3500
Wire Wire Line
	6850 3700 7200 3700
Connection ~ 5550 4750
Wire Wire Line
	5150 4650 5150 4750
Wire Wire Line
	5150 4750 5150 5800
Wire Wire Line
	5150 5800 5150 6800
Wire Wire Line
	2400 6900 2450 6900
Wire Wire Line
	2450 6900 2450 7000
Wire Wire Line
	2450 7000 2450 7100
Wire Wire Line
	2450 7100 2400 7100
Wire Wire Line
	2450 7000 2850 7000
Connection ~ 2450 7000
Wire Wire Line
	1100 6900 1600 6900
Wire Wire Line
	1100 7100 1600 7100
Wire Wire Line
	2400 7300 2550 7300
Wire Wire Line
	2550 7300 2750 7300
Wire Wire Line
	2750 7300 3150 7300
Connection ~ 3150 7300
Wire Wire Line
	1100 6050 1450 6050
Wire Wire Line
	1450 6250 1100 6250
Wire Wire Line
	2750 6950 2750 7300
Wire Wire Line
	2550 6250 2550 7300
Connection ~ 2750 7300
Wire Wire Line
	2550 6050 2750 6050
Wire Wire Line
	2750 6050 2750 6500
Wire Wire Line
	2750 6500 2750 6650
Wire Wire Line
	3150 7200 3150 7300
Wire Wire Line
	3150 7300 3150 8600
Wire Wire Line
	2400 8700 2450 8700
Wire Wire Line
	2450 8700 2450 8800
Wire Wire Line
	2450 8800 2450 8900
Wire Wire Line
	2450 8900 2400 8900
Wire Wire Line
	2450 8800 2850 8800
Connection ~ 2450 8800
Wire Wire Line
	1100 8700 1600 8700
Wire Wire Line
	1100 8900 1600 8900
Wire Wire Line
	2400 9100 2750 9100
Wire Wire Line
	2750 9100 3150 9100
Wire Wire Line
	3150 9100 4150 9100
Wire Wire Line
	4150 9100 5150 9100
Wire Wire Line
	5150 9100 5550 9100
Wire Wire Line
	5550 9100 5900 9100
Connection ~ 3150 9100
Wire Wire Line
	1100 7850 2450 7850
Wire Wire Line
	2450 7850 2750 7850
Connection ~ 2750 9100
Wire Wire Line
	2750 7850 2750 8350
Wire Wire Line
	3150 9100 3150 9000
Wire Wire Line
	5900 6900 5850 6900
Wire Wire Line
	5850 6900 5850 7000
Wire Wire Line
	5850 7000 5850 7100
Wire Wire Line
	5850 7100 5900 7100
Wire Wire Line
	5850 7000 5450 7000
Connection ~ 5850 7000
Wire Wire Line
	7200 6900 6700 6900
Wire Wire Line
	7200 7100 6700 7100
Wire Wire Line
	5150 7300 5550 7300
Wire Wire Line
	5550 7300 5750 7300
Wire Wire Line
	5750 7300 5900 7300
Connection ~ 5150 7300
Wire Wire Line
	7200 6050 6850 6050
Wire Wire Line
	6850 6250 7200 6250
Wire Wire Line
	5550 6950 5550 7300
Wire Wire Line
	5750 6250 5750 7300
Connection ~ 5550 7300
Wire Wire Line
	5750 6050 5550 6050
Wire Wire Line
	5550 6050 5550 6500
Wire Wire Line
	5550 6500 5550 6650
Wire Wire Line
	5150 7200 5150 7300
Wire Wire Line
	5150 7300 5150 8600
Wire Wire Line
	5900 8700 5850 8700
Wire Wire Line
	5850 8700 5850 8800
Wire Wire Line
	5850 8800 5850 8900
Wire Wire Line
	5850 8900 5900 8900
Wire Wire Line
	5850 8800 5450 8800
Connection ~ 5850 8800
Wire Wire Line
	7200 8700 6700 8700
Wire Wire Line
	7200 8900 6700 8900
Connection ~ 5150 9100
Connection ~ 5550 9100
Wire Wire Line
	5150 9100 5150 9000
Wire Wire Line
	3150 2450 3150 1300
Wire Wire Line
	3150 1300 4150 1300
Wire Wire Line
	4150 1300 5150 1300
Wire Wire Line
	5150 1300 5150 2450
Wire Wire Line
	4150 9100 4150 9450
Connection ~ 4150 9100
Wire Wire Line
	4150 850  4150 1300
Connection ~ 4150 1300
Connection ~ 5750 7300
Wire Wire Line
	5550 6500 5850 6500
Wire Wire Line
	5850 6500 5850 6700
Connection ~ 5550 6500
Wire Wire Line
	5850 6700 5900 6700
Wire Wire Line
	2750 8650 2750 9100
Wire Wire Line
	2400 8500 2450 8500
Wire Wire Line
	2450 8500 2450 7850
Connection ~ 2450 7850
Wire Wire Line
	3800 850  4150 850 
Wire Wire Line
	5900 8500 5850 8500
Wire Wire Line
	5850 8500 5850 7850
Wire Wire Line
	5550 7850 5850 7850
Wire Wire Line
	5850 7850 7200 7850
Connection ~ 5850 7850
Wire Wire Line
	5550 8350 5550 7850
Wire Wire Line
	5550 9100 5550 8650
Wire Wire Line
	4150 9450 3800 9450
Connection ~ 2550 7300
Wire Wire Line
	2400 6700 2450 6700
Wire Wire Line
	2450 6700 2450 6500
Wire Wire Line
	2450 6500 2750 6500
Connection ~ 2750 6500
Wire Wire Line
	2750 3500 2750 3950
Wire Wire Line
	2750 3950 2750 4100
Wire Wire Line
	2750 1700 2750 2150
Wire Wire Line
	2750 2150 2750 2300
Wire Wire Line
	2750 2600 2750 2950
Wire Wire Line
	2750 4400 2750 4750
Wire Wire Line
	5550 4750 5550 4400
Wire Wire Line
	5550 3500 5550 3900
Wire Wire Line
	5550 3900 5550 4100
Wire Wire Line
	5550 3500 5750 3500
Wire Wire Line
	5550 2950 5550 2600
Wire Wire Line
	5550 1700 5550 2150
Wire Wire Line
	5550 2150 5550 2300
Wire Wire Line
	5750 3700 5750 4750
Connection ~ 5750 4750
Wire Wire Line
	5750 1900 5750 2950
Connection ~ 5750 2950
Wire Wire Line
	2550 1900 2550 2950
Connection ~ 2550 2950
Wire Wire Line
	2550 3700 2550 4750
Connection ~ 2550 4750
Wire Wire Line
	2400 4150 2450 4150
Wire Wire Line
	2450 4150 2450 3950
Wire Wire Line
	2450 3950 2750 3950
Connection ~ 2750 3950
Wire Wire Line
	5550 3900 5850 3900
Wire Wire Line
	5850 3900 5850 4150
Wire Wire Line
	5850 4150 5900 4150
Connection ~ 5550 3900
Wire Wire Line
	2750 2150 2450 2150
Wire Wire Line
	2450 2150 2450 2350
Wire Wire Line
	2450 2350 2400 2350
Connection ~ 2750 2150
Wire Wire Line
	5900 2350 5850 2350
Wire Wire Line
	5850 2350 5850 2150
Wire Wire Line
	5850 2150 5550 2150
Connection ~ 5550 2150
Wire Wire Line
	3150 5800 3650 5800
Connection ~ 3150 5800
Wire Wire Line
	5150 5800 4650 5800
Connection ~ 5150 5800
Wire Wire Line
	3650 5800 3650 5700
Wire Wire Line
	3650 5700 3825 5700
Wire Wire Line
	4525 5900 4650 5900
Wire Wire Line
	4650 5900 4650 5800
$EndSCHEMATC
