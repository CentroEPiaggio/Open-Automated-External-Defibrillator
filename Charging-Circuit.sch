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
Sheet 2 4
Title "Charging Circuit"
Date "2017-05-30"
Rev "0.2"
Comp ""
Comment1 "This circuit charges the capacitor."
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text HLabel 1280 1280 0    98   Input ~ 0
VIN
Text HLabel 1280 5680 0    98   UnSpc ~ 0
GND
$Comp
L R Rst1
U 1 1 57D16C90
P 2630 2880
F 0 "Rst1" V 2750 2885 98  0000 C CNN
F 1 "200" V 2630 2880 50  0000 C CNN
F 2 "" V 2560 2880 50  0000 C CNN
F 3 "" H 2630 2880 50  0000 C CNN
	1    2630 2880
	1    0    0    -1  
$EndComp
$Comp
L TRANSFO2 T1
U 1 1 57D16F9F
P 5430 2180
F 0 "T1" H 5430 2680 50  0000 C CNN
F 1 "TRANSFO2" H 5430 1680 98  0000 C CNN
F 2 "" H 5430 2180 50  0000 C CNN
F 3 "" H 5430 2180 50  0000 C CNN
	1    5430 2180
	-1   0    0    -1  
$EndComp
$Comp
L Q_NPN_BCE Q1
U 1 1 57D17246
P 3580 4930
F 0 "Q1" H 3910 5085 98  0000 R CNN
F 1 "2N222" H 3885 4660 98  0000 R CNN
F 2 "" H 3780 5030 50  0000 C CNN
F 3 "" H 3580 4930 50  0000 C CNN
	1    3580 4930
	-1   0    0    -1  
$EndComp
$Comp
L Q_NMOS_GDS S1
U 1 1 57D172FF
P 1730 3630
F 0 "S1" H 2060 3685 98  0000 R CNN
F 1 "IRFP250N" H 2160 3360 98  0000 R CNN
F 2 "" H 1930 3730 50  0000 C CNN
F 3 "" H 1730 3630 50  0000 C CNN
	1    1730 3630
	-1   0    0    -1  
$EndComp
$Comp
L R Rs1
U 1 1 57D17382
P 1630 4780
F 0 "Rs1" V 1750 4785 98  0000 C CNN
F 1 "0.2" V 1630 4780 50  0000 C CNN
F 2 "" V 1560 4780 50  0000 C CNN
F 3 "" H 1630 4780 50  0000 C CNN
	1    1630 4780
	1    0    0    -1  
$EndComp
$Comp
L R Rb1
U 1 1 57D1740A
P 2330 4280
F 0 "Rb1" V 2450 4275 98  0000 C CNN
F 1 "20" V 2330 4280 50  0000 C CNN
F 2 "" V 2260 4280 50  0000 C CNN
F 3 "" H 2330 4280 50  0000 C CNN
	1    2330 4280
	0    1    1    0   
$EndComp
$Comp
L C Cb1
U 1 1 57D174A8
P 4480 5380
F 0 "Cb1" H 4505 5480 98  0000 L CNN
F 1 "15µ" H 4505 5280 50  0000 L CNN
F 2 "" H 4518 5230 50  0000 C CNN
F 3 "" H 4480 5380 50  0000 C CNN
	1    4480 5380
	1    0    0    -1  
$EndComp
$Comp
L ZENER Z1
U 1 1 57D176A8
P 2630 4930
F 0 "Z1" H 2625 5075 98  0000 C CNN
F 1 "ZENER" H 2630 4830 50  0000 C CNN
F 2 "" H 2630 4930 50  0000 C CNN
F 3 "" H 2630 4930 50  0000 C CNN
	1    2630 4930
	0    1    1    0   
$EndComp
$Comp
L R Rf1
U 1 1 57D17921
P 3970 2280
F 0 "Rf1" V 4090 2285 98  0000 C CNN
F 1 "3k" V 3970 2280 50  0000 C CNN
F 2 "" V 3900 2280 50  0000 C CNN
F 3 "" H 3970 2280 50  0000 C CNN
	1    3970 2280
	0    1    1    0   
$EndComp
$Comp
L C Cf1
U 1 1 57D17964
P 3480 2880
F 0 "Cf1" H 3560 3025 98  0000 L CNN
F 1 "250n" H 3505 2780 50  0000 L CNN
F 2 "" H 3518 2730 50  0000 C CNN
F 3 "" H 3480 2880 50  0000 C CNN
	1    3480 2880
	-1   0    0    1   
$EndComp
$Comp
L TLP785 U1
U 1 1 57D17C41
P 6130 4180
F 0 "U1" H 5930 4380 50  0000 L CNN
F 1 "TLP785" H 6130 4380 50  0000 L CNN
F 2 "DIP-4" H 5930 3980 50  0001 L CIN
F 3 "" H 6130 4180 50  0000 L CNN
	1    6130 4180
	-1   0    0    -1  
$EndComp
$Comp
L D_Schottky D1
U 1 1 57D17D85
P 6880 1280
F 0 "D1" H 6860 1410 98  0000 C CNN
F 1 "D_Schottky" H 6880 1180 98  0000 C CNN
F 2 "" H 6880 1280 50  0000 C CNN
F 3 "" H 6880 1280 50  0000 C CNN
	1    6880 1280
	-1   0    0    -1  
$EndComp
$Comp
L D_Schottky D3
U 1 1 57D17F21
P 8380 1280
F 0 "D3" H 8360 1410 98  0000 C CNN
F 1 "D_Schottky" H 8380 1180 98  0000 C CNN
F 2 "" H 8380 1280 50  0000 C CNN
F 3 "" H 8380 1280 50  0000 C CNN
	1    8380 1280
	-1   0    0    -1  
$EndComp
Text HLabel 10130 1280 2    98   Output ~ 0
HV-OUT+
Text HLabel 10130 2380 2    98   Output ~ 0
HV-OUT-
$Comp
L R Rd1
U 1 1 57D181CE
P 9380 2960
F 0 "Rd1" V 9500 2970 98  0000 C CNN
F 1 "169.75M" V 9380 2960 50  0000 C CNN
F 2 "" V 9310 2960 50  0000 C CNN
F 3 "" H 9380 2960 50  0000 C CNN
	1    9380 2960
	1    0    0    -1  
$EndComp
$Comp
L R Rd2
U 1 1 57D18277
P 9380 5470
F 0 "Rd2" V 9500 5465 98  0000 C CNN
F 1 "250k" V 9380 5470 50  0000 C CNN
F 2 "" V 9310 5470 50  0000 C CNN
F 3 "" H 9380 5470 50  0000 C CNN
	1    9380 5470
	1    0    0    -1  
$EndComp
$Comp
L C Cc2
U 1 1 57D18A6E
P 8530 4280
F 0 "Cc2" H 8575 4425 98  0000 L CNN
F 1 "15p" H 8555 4180 50  0000 L CNN
F 2 "" H 8568 4130 50  0000 C CNN
F 3 "" H 8530 4280 50  0000 C CNN
	1    8530 4280
	0    1    1    0   
$EndComp
$Comp
L C Cc1
U 1 1 57D18B14
P 8530 3580
F 0 "Cc1" H 8575 3725 98  0000 L CNN
F 1 "15p" H 8555 3480 50  0000 L CNN
F 2 "" H 8568 3430 50  0000 C CNN
F 3 "" H 8530 3580 50  0000 C CNN
	1    8530 3580
	0    1    1    0   
$EndComp
$Comp
L R Rc1
U 1 1 57D18B83
P 7580 3580
F 0 "Rc1" V 7700 3575 98  0000 C CNN
F 1 "500" V 7580 3580 50  0000 C CNN
F 2 "" V 7510 3580 50  0000 C CNN
F 3 "" H 7580 3580 50  0000 C CNN
	1    7580 3580
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 57D18E57
P 5430 3830
F 0 "R1" V 5550 3835 98  0000 C CNN
F 1 "500" V 5430 3830 50  0000 C CNN
F 2 "" V 5360 3830 50  0000 C CNN
F 3 "" H 5430 3830 50  0000 C CNN
	1    5430 3830
	1    0    0    -1  
$EndComp
$Comp
L R R2
U 1 1 57D18F8E
P 6530 3830
F 0 "R2" V 6650 3835 98  0000 C CNN
F 1 "500" V 6530 3830 50  0000 C CNN
F 2 "" V 6460 3830 50  0000 C CNN
F 3 "" H 6530 3830 50  0000 C CNN
	1    6530 3830
	1    0    0    -1  
$EndComp
Text HLabel 6530 3230 2    60   Input ~ 0
VIN
$Comp
L TL431PK D2
U 1 1 57D1924A
P 6980 4930
F 0 "D2" V 6860 5075 98  0000 C CNN
F 1 "TL431" H 6980 4830 98  0000 C CNN
F 2 "SOT-89" H 6980 4780 50  0001 C CIN
F 3 "" H 6980 4930 50  0000 C CNN
	1    6980 4930
	0    1    -1   0   
$EndComp
Text HLabel 10615 4180 2    98   Output ~ 0
Vsense
Wire Wire Line
	1280 1280 5030 1280
Wire Wire Line
	1630 2080 5030 2080
Wire Wire Line
	1630 2080 1630 3430
Wire Wire Line
	2630 2730 2630 1280
Connection ~ 2630 1280
Wire Wire Line
	5030 1280 5030 1780
