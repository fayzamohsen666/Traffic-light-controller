
_main:

;TrafficLight.c,29 :: 		void main() {
;TrafficLight.c,30 :: 		ADCON1 = 0x07;        // Digital I/O
	MOVLW      7
	MOVWF      ADCON1+0
;TrafficLight.c,31 :: 		trisb  = 0x03;        // RB0,RB1 input
	MOVLW      3
	MOVWF      TRISB+0
;TrafficLight.c,32 :: 		trisc  = 0; portc = 0;
	CLRF       TRISC+0
	CLRF       PORTC+0
;TrafficLight.c,33 :: 		trisd  = 0; portd = 0;
	CLRF       TRISD+0
	CLRF       PORTD+0
;TrafficLight.c,35 :: 		intedg_bit = 0;
	BCF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
;TrafficLight.c,36 :: 		inte_bit   = 1;
	BSF        INTE_bit+0, BitPos(INTE_bit+0)
;TrafficLight.c,37 :: 		gie_bit    = 1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;TrafficLight.c,39 :: 		while (1) {
L_main0:
;TrafficLight.c,40 :: 		if (mode == auto)
	MOVF       _mode+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_main2
;TrafficLight.c,41 :: 		automatic();
	CALL       _automatic+0
	GOTO       L_main3
L_main2:
;TrafficLight.c,42 :: 		else if (mode == manu)
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main4
;TrafficLight.c,43 :: 		manual();
	CALL       _manual+0
L_main4:
L_main3:
;TrafficLight.c,44 :: 		}
	GOTO       L_main0
;TrafficLight.c,45 :: 		}
L_end_main:
	GOTO       $+0
; end of _main

_display:

