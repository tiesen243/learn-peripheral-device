
_send:

;firmware.c,16 :: 		void send(char msg) {
;firmware.c,17 :: 		writebuff[0] = msg;
	MOVF        FARG_send_msg+0, 0 
	MOVWF       1344 
;firmware.c,18 :: 		HID_Write(&writebuff, out_size);
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Write_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Write_writebuff+1 
	MOVLW       1
	MOVWF       FARG_HID_Write_len+0 
	CALL        _HID_Write+0, 0
;firmware.c,19 :: 		}
L_end_send:
	RETURN      0
; end of _send

_turn_off_all_led:

;firmware.c,21 :: 		void turn_off_all_led() {
;firmware.c,22 :: 		RED = 0;
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;firmware.c,23 :: 		YELLOW = 0;
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
;firmware.c,24 :: 		GREEN = 0;
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
;firmware.c,25 :: 		}
L_end_turn_off_all_led:
	RETURN      0
; end of _turn_off_all_led

_delay:

;firmware.c,27 :: 		void delay(int time) {
;firmware.c,29 :: 		for (i = 0; i < time; i++) {
	CLRF        delay_i_L0+0 
	CLRF        delay_i_L0+1 
L_delay0:
	MOVF        FARG_delay_time+1, 0 
	SUBWF       delay_i_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay44
	MOVF        FARG_delay_time+0, 0 
	SUBWF       delay_i_L0+0, 0 
L__delay44:
	BTFSC       STATUS+0, 0 
	GOTO        L_delay1
;firmware.c,31 :: 		if (HID_Read() != 0) {
	CALL        _HID_Read+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_delay3
;firmware.c,32 :: 		if (readbuff[0] == 'T') {
	MOVF        1280, 0 
	XORLW       84
	BTFSS       STATUS+0, 2 
	GOTO        L_delay4
;firmware.c,33 :: 		control_source = 1 - control_source;
	MOVF        _control_source+0, 0 
	SUBLW       1
	MOVWF       _control_source+0 
	MOVF        _control_source+1, 0 
	MOVWF       _control_source+1 
	MOVLW       0
	SUBFWB      _control_source+1, 1 
;firmware.c,34 :: 		if (control_source == 0) send('T');
	MOVLW       0
	XORWF       _control_source+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay45
	MOVLW       0
	XORWF       _control_source+0, 0 
L__delay45:
	BTFSS       STATUS+0, 2 
	GOTO        L_delay5
	MOVLW       84
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay6
L_delay5:
;firmware.c,35 :: 		else send('F');
	MOVLW       70
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
L_delay6:
;firmware.c,36 :: 		}
L_delay4:
;firmware.c,38 :: 		if (control_source == 1) {
	MOVLW       0
	XORWF       _control_source+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay46
	MOVLW       1
	XORWF       _control_source+0, 0 
L__delay46:
	BTFSS       STATUS+0, 2 
	GOTO        L_delay7
;firmware.c,39 :: 		if (readbuff[0] == '1') { mode = 1; turn_off_all_led(); send('Y'); break; }
	MOVF        1280, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_delay8
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       89
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
L_delay8:
;firmware.c,40 :: 		else if (readbuff[0] == '2') { mode = 2; turn_off_all_led(); send('U'); break;}
	MOVF        1280, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_delay10
	MOVLW       2
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       85
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
L_delay10:
;firmware.c,41 :: 		else if (readbuff[0] == '3') { mode = 3; turn_off_all_led(); send('K'); break; }
	MOVF        1280, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_delay12
	MOVLW       3
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       75
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
L_delay12:
;firmware.c,42 :: 		}
L_delay7:
;firmware.c,43 :: 		}
L_delay3:
;firmware.c,45 :: 		if (control_source == 0) {
	MOVLW       0
	XORWF       _control_source+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__delay47
	MOVLW       0
	XORWF       _control_source+0, 0 
L__delay47:
	BTFSS       STATUS+0, 2 
	GOTO        L_delay13
;firmware.c,46 :: 		if (BUTTON(&PORTB, 0, 10, 0)) {
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay14
;firmware.c,47 :: 		while (BUTTON(&PORTB, 0, 10, 0));
L_delay15:
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	CLRF        FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay16
	GOTO        L_delay15
L_delay16:
;firmware.c,48 :: 		mode = 1; turn_off_all_led(); send('Y'); break;
	MOVLW       1
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       89
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
;firmware.c,49 :: 		} else if (BUTTON(&PORTB, 1, 10, 0)) {
L_delay14:
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay18
;firmware.c,50 :: 		while (BUTTON(&PORTB, 1, 10, 0));
L_delay19:
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       1
	MOVWF       FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay20
	GOTO        L_delay19
L_delay20:
;firmware.c,51 :: 		mode = 2; turn_off_all_led(); send('U'); break;
	MOVLW       2
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       85
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
;firmware.c,52 :: 		} else if (BUTTON(&PORTB, 2, 10, 0)) {
L_delay18:
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay22
;firmware.c,53 :: 		while (BUTTON(&PORTB, 2, 10, 0));
L_delay23:
	MOVLW       PORTB+0
	MOVWF       FARG_Button_port+0 
	MOVLW       hi_addr(PORTB+0)
	MOVWF       FARG_Button_port+1 
	MOVLW       2
	MOVWF       FARG_Button_pin+0 
	MOVLW       10
	MOVWF       FARG_Button_time_ms+0 
	CLRF        FARG_Button_active_state+0 
	CALL        _Button+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_delay24
	GOTO        L_delay23
L_delay24:
;firmware.c,54 :: 		mode = 3; turn_off_all_led(); send('K'); break;
	MOVLW       3
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CALL        _turn_off_all_led+0, 0
	MOVLW       75
	MOVWF       FARG_send_msg+0 
	CALL        _send+0, 0
	GOTO        L_delay1
;firmware.c,55 :: 		}
L_delay22:
;firmware.c,56 :: 		}
L_delay13:
;firmware.c,57 :: 		Delay_ms(1);
	MOVLW       7
	MOVWF       R12, 0
	MOVLW       125
	MOVWF       R13, 0
L_delay25:
	DECFSZ      R13, 1, 1
	BRA         L_delay25
	DECFSZ      R12, 1, 1
	BRA         L_delay25
;firmware.c,29 :: 		for (i = 0; i < time; i++) {
	INFSNZ      delay_i_L0+0, 1 
	INCF        delay_i_L0+1, 1 
;firmware.c,58 :: 		}
	GOTO        L_delay0
L_delay1:
;firmware.c,59 :: 		}
L_end_delay:
	RETURN      0
; end of _delay

_interrupt:

;firmware.c,63 :: 		void interrupt(void) {
;firmware.c,64 :: 		if (USBIF_bit == 1) {
	BTFSS       USBIF_bit+0, BitPos(USBIF_bit+0) 
	GOTO        L_interrupt26
;firmware.c,65 :: 		USBIF_bit = 0;
	BCF         USBIF_bit+0, BitPos(USBIF_bit+0) 
;firmware.c,66 :: 		USB_Interrupt_Proc();
	CALL        _USB_Interrupt_Proc+0, 0
;firmware.c,67 :: 		}
L_interrupt26:
;firmware.c,68 :: 		}
L_end_interrupt:
L__interrupt49:
	RETFIE      1
; end of _interrupt

_setup:

;firmware.c,70 :: 		void setup() {
;firmware.c,71 :: 		ADCON1 |= 0x0F;
	MOVLW       15
	IORWF       ADCON1+0, 1 
;firmware.c,72 :: 		CMCON  |= 0X07;
	MOVLW       7
	IORWF       CMCON+0, 1 
;firmware.c,75 :: 		PORTB = 0x00; LATB = 0x00;
	CLRF        PORTB+0 
	CLRF        LATB+0 
;firmware.c,76 :: 		TRISB0_bit = 1; TRISB1_bit = 1; TRISB2_bit = 1;
	BSF         TRISB0_bit+0, BitPos(TRISB0_bit+0) 
	BSF         TRISB1_bit+0, BitPos(TRISB1_bit+0) 
	BSF         TRISB2_bit+0, BitPos(TRISB2_bit+0) 
;firmware.c,79 :: 		PORTE = 0x00; LATE = 0x00;
	CLRF        PORTE+0 
	CLRF        LATE+0 
;firmware.c,80 :: 		TRISE0_bit = 0; TRISE1_bit = 0; TRISE2_bit = 0;
	BCF         TRISE0_bit+0, BitPos(TRISE0_bit+0) 
	BCF         TRISE1_bit+0, BitPos(TRISE1_bit+0) 
	BCF         TRISE2_bit+0, BitPos(TRISE2_bit+0) 
;firmware.c,83 :: 		UPUEN_bit = 1;
	BSF         UPUEN_bit+0, BitPos(UPUEN_bit+0) 
;firmware.c,84 :: 		FSEN_bit = 1;
	BSF         FSEN_bit+0, BitPos(FSEN_bit+0) 
;firmware.c,85 :: 		HID_Enable(&readbuff, &writebuff);
	MOVLW       _readbuff+0
	MOVWF       FARG_HID_Enable_readbuff+0 
	MOVLW       hi_addr(_readbuff+0)
	MOVWF       FARG_HID_Enable_readbuff+1 
	MOVLW       _writebuff+0
	MOVWF       FARG_HID_Enable_writebuff+0 
	MOVLW       hi_addr(_writebuff+0)
	MOVWF       FARG_HID_Enable_writebuff+1 
	CALL        _HID_Enable+0, 0
;firmware.c,88 :: 		USBIF_bit = 0;
	BCF         USBIF_bit+0, BitPos(USBIF_bit+0) 
;firmware.c,89 :: 		USBIE_bit = 1;
	BSF         USBIE_bit+0, BitPos(USBIE_bit+0) 
;firmware.c,90 :: 		PEIE_bit = 1;
	BSF         PEIE_bit+0, BitPos(PEIE_bit+0) 
;firmware.c,91 :: 		GIE_bit = 1;
	BSF         GIE_bit+0, BitPos(GIE_bit+0) 
;firmware.c,93 :: 		Delay_ms(100);
	MOVLW       3
	MOVWF       R11, 0
	MOVLW       138
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_setup27:
	DECFSZ      R13, 1, 1
	BRA         L_setup27
	DECFSZ      R12, 1, 1
	BRA         L_setup27
	DECFSZ      R11, 1, 1
	BRA         L_setup27
	NOP
	NOP
;firmware.c,94 :: 		turn_off_all_led();
	CALL        _turn_off_all_led+0, 0
;firmware.c,95 :: 		mode = 3; control_source = 0;
	MOVLW       3
	MOVWF       _mode+0 
	MOVLW       0
	MOVWF       _mode+1 
	CLRF        _control_source+0 
	CLRF        _control_source+1 
;firmware.c,96 :: 		}
L_end_setup:
	RETURN      0
; end of _setup

_loop:

;firmware.c,98 :: 		void loop() {
;firmware.c,99 :: 		if (mode == 1) {
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__loop52
	MOVLW       1
	XORWF       _mode+0, 0 
L__loop52:
	BTFSS       STATUS+0, 2 
	GOTO        L_loop28
;firmware.c,100 :: 		RED = 1;
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
;firmware.c,101 :: 		delay(1);
	MOVLW       1
	MOVWF       FARG_delay_time+0 
	MOVLW       0
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
;firmware.c,102 :: 		} else if (mode == 2) {
	GOTO        L_loop29
L_loop28:
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__loop53
	MOVLW       2
	XORWF       _mode+0, 0 
L__loop53:
	BTFSS       STATUS+0, 2 
	GOTO        L_loop30
;firmware.c,103 :: 		YELLOW = 1; delay(1000);
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	MOVLW       232
	MOVWF       FARG_delay_time+0 
	MOVLW       3
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
;firmware.c,104 :: 		YELLOW = 0; delay(1000);
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	MOVLW       232
	MOVWF       FARG_delay_time+0 
	MOVLW       3
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
;firmware.c,105 :: 		} else if (mode == 3) {
	GOTO        L_loop31
L_loop30:
	MOVLW       0
	XORWF       _mode+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__loop54
	MOVLW       3
	XORWF       _mode+0, 0 
L__loop54:
	BTFSS       STATUS+0, 2 
	GOTO        L_loop32
;firmware.c,106 :: 		if (RED == 1) { RED = 0; YELLOW = 1; delay(3000); }
	BTFSS       LATE0_bit+0, BitPos(LATE0_bit+0) 
	GOTO        L_loop33
	BCF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	BSF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	MOVLW       184
	MOVWF       FARG_delay_time+0 
	MOVLW       11
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
	GOTO        L_loop34
L_loop33:
;firmware.c,107 :: 		else if (YELLOW == 1) { YELLOW = 0; GREEN = 1; delay(10000); }
	BTFSS       LATE1_bit+0, BitPos(LATE1_bit+0) 
	GOTO        L_loop35
	BCF         LATE1_bit+0, BitPos(LATE1_bit+0) 
	BSF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	MOVLW       16
	MOVWF       FARG_delay_time+0 
	MOVLW       39
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
	GOTO        L_loop36
L_loop35:
;firmware.c,108 :: 		else if (GREEN == 1) {  GREEN = 0; RED = 1; delay(5000); }
	BTFSS       LATE2_bit+0, BitPos(LATE2_bit+0) 
	GOTO        L_loop37
	BCF         LATE2_bit+0, BitPos(LATE2_bit+0) 
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	MOVLW       136
	MOVWF       FARG_delay_time+0 
	MOVLW       19
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
	GOTO        L_loop38
L_loop37:
;firmware.c,109 :: 		else { RED = 1; delay(5000); }
	BSF         LATE0_bit+0, BitPos(LATE0_bit+0) 
	MOVLW       136
	MOVWF       FARG_delay_time+0 
	MOVLW       19
	MOVWF       FARG_delay_time+1 
	CALL        _delay+0, 0
L_loop38:
L_loop36:
L_loop34:
;firmware.c,110 :: 		}
L_loop32:
L_loop31:
L_loop29:
;firmware.c,111 :: 		}
L_end_loop:
	RETURN      0
; end of _loop

_main:

;firmware.c,113 :: 		void main() {
;firmware.c,114 :: 		setup();
	CALL        _setup+0, 0
;firmware.c,115 :: 		while (1) loop();
L_main39:
	CALL        _loop+0, 0
	GOTO        L_main39
;firmware.c,116 :: 		}
L_end_main:
	GOTO        $+0
; end of _main