Wire Wire Line
	3480 3030 3480 4730
Connection ~ 3480 3630
Wire Wire Line
	1630 3830 1630 4630
Wire Wire Line
	1630 4280 2180 4280
Connection ~ 1630 4280
Wire Wire Line
	2480 4280 5830 4280
Wire Wire Line
	4480 3630 4480 5230
Wire Wire Line
	4480 4930 3780 4930
Connection ~ 4480 4930
Wire Wire Line
	1630 5680 1630 4930
Connection ~ 1630 5680
Wire Wire Line
	3480 5680 3480 5130
Connection ~ 3480 5680
Wire Wire Line
	2630 5680 2630 5130
Connection ~ 2630 5680
Wire Wire Line
	2630 3030 2630 4730
Connection ~ 2630 3630
Wire Wire Line
	4120 2280 5030 2280
Wire Wire Line
	3820 2280 3480 2280
Wire Wire Line
	3480 2280 3480 2730
Wire Wire Line
	5030 5680 5030 2580
Wire Wire Line
	1930 3630 3955 3630
Connection ~ 4480 4280
Wire Wire Line
	5830 1980 6030 1980
Wire Wire Line
	6030 1980 6030 1280
Wire Wire Line
	6030 1280 6730 1280
Wire Wire Line
	7030 1280 8230 1280
Wire Wire Line
	5030 2830 6030 2830
Connection ~ 5030 2830
Wire Wire Line
	8530 1280 10130 1280
Wire Wire Line
	5830 2380 10130 2380
Wire Wire Line
	6030 2830 6030 2380
Connection ~ 6030 2380
Wire Wire Line
	9380 1280 9380 2810
Connection ~ 9380 1280
Wire Wire Line
	9380 3110 9380 5320
Wire Wire Line
	9380 6030 9380 5620
Wire Wire Line
	6980 3580 6980 4830
Wire Wire Line
	5430 3980 5430 4080
Wire Wire Line
	5430 4080 5830 4080
Wire Wire Line
	5430 3680 5430 3580
Wire Wire Line
	6530 3980 6530 4080
Wire Wire Line
	6530 4080 6430 4080
Wire Wire Line
	5430 3580 6530 3580
Wire Wire Line
	6530 3230 6530 3680
Connection ~ 6530 3580
Wire Wire Line
	6980 6030 6980 5030
Wire Wire Line
	7080 4930 9380 4930
Connection ~ 9380 4930
Wire Wire Line
	6430 4280 8380 4280
Wire Wire Line
	7730 3580 8380 3580
Wire Wire Line
	1280 5680 5030 5680
Wire Wire Line
	1380 5680 1380 6030
Wire Wire Line
	1380 6030 9680 6030
Connection ~ 1380 5680
Connection ~ 6980 6030
Wire Wire Line
	4480 5530 4480 6030
Connection ~ 4480 6030
Connection ~ 6980 4280
Connection ~ 9380 4280
Wire Wire Line
	6980 3580 7430 3580
Wire Wire Line
	8680 3580 9380 3580
Connection ~ 9380 3580
$Comp
L LM358 U16
U 1 1 58981285
P 10130 4180
F 0 "U16" H 10130 4380 50  0000 L CNN
F 1 "LM358" H 10130 3980 98  0000 L CNN
F 2 "" H 10130 4180 50  0000 C CNN
F 3 "" H 10130 4180 50  0000 C CNN
	1    10130 4180
	1    0    0    -1  
$EndComp
Wire Wire Line
	8680 4280 9830 4280
Wire Wire Line
	9830 4080 9680 4080
Wire Wire Line
	9680 4080 9680 6030
Wire Wire Line
	9680 4490 10030 4490
Wire Wire Line
	10030 4490 10030 4480
Connection ~ 9380 6030
Connection ~ 9680 4490
Text HLabel 10030 3645 2    98   Input ~ 0
VIN
Wire Wire Line
	10030 3645 10030 3880
Wire Wire Line
	10430 4180 10615 4180
Wire Wire Line
	9565 4280 9565 3460
Wire Wire Line
	9565 3460 10485 3460
Wire Wire Line
	10485 3460 10485 4180
Connection ~ 10485 4180
Connection ~ 9565 4280
$Comp
L D_Schottky_Small D4
U 1 1 589AE664
P 4055 3630
F 0 "D4" H 4000 3760 98  0000 L CNN
F 1 "D_Schottky_Small" H 3775 3550 50  0001 L CNN
F 2 "" V 4055 3630 50  0000 C CNN
F 3 "" V 4055 3630 50  0000 C CNN
	1    4055 3630
	1    0    0    -1  
$EndComp
Wire Wire Line
	4155 3630 4480 3630
$EndSCHEMATC
