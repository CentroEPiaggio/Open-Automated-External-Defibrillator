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
Sheet 4 4
Title "Front End"
Date "2016-09-09"
Rev "0.1"
Comp ""
Comment1 "AED front end."
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L RTE24012 K1
U 1 1 57D37E30
P 4100 3700
F 0 "K1" H 4100 3200 60  0000 C CNN
F 1 "RTE24012" H 4100 4200 60  0000 C CNN
F 2 "" H 4100 3700 60  0000 C CNN
F 3 "" H 4100 3700 60  0000 C CNN
	1    4100 3700
	1    0    0    -1  
$EndComp
Text HLabel 2700 3350 0    60   Input ~ 0
VIN+
Text HLabel 2700 3550 0    60   UnSpc ~ 0
VIN-
Wire Wire Line
	2700 3350 3550 3350
Wire Wire Line
	3550 3550 2700 3550
Text HLabel 2700 4050 0    60   UnSpc ~ 0
GND
Wire Wire Line
	2700 4050 3550 4050
Wire Wire Line
	3550 3850 2700 3850
Text HLabel 2700 3850 0    60   Input ~ 0
DISCH1
$Comp
L R R3
U 1 1 57D37EBA
P 5050 3350
F 0 "R3" V 5130 3350 50  0000 C CNN
F 1 "R" V 5050 3350 50  0000 C CNN
F 2 "" V 4980 3350 50  0000 C CNN
F 3 "" H 5050 3350 50  0000 C CNN
	1    5050 3350
	0    1    1    0   
$EndComp
Wire Wire Line
	4650 3350 4900 3350
Wire Wire Line
	4650 3550 5400 3550
$Comp
L RTE24012 K2
U 1 1 57D37F50
P 7500 3700
F 0 "K2" H 7500 3200 60  0000 C CNN
F 1 "RTE24012" H 7500 4200 60  0000 C CNN
F 2 "" H 7500 3700 60  0000 C CNN
F 3 "" H 7500 3700 60  0000 C CNN
	1    7500 3700
	-1   0    0    -1  
$EndComp
Wire Wire Line
	5200 3350 5400 3350
Wire Wire Line
	5400 3350 5400 3550
Wire Wire Line
	4650 3850 6950 3850
Wire Wire Line
	6950 4050 4650 4050
Text HLabel 6400 3350 0    60   Output ~ 0
ECG+
Text HLabel 6400 3550 0    60   Output ~ 0
ECG-
Wire Wire Line
	6400 3350 6950 3350
Wire Wire Line
	6950 3550 6400 3550
Text HLabel 8850 3850 2    60   Input ~ 0
DISCH2
Text HLabel 8850 4050 2    60   UnSpc ~ 0
GND
Wire Wire Line
	8850 4050 8050 4050
Wire Wire Line
	8850 3850 8050 3850
Wire Wire Line
	8050 3350 8850 3350
Wire Wire Line
	8050 3550 8850 3550
Text HLabel 8850 3550 2    60   BiDi ~ 0
TO_PATIENT-
Text HLabel 8850 3350 2    60   BiDi ~ 0
TO_PATIENT+
$EndSCHEMATC
