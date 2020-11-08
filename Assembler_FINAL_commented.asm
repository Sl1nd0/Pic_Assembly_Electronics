#include P16F627A.INC
    
      ;My variable equates - declarations, for delay and password storer variables
	x equ 20h
	y equ 21h
	x2 equ 22h
	y2 equ 23h
	status equ 03h

	gen1 equ 24h
	gen2 equ 25h
	gen3 equ 26h
	gen11 equ 27h
	gen22 equ 28h
	gen33 equ 29h

init:
	 
	; Move 7 to INTCON
	movlw .7
	movwf 1fh
	; Change banks
	bsf 03h, 5
	; Set my inputs and outputs for port A and B
	movlw b'01100000'
	movwf 06h
	movlw b'00010000'
	movwf 05h

;	bcf 05h, 6
	bcf 06h, 7
	bcf 03h, 5
	bcf 06h, 7
	bcf 05h, 6
	;clrf gen

goto main

main:
	
	call checkKeypad	
    ;In check keypad I have checkPassword1 and checkPassword2 which are used
	;For checking the passwords it's 2 sub routines since there are 2 different passwords
	
	goto main

checkKeypad:

	; Check highs and lows for my rows and columns to see which buttons have been pressed
	; Pressing the buttons sets pins on the ports, how it works is this way - If a button is pressed a pin is set and the value for the button is moved to 
	; my variables which are for storing the passwords and validations, then the code proceeds to check for other pins as well and do the same
	; In every button check I also check the password, I interrupt the code to "checkPassword" (1 & 2) so to say if password is set code no longer checks buttons
	; but sets the relevant LED and performs right action - On password 1 I (increment2nd) - increment the 2nd Seven segment
	; and set the 1st Led by calling setLed
	; On password 2 I (decrement2nd) - decrement the 2nd Seven segment and set the 2nd led by calling setLed2

    ;HOW DO I CHECK FOR PASSWORD?  I move the digits I am looking for to the working register and I subtract the value of working register from the file (gen files)
    ; if the status register is set meaning the values are equal I check for the 2nd value of the password and so on..
    ; How do I make sure the sequence is maintained - On other wrong button presses, I clear the files and only set the values on right button presses
    ; On leds getting set I clear the files for password - meaning I have to start afresh setting the files for password (subroutines clearAll2 and clearAll)  
    
    
	Row1Check

		call Delay2

		bsf 06h, 0
		bcf 06h, 1
		bcf 06h, 2
		bcf 06h, 3

	Row1Col1
		
		btfss 05h, 4
		goto Row1Col2
		clrf gen2
		clrf gen3
		movlw .1
		movwf gen1
		movwf gen11
		clrf gen33		

		movwf 05h
		call checkPassword1
		call checkPassword2
		;movlw .1
			
		call DelayB
		call DelayB
		
	Row1Col2

		btfss 06h, 5
		goto Row1Col3
		
		clrf gen3
		movlw .2
		movwf gen2
		movwf gen22
		clrf gen11
		clrf gen33

		movwf 05h
		call checkPassword1
		call checkPassword2

		call DelayB
		call DelayB

	Row1Col3
	
		btfss 06h, 6
		goto Row2Check
		movlw .3
		movwf 05h
		call checkPassword1
		call checkPassword2		

		call DelayB
		call DelayB

	Row1Col4

		btfss 06h, 7
		goto Row2Check
		movlw .13
		movwf 05h

		call DelayB
		call DelayB
	

	Row2Check
		call Delay2
		
		bcf 06h, 0
		bsf 06h, 1
		bcf 06h, 2
		bcf 06h, 3
		
	Row2Col1
		
		btfss 05h, 4
		goto Row2Col2

		movlw .4
		movwf gen3
		movwf gen33
		movwf 05h
		call checkPassword1		
		call checkPassword2

		call DelayB
		call DelayB
		
	Row2Col2

		btfss 06h, 5
		goto Row2Col3
		movlw .5
		movwf 05h

		call DelayB
		call DelayB

	Row2Col3
	
		btfss 06h, 6
		goto Row3Check
		movlw .6
		movwf 05h

		call DelayB
		call DelayB

	Row2Col4

		btfss 06h, 7
		goto Row3Check
		movlw .14
		movwf 05h

		call DelayB
		call DelayB

	Row3Check
		call Delay2
	
		bcf 06h, 0
		bcf 06h, 1
		bsf 06h, 2
		bcf 06h, 3

	Row3Col1
		
		btfss 05h, 4
		goto Row3Col2
		movlw .7
		movwf 05h
	
		call DelayB
		call DelayB
		
	Row3Col2

		btfss 06h, 5
		goto Row3Col3
		movlw .8
		movwf 05h

		call DelayB
		call DelayB

	Row3Col3
	
		btfss 06h, 6
		goto Row4Check
		movlw .9
		movwf 05h

		call DelayB
		call DelayB