;TrafficLight.c,48 :: 		void display(int wNumber, int sNumber) {
;TrafficLight.c,49 :: 		int wleft  = wNumber / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_display_wNumber+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_wNumber+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      display_wleft_L0+0
	MOVF       R0+1, 0
	MOVWF      display_wleft_L0+1
;TrafficLight.c,50 :: 		int wright = wNumber % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_display_wNumber+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_wNumber+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      display_wright_L0+0
	MOVF       R0+1, 0
	MOVWF      display_wright_L0+1
;TrafficLight.c,51 :: 		int sleft  = sNumber / 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_display_sNumber+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_sNumber+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R0+0, 0
	MOVWF      display_sleft_L0+0
	MOVF       R0+1, 0
	MOVWF      display_sleft_L0+1
;TrafficLight.c,52 :: 		int sright = sNumber % 10;
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       FARG_display_sNumber+0, 0
	MOVWF      R0+0
	MOVF       FARG_display_sNumber+1, 0
	MOVWF      R0+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      display_sright_L0+0
	MOVF       R0+1, 0
	MOVWF      display_sright_L0+1
;TrafficLight.c,55 :: 		for (j = 0; j < 50; j++) {
	CLRF       display_j_L0+0
	CLRF       display_j_L0+1
L_display5:
	MOVLW      128
	XORWF      display_j_L0+1, 0
	MOVWF      R0+0
	MOVLW      128
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__display54
	MOVLW      50
	SUBWF      display_j_L0+0, 0
L__display54:
	BTFSC      STATUS+0, 0
	GOTO       L_display6
;TrafficLight.c,56 :: 		u = ON; t = OFF;
	BCF        PORTB+0, 2
	BSF        PORTB+0, 3
;TrafficLight.c,57 :: 		portc = (sright << 4) | wright;
	MOVLW      4
	MOVWF      R1+0
	MOVF       display_sright_L0+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
L__display55:
	BTFSC      STATUS+0, 2
	GOTO       L__display56
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__display55
L__display56:
	MOVF       display_wright_L0+0, 0
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;TrafficLight.c,58 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_display8:
	DECFSZ     R13+0, 1
	GOTO       L_display8
	DECFSZ     R12+0, 1
	GOTO       L_display8
	NOP
	NOP
;TrafficLight.c,60 :: 		u = OFF; t = ON;
	BSF        PORTB+0, 2
	BCF        PORTB+0, 3
;TrafficLight.c,61 :: 		portc = (sleft << 4) | wleft;
	MOVLW      4
	MOVWF      R1+0
	MOVF       display_sleft_L0+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
L__display57:
	BTFSC      STATUS+0, 2
	GOTO       L__display58
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__display57
L__display58:
	MOVF       display_wleft_L0+0, 0
	IORWF      R0+0, 0
	MOVWF      PORTC+0
;TrafficLight.c,62 :: 		delay_ms(5);
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_display9:
	DECFSZ     R13+0, 1
	GOTO       L_display9
	DECFSZ     R12+0, 1
	GOTO       L_display9
	NOP
	NOP
;TrafficLight.c,55 :: 		for (j = 0; j < 50; j++) {
	INCF       display_j_L0+0, 1
	BTFSC      STATUS+0, 2
	INCF       display_j_L0+1, 1
;TrafficLight.c,63 :: 		}
	GOTO       L_display5
L_display6:
;TrafficLight.c,64 :: 		}
L_end_display:
	RETURN
; end of _display

_lights:

;TrafficLight.c,67 :: 		void lights(char config) {
;TrafficLight.c,68 :: 		switch (config) {
	GOTO       L_lights10
;TrafficLight.c,69 :: 		case 0: portd = 0b001100; break; // Green W, Red S
L_lights12:
	MOVLW      12
	MOVWF      PORTD+0
	GOTO       L_lights11
;TrafficLight.c,70 :: 		case 1: portd = 0b100001; break; // Green S, Red W
L_lights13:
	MOVLW      33
	MOVWF      PORTD+0
	GOTO       L_lights11
;TrafficLight.c,71 :: 		case 2: portd = 0b001010; break; // Yellow W
L_lights14:
	MOVLW      10
	MOVWF      PORTD+0
	GOTO       L_lights11
;TrafficLight.c,72 :: 		case 3: portd = 0b010001; break; // Yellow S
L_lights15:
	MOVLW      17
	MOVWF      PORTD+0
	GOTO       L_lights11
;TrafficLight.c,73 :: 		}
L_lights10:
	MOVF       FARG_lights_config+0, 0
	XORLW      0
	BTFSC      STATUS+0, 2
	GOTO       L_lights12
	MOVF       FARG_lights_config+0, 0
	XORLW      1
	BTFSC      STATUS+0, 2
	GOTO       L_lights13
	MOVF       FARG_lights_config+0, 0
	XORLW      2
	BTFSC      STATUS+0, 2
	GOTO       L_lights14
	MOVF       FARG_lights_config+0, 0
	XORLW      3
	BTFSC      STATUS+0, 2
	GOTO       L_lights15
L_lights11:
;TrafficLight.c,74 :: 		}
L_end_lights:
	RETURN
; end of _lights

_automatic:

;TrafficLight.c,77 :: 		void automatic() {
;TrafficLight.c,79 :: 		direction = west;
	CLRF       _direction+0
;TrafficLight.c,80 :: 		l1 = l2 = OFF;
	BSF        PORTB+0, 5
	BTFSC      PORTB+0, 5
	GOTO       L__automatic61
	BCF        PORTB+0, 4
	GOTO       L__automatic62
L__automatic61:
	BSF        PORTB+0, 4
L__automatic62:
;TrafficLight.c,82 :: 		if (gr1) {
	BTFSS      PORTD+0, 2
	GOTO       L_automatic16
;TrafficLight.c,83 :: 		lights(2); // Yellow W
	MOVLW      2
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,84 :: 		for (i = 3; i > 0; i--)
	MOVLW      3
	MOVWF      automatic_i_L0+0
	MOVLW      0
	MOVWF      automatic_i_L0+1
L_automatic17:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      automatic_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic63
	MOVF       automatic_i_L0+0, 0
	SUBLW      0
L__automatic63:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic18
;TrafficLight.c,85 :: 		display(i, 0);
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_wNumber+1
	CLRF       FARG_display_sNumber+0
	CLRF       FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,84 :: 		for (i = 3; i > 0; i--)
	MOVLW      1
	SUBWF      automatic_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       automatic_i_L0+1, 1
;TrafficLight.c,85 :: 		display(i, 0);
	GOTO       L_automatic17
L_automatic18:
;TrafficLight.c,86 :: 		}
L_automatic16:
;TrafficLight.c,88 :: 		flag = 0;
	CLRF       _flag+0
;TrafficLight.c,90 :: 		lights(1);
	MOVLW      1
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,91 :: 		for (i = 12; i > 0; i--) {
	MOVLW      12
	MOVWF      automatic_i_L0+0
	MOVLW      0
	MOVWF      automatic_i_L0+1
L_automatic20:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      automatic_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic64
	MOVF       automatic_i_L0+0, 0
	SUBLW      0
L__automatic64:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic21
;TrafficLight.c,92 :: 		if (mode == manu) return;
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_automatic23
	GOTO       L_end_automatic
L_automatic23:
;TrafficLight.c,93 :: 		display(i + 3, i);
	MOVLW      3
	ADDWF      automatic_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       automatic_i_L0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      FARG_display_wNumber+1
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_sNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,91 :: 		for (i = 12; i > 0; i--) {
	MOVLW      1
	SUBWF      automatic_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       automatic_i_L0+1, 1
;TrafficLight.c,94 :: 		}
	GOTO       L_automatic20
L_automatic21:
;TrafficLight.c,96 :: 		lights(3);
	MOVLW      3
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,97 :: 		for (i = 3; i > 0; i--) {
	MOVLW      3
	MOVWF      automatic_i_L0+0
	MOVLW      0
	MOVWF      automatic_i_L0+1
L_automatic24:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      automatic_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic65
	MOVF       automatic_i_L0+0, 0
	SUBLW      0
L__automatic65:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic25
;TrafficLight.c,98 :: 		if (mode == manu) return;
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_automatic27
	GOTO       L_end_automatic
L_automatic27:
;TrafficLight.c,99 :: 		display(i, i);
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_wNumber+1
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_sNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,97 :: 		for (i = 3; i > 0; i--) {
	MOVLW      1
	SUBWF      automatic_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       automatic_i_L0+1, 1
;TrafficLight.c,100 :: 		}
	GOTO       L_automatic24
L_automatic25:
;TrafficLight.c,102 :: 		flag = 1;
	MOVLW      1
	MOVWF      _flag+0
;TrafficLight.c,104 :: 		lights(0);
	CLRF       FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,105 :: 		for (i = 20; i > 0; i--) {
	MOVLW      20
	MOVWF      automatic_i_L0+0
	MOVLW      0
	MOVWF      automatic_i_L0+1
L_automatic28:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      automatic_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic66
	MOVF       automatic_i_L0+0, 0
	SUBLW      0
L__automatic66:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic29
;TrafficLight.c,106 :: 		if (mode == manu) return;
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_automatic31
	GOTO       L_end_automatic
L_automatic31:
;TrafficLight.c,107 :: 		display(i, i + 3);
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_wNumber+1
	MOVLW      3
	ADDWF      automatic_i_L0+0, 0
	MOVWF      FARG_display_sNumber+0
	MOVF       automatic_i_L0+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,105 :: 		for (i = 20; i > 0; i--) {
	MOVLW      1
	SUBWF      automatic_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       automatic_i_L0+1, 1
;TrafficLight.c,108 :: 		}
	GOTO       L_automatic28
L_automatic29:
;TrafficLight.c,110 :: 		lights(2);
	MOVLW      2
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,111 :: 		for (i = 3; i > 0; i--) {
	MOVLW      3
	MOVWF      automatic_i_L0+0
	MOVLW      0
	MOVWF      automatic_i_L0+1
L_automatic32:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      automatic_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__automatic67
	MOVF       automatic_i_L0+0, 0
	SUBLW      0
L__automatic67:
	BTFSC      STATUS+0, 0
	GOTO       L_automatic33
;TrafficLight.c,112 :: 		if (mode == manu) return;
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_automatic35
	GOTO       L_end_automatic
L_automatic35:
;TrafficLight.c,113 :: 		display(i, i);
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_wNumber+1
	MOVF       automatic_i_L0+0, 0
	MOVWF      FARG_display_sNumber+0
	MOVF       automatic_i_L0+1, 0
	MOVWF      FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,111 :: 		for (i = 3; i > 0; i--) {
	MOVLW      1
	SUBWF      automatic_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       automatic_i_L0+1, 1
;TrafficLight.c,114 :: 		}
	GOTO       L_automatic32
L_automatic33:
;TrafficLight.c,115 :: 		}
L_end_automatic:
	RETURN
; end of _automatic

_manual:

;TrafficLight.c,118 :: 		void manual() {
;TrafficLight.c,121 :: 		if (flag) {
	MOVF       _flag+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_manual36
;TrafficLight.c,122 :: 		flag = 0;
	CLRF       _flag+0
;TrafficLight.c,123 :: 		l1 = 1; l2 = 0;
	BSF        PORTB+0, 4
	BCF        PORTB+0, 5
;TrafficLight.c,124 :: 		portc = 0;
	CLRF       PORTC+0
;TrafficLight.c,125 :: 		lights(0);
	CLRF       FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,126 :: 		} else {
	GOTO       L_manual37
L_manual36:
;TrafficLight.c,127 :: 		if (direction == west) {
	MOVF       _direction+0, 0
	XORLW      0
	BTFSS      STATUS+0, 2
	GOTO       L_manual38
;TrafficLight.c,128 :: 		l1 = 1; l2 = 0;
	BSF        PORTB+0, 4
	BCF        PORTB+0, 5
;TrafficLight.c,129 :: 		lights(3);
	MOVLW      3
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,130 :: 		for (i = 3; i > 0; i--)
	MOVLW      3
	MOVWF      manual_i_L0+0
	MOVLW      0
	MOVWF      manual_i_L0+1
L_manual39:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      manual_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual69
	MOVF       manual_i_L0+0, 0
	SUBLW      0
L__manual69:
	BTFSC      STATUS+0, 0
	GOTO       L_manual40
;TrafficLight.c,131 :: 		display(0, i);
	CLRF       FARG_display_wNumber+0
	CLRF       FARG_display_wNumber+1
	MOVF       manual_i_L0+0, 0
	MOVWF      FARG_display_sNumber+0
	MOVF       manual_i_L0+1, 0
	MOVWF      FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,130 :: 		for (i = 3; i > 0; i--)
	MOVLW      1
	SUBWF      manual_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       manual_i_L0+1, 1
;TrafficLight.c,131 :: 		display(0, i);
	GOTO       L_manual39
L_manual40:
;TrafficLight.c,132 :: 		lights(0);
	CLRF       FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,133 :: 		} else {
	GOTO       L_manual42
L_manual38:
;TrafficLight.c,134 :: 		l1 = 0; l2 = 1;
	BCF        PORTB+0, 4
	BSF        PORTB+0, 5
;TrafficLight.c,135 :: 		lights(2);
	MOVLW      2
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,136 :: 		for (i = 3; i > 0; i--)
	MOVLW      3
	MOVWF      manual_i_L0+0
	MOVLW      0
	MOVWF      manual_i_L0+1
L_manual43:
	MOVLW      128
	MOVWF      R0+0
	MOVLW      128
	XORWF      manual_i_L0+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__manual70
	MOVF       manual_i_L0+0, 0
	SUBLW      0
L__manual70:
	BTFSC      STATUS+0, 0
	GOTO       L_manual44
;TrafficLight.c,137 :: 		display(i, 0);
	MOVF       manual_i_L0+0, 0
	MOVWF      FARG_display_wNumber+0
	MOVF       manual_i_L0+1, 0
	MOVWF      FARG_display_wNumber+1
	CLRF       FARG_display_sNumber+0
	CLRF       FARG_display_sNumber+1
	CALL       _display+0
;TrafficLight.c,136 :: 		for (i = 3; i > 0; i--)
	MOVLW      1
	SUBWF      manual_i_L0+0, 1
	BTFSS      STATUS+0, 0
	DECF       manual_i_L0+1, 1
;TrafficLight.c,137 :: 		display(i, 0);
	GOTO       L_manual43
L_manual44:
;TrafficLight.c,138 :: 		lights(1);
	MOVLW      1
	MOVWF      FARG_lights_config+0
	CALL       _lights+0
;TrafficLight.c,139 :: 		}
L_manual42:
;TrafficLight.c,140 :: 		}
L_manual37:
;TrafficLight.c,142 :: 		u = 0; t = 0;
	BCF        PORTB+0, 2
	BCF        PORTB+0, 3
;TrafficLight.c,143 :: 		direction = !direction;
	MOVF       _direction+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _direction+0
;TrafficLight.c,145 :: 		while (dir == OFF && mode == manu); // Wait in manual mode
L_manual46:
	BTFSS      PORTB+0, 1
	GOTO       L_manual47
	MOVF       _mode+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_manual47
L__manual51:
	GOTO       L_manual46
L_manual47:
;TrafficLight.c,146 :: 		}
L_end_manual:
	RETURN
; end of _manual

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;TrafficLight.c,149 :: 		void interrupt() {
;TrafficLight.c,150 :: 		if (intf_bit) {
	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt50
;TrafficLight.c,151 :: 		intf_bit = 0;
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
;TrafficLight.c,152 :: 		mode = !mode;
	MOVF       _mode+0, 0
	MOVLW      1
	BTFSS      STATUS+0, 2
	MOVLW      0
	MOVWF      _mode+0
;TrafficLight.c,153 :: 		}
L_interrupt50:
;TrafficLight.c,154 :: 		}
L_end_interrupt:
L__interrupt72:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt
