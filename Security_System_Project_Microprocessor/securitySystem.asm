INCLUDE 'EMU8086.INC'
.MODEL SMALL
.STACK 100 H
.DATA                             
    DATA2 DB  5,?,5 DUP (?)       
    DATA3 DB 'ENTER YOUR ID: ','$'        
    DATA1 DB '0123456789ABCDEFabcdef?'
    DATA4 DB 'ERROR:THE ID NUMBER MUST BE 4-BIT HEX','$'
    DATA5 DB ''WRONG ENTRY'YOUR ID MUST CONTAIN DATA FROM 0-->9 or A-->F','$'   
    DATA6 DW 0AAAAH,0BBBBH,0CCCCH,0DDDDH,0EEEEH,0FFFFH,1111H,2222H,3333H,4444H
    DATA7 DW 5555H,6666H,7777H,8888H,9999H,0100H,0200H,0300H,0400H,5667H
    DATA8 DW 1111H,2222H,3333H,4444H,5555H,6666H,000AH,000BH,000CH,000DH
    DATA9 DW 000FH,000EH,0001H,0002H,0003H,0A00H,0B00H,0C00H,0D00H,0A0AH 
    DATAA DB 'ERROR: YOUR ID IS WRONG, PLEASE  TRY AGAIN!!','$' 
    DATAB DB 'ENTER YOUR PASSWORD: ','$'   
    DATAC DB 5,?,5 DUP (?)  
    DATAP DB 5,?,5 DUP (?)        
    DATAD DB '******WELCOME YOU SECURITY CHECK IS SUCCSSFULLY******','$' 
    DATAE DB 'ERROR : WRONG PASSWORD,TRY AGAIN','$'     
    DATAF DB 00H
    DATAG DB '---------------------------------------------------------------','$'
    DATAH DB 'WHAT DO YOU WANT?','$'
    DATAI DB '(1) ENTER YOUR ID AND PASSWORD','$'
    DATAJ DB '(2) CHANGE YOUR PASSWORD','$'
    DATAU DB 'YOUR CHOICE IS (1/2) ','$'
    DATAT DB 'ERROR:WRONG CHOICE','$'       
    DATAK DB 2,?,2 DUP (?) 
    DATAR DB 'ENTER YOUR ID: ','$'
    DATAQ DB 'ENTER OLD PASSWORD: ','$'
    DATAY DB 'ENTER NEW PASSWORD: ','$'
    DATAO DB 'CONFIRM YOUR PASSWORD: ','$'
    DATAV DB 'YOUR PASSWORD IS SUCCESFULLY CHANGED','$' 
    DATAW DB 'ERROR : WRONG ENTRY!! PLEASE,RE-ENTER NEW PASSWORD: ','$'
    DATAZ DW ? 

.CODE
  MAIN PROC       
                 MOV AX,@DATA           
                 MOV DS,AX 
                              
                 MOV  ES,AX              
                 MOV  DH,00H             
                 CALL CLEAR              
                 MOV  BP,OFFSET DATAF
                                                    
                 START:
                           
                 CALL SETCURSOR         
                 CALL ENTRY             
                 CALL GETCHOICE         
                 CALL CHECKNO            
                 CALL SETCURSOR          
                 CALL ENTERORCHANGE     
                 CALL HANDLE             
                 CALL CONVERT
                                            
                 ID:
                               
                 CALL WELCOME           
                 CALL GET_IN            
                 CALL NO.LET             
                 CALL CHECK             
                 MOV  SI,OFFSET DATA2+2  
                 CALL PUTIDINAX          
                 CALL CHECKID            
                 CALL SETCURSOR         
                 CALL GETPASS            
                 MOV  SI,OFFSET DATAC+2  
                 CALL PUTIDINAX           
                 CALL CHECKPASS          
                 CALL SETCURSOR          
                 CALL ENTER
                                        
                 NO_EROR: 
                         
                 CALL SETCURSOR          
                 CALL NOEROR
                                         
                 WR_ENT:
                           
                 CALL SETCURSOR         
                 CALL WRONGENTRY
                                         
                 WRONGID:
                          
                 CALL SETCURSOR
                 CALL WRONG_ID 
                 
                 WRONGPASS:
                        
                 CALL SETCURSOR
                 CALL WRONG_PW  
                 
                 OPERA:
                            
                 MOV  AH,4CH
                 INT 21H
 MAIN ENDP        
     
     