Row4Check
		call Delay2
		
		bcf 06h, 0
		bcf 06h, 1
		bcf 06h, 2
		bsf 06h, 3
	
	Row4Col1
		
		btfss 05h, 4
		goto Row4Col2
		movlw .11
		movwf 05h
	
		call DelayB
		call DelayB
		
	Row4Col2

		btfss 06h, 5
		goto Row4Col3
		movlw .10
		movwf 05h

		call DelayB
		call DelayB

	Row4Col3
	
		btfss 06h, 6
		goto Row1Check
		movlw .12
		movwf gen3
		movwf gen33
		movwf 05h
		
		call checkPassword1
		call checkPassword2	

		call DelayB
		call DelayB

return

Password

	;incf gen, 1
	bsf 06h, 7
	
return

DelayB
	movlw .255
	movwf x
loopx
	movlw .129
	movwf y
loopy
	decfsz y, 1
	goto loopy
	decfsz x, 1
	goto loopx
return

Delay2
	
	movlw .255
	movwf x2
loopx2
	movlw .37
	movwf y2
loopy2
	decfsz y2, 1
	goto loopy2
	decfsz x2, 1
	goto loopx2
return

checkPassword1
	
	movlw .1
	subwf gen1, 0
	;0 Bit test

	btfsc 03h,2
	call check2
	btfsc 03h,2
	call check4
	btfsc 03h,2
	call setLED

    return


checkPassword2
	
	movlw .2
	subwf gen22, 0
	;0 Bit test

	btfsc 03h,2
	call check11
	btfsc 03h,2
	call check44
	btfsc 03h,2
	call setLED2

    return

increment2nd
	
	call clearToTen
	movlw .1
	movwf 05h
	call DelayB
	call DelayB
	
	movlw .2
	movwf 05h
	call DelayB
	call DelayB

	movlw .3
	movwf 05h
	call DelayB
	call DelayB

	movlw .4
	movwf 05h
	call DelayB
	call DelayB

	movlw .5
	movwf 05h
	call DelayB
	call DelayB

	movlw .6
	movwf 05h
	call DelayB
	call DelayB

	movlw .7
	movwf 05h
	call DelayB
	call DelayB

	movlw .8
	movwf 05h
	call DelayB
	call DelayB

	movlw .9
	movwf 05h
	call DelayB
	call DelayB

	movlw .0
	movwf 05h
	call setToTen
	call DelayB
	call DelayB
	
	movlw .1
	movwf 05h
	call DelayB
	call DelayB

	movlw .2
	movwf 05h
	call DelayB
	call DelayB

	movlw .3
	movwf 05h
	call DelayB
	call DelayB

	movlw .4
	movwf 05h
	call DelayB
	call DelayB

	movlw .5
	movwf 05h
	call DelayB
	call DelayB

return 

decrement2nd
	
	call setToTen
	movlw b'01000101'
	movwf 05h
	call DelayB
	call DelayB
	
	movlw b'01000100'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000011'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000010'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000001'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000000'
	movwf 05h
	call DelayB
	call DelayB
	
	call clearToTen
	movlw b'01001001'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01001000'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000111'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000110'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000101'
	movwf 05h
	call DelayB
	call DelayB
	
	movlw b'01000100'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000011'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000010'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000001'
	movwf 05h
	call DelayB
	call DelayB

	movlw b'01000000'
	movwf 05h
	call DelayB
	call DelayB

return 


setToTen
	bsf 06h, 4
return

clearToTen
	bcf 06h, 4
return


check11
	movlw .1
	subwf gen11, 0
	return 

check22
	movlw .2
	subwf gen22, 0
	return 

check44
	movlw .12
	subwf gen33, 0
	return 


check2
	movlw .2
	subwf gen2, 0
	return 

check4
	movlw .12
	subwf gen3, 0
	return 
clearAll
	clrf gen1
	clrf gen2
	clrf gen3
return

clearAll2
	clrf gen11
	clrf gen22
	clrf gen33
return

setLED
	bcf 05h, 6
	bsf 06h, 7
	call increment2nd
	call clearAll
	return

setLED2
	bcf 06h, 7
	bsf 05h, 6
	call decrement2nd
	call clearAll2
	return


end