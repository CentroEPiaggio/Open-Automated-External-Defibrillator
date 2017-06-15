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
$Descr A4 11693 8268
encoding utf-8
Sheet 1 4
Title "High Voltage Board"
Date "2017-05-30"
Rev "0.2"
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 2250 1450 1400 2100
U 57D16A8C
F0 "Charging-Circuit" 60
F1 "Charging-Circuit.sch" 60
F2 "GND" O L 2250 3200 60 
F3 "HV-OUT+" O R 3650 1800 60 
F4 "HV-OUT-" O R 3650 2400 60 
F5 "VIN" I L 2250 2400 60 
F6 "Vsense" O R 3650 2900 60 
$EndSheet
$Sheet
S 4850 1450 1400 2100
U 57D1AE49
F0 "Discharging Circuit" 60
F1 "Discharging-Circuit.sch" 60
F2 "COUT" I L 4850 1800 60 
F3 "Φ1" I L 4850 2900 60 
F4 "GND" U L 4850 2400 60 
F5 "+5V" I R 6250 2900 60 
F6 "Φ2" I L 4850 3350 60 
F7 "+15V" I R 6250 3350 60 
F8 "+VOUT" O R 6250 1800 60 
F9 "-VOUT" O R 6250 2400 60 
$EndSheet
$Comp
L CP1 Cout1
U 1 1 57D1AE78
P 4250 2100
F 0 "Cout1" H 4275 2200 50  0000 L CNN
F 1 "CP1" H 4275 2000 50  0000 L CNN
F 2 "" H 4250 2100 50  0000 C CNN
F 3 "" H 4250 2100 50  0000 C CNN
	1    4250 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	3650 1800 4850 1800
Wire Wire Line
	4250 1800 4250 1950
$Comp
L GND #PWR1
U 1 1 57D1B22B
P 1900 3500
F 0 "#PWR1" H 1900 3250 50  0001 C CNN
F 1 "GND" H 1900 3350 50  0000 C CNN
F 2 "" H 1900 3500 50  0000 C CNN
F 3 "" H 1900 3500 50  0000 C CNN
	1    1900 3500
	1    0    0    -1  
$EndComp
Connection ~ 4250 1800
Wire Wire Line
	3650 2400 4850 2400
Wire Wire Line
	4250 2250 4250 2400
Connection ~ 4250 2400
$Sheet
S 7450 1450 1400 2100
U 57D37695
F0 "Front-End" 60
F1 "Front-End.sch" 60
F2 "VIN+" I L 7450 1800 60 
F3 "VIN-" U L 7450 2400 60 
F4 "DISCH1" I L 7450 2900 60 
F5 "ECG+" O R 8850 2900 60 
F6 "ECG-" O R 8850 3350 60 
F7 "DISCH2" I L 7450 3350 60 
F8 "TO_PATIENT-" B R 8850 2400 60 
F9 "TO_PATIENT+" B R 8850 1800 60 
$EndSheet
Text GLabel 9450 1800 2    60   BiDi ~ 0
TO_PATIENT+
Text GLabel 9450 2400 2    60   BiDi ~ 0
TO_PATIENT-
Wire Wire Line
	6250 1800 7450 1800
Wire Wire Line
	7450 2400 6250 2400
Wire Wire Line
	8850 1800 9450 1800
Wire Wire Line
	9450 2400 8850 2400
Wire Wire Line
	1900 3500 1900 3200
Wire Wire Line
	1900 3200 2250 3200
$EndSCHEMATC