;*******************************     

CLEAR  PROC   
                 MOV AX,0600H
                 MOV BH,07
                 MOV CX,0000
                 MOV DH,24
                 MOV DL,79
                 INT 10H
                 RET
CLEAR ENDP
                
;*******************************      
                
ENTRY PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAH
                 INT 21H
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAI
                 INT 21H
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAJ
                 INT 21H  
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAU
                 INT 21H
                 RET
ENTRY ENDP 


;*******************************  

GETCHOICE PROC
                 MOV AH,0AH
                 MOV DX,OFFSET DATAK
                 INT 21H
                 RET
GETCHOICE ENDP 


;*******************************  

CHECKNO PROC
                 LEA BX,DATAK+2
                 CMP [BX],31H
                 JZ  RETURN2
                 CMP [BX],32H
                 JZ  RETURN2
                 CALL ERROR 
                 
                 RETURN2:
                     
                 CALL 5AT
                 RET
CHECKNO ENDP  


;*******************************  

ERROR PROC
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAT
                 INT 21H
                 CALL 5AT
                 JMP START
                 RET
ERROR ENDP     


;*******************************  

SETCURSOR PROC 
                 MOV AH,02H
                 MOV BH,00
                 MOV DL,00
                 MOV DH,DS:[BP]   
                 INT 10H
                 ADD DS:[BP],1
                 RET
SETCURSOR ENDP  

;*******************************  

WELCOME PROC     
                 MOV AH,09H
                 LEA DX,DATA3
                 INT 21H
                 RET
WELCOME ENDP

;*******************************  

GET_IN PROC
                 MOV AH,0AH
                 MOV DX,OFFSET DATA2
                 INT 21H 
                 RET
GET_IN ENDP 


;*******************************  


NO.LET  PROC
                 LEA SI,DATA2+1
                 CMP [SI],04H
                 JNZ NO_EROR 
                 RET       
NO.LET ENDP  

;*******************************  

        
CHECK  PROC
                 MOV AH,4
                 LEA SI,DATA2+2
                 
                 AGAIN: 
                           
                 LEA DI,DATA1
                 MOV CX,23  
                 MOV AL,[SI]
                 REPNZ SCASB
                 CMP CX,00
                 JZ  END
                 INC SI
                 DEC AH
                 JNZ AGAIN 
                 RET 
                 
                 END: 
                            
                 JMP WR_ENT
       
CHECK ENDP 

;*******************************  
 
 
NOEROR PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATA4
                 INT 21H  
                 CALL 5AT
                 JMP START
                 RET
NOEROR ENDP  


;*******************************  
    
WRONGENTRY PROC    
                 MOV AH,09H
                 MOV DX,OFFSET DATA5
                 INT 21H 
                 CALL 5AT
                 JMP START
                 RET
WRONGENTRY ENDP


;*******************************  


PUTIDINAX PROC                  
                 MOV CX,04H 
                 
                 AGAIN2:
                 
                 CMP [SI],39H
                 JZ  ZERO
                 JB  ZERO         
                 JA  OVER  
                   
                 ZERO: 
                 
                 SUB [SI],30H
                 JMP STAR 
                         
                 OVER:
                             
                 CMP [SI],70
                 JZ  CAPITAL
                 JB  CAPITAL
                 JA  SMALL  
                 
                 CAPITAL:
                          
                 SUB [SI],55
                 JMP STAR 
                 
                 SMALL:
                            
                 SUB [SI],87
                 JMP STAR
                        
                 STAR:
                             
                 INC SI 
                 DEC CX   
                 JNZ AGAIN2       
                 SUB SI,4
                 MOV AH,[SI]
                 MOV AL,[SI+2]
                 MOV BH,[SI+1]
                 MOV BL,[SI+3]
                 SHL AX,4
                 OR  AX,BX  
                 RET
PUTIDINAX ENDP
         
;*******************************  

CHECKID PROC
                 MOV CX,21           
                 LEA DI,DATA6        
                 CLD                 
                 REPNE SCASW        
                 CMP CX,0000H       
                 JZ WRONGID         
                 RET          
CHECKID ENDP


;*******************************  

WRONG_ID PROC 
                 MOV AH,09H
                 MOV DX,OFFSET DATAA
                 INT 21H     
                 CALL 5AT
                 JMP START
                 RET
WRONG_ID ENDP


;*******************************  


GETPASS PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAB
                 INT 21H   
                 MOV AH,0AH
                 MOV DX,OFFSET DATAC
                 INT 21H
                 RET             
GETPASS ENDP


;*******************************  


CHECKPASS PROC   
                 MOV BX,AX
                 ADD DI,38           
                 CMP BX,[DI]       
                 JNZ WRONGPASS 
                 RET
CHECKPASS ENDP      


;*******************************  


ENTER PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAD
                 INT 21H 
                 CALL 5AT 
                 JMP START
                 RET
ENTER ENDP

;*******************************  

          
WRONG_PW PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAE
                 INT 21H   
                 CALL 5AT
                 JMP START
WRONG_PW ENDP     

;*******************************  

 
5AT PROC  
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAG
                 INT 21H
                 RET
5AT ENDP


;*******************************  

       
ENTERORCHANGE PROC
                 LEA BX,DATAK+2
                 CMP [BX],31H
                 JZ  ID
                 RET
ENTERORCHANGE ENDP 


;*******************************  
    
HANDLE PROC
                 MOV AH,09H
                 MOV DX,OFFSET DATAR
                 INT 21H
                 CALL GET_IN 
                 CALL NO.LET
                 CALL CHECK               
                 MOV  SI,OFFSET DATA2+2
                 CALL PUTIDINAX          
                 CALL CHECKID
                 MOV BX,OFFSET DATAZ   
                 LEA DX,[DI]       
                 MOV [BX],DX
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAQ
                 INT 21H
                 MOV AH,0AH
                 MOV DX,OFFSET DATAC
                 INT 21H        
                 MOV  SI,OFFSET DATAC+2
                 CALL PUTIDINAX          
                 CALL CHECKPASS
                 CALL SETCURSOR 
                 MOV AH,09H
                 MOV DX,OFFSET DATAY
                 INT 21H  
                 
                 AGAIN3: 
                 
                 MOV AH,0AH
                 MOV DX,OFFSET DATAC
                 INT 21H  
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAO
                 INT 21H
                 MOV AH,0AH
                 MOV DX,OFFSET DATAP
                 INT 21H 
                 CALL CHECKCONFIRM
                 RET
HANDLE ENDP


;*******************************  
 
CHECKCONFIRM PROC  
                 CLD
                 MOV SI,OFFSET DATAC+2
                 MOV DI,OFFSET DATAP+2
                 MOV CX,05H
                 REPE CMPSB 
                 CMP CX,0000H
                 JNZ  PUTITAGAIN
                 RET  
                 
                 PUTITAGAIN:      

                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAW
                 INT 21H
                 JMP AGAIN3 
CHECKCONFIRM ENDP


;*******************************  

 
CONVERT PROC
                 MOV SI,OFFSET DATAP+2
                 CALL PUTIDINAX
                 MOV BX,OFFSET DATAZ
                 ADD [BX],38
                 MOV DI,[BX]          
                 MOV [DI],AX
                 CALL SETCURSOR
                 MOV AH,09H
                 MOV DX,OFFSET DATAV
                 INT 21H 
                 CALL 5AT
                 JMP START   
CONVERT ENDP          


END MAIN