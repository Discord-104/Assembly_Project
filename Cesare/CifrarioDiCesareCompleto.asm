; Cifrario di Cesare
title
.model small
.stack 100h
.data
;dichiarazione variabili
 
 cifrario db 71 DUP(?)
 alfabeto db "!",22h,20h,"'",2Ch,".","0","1","2","3","4","5","6","7","8","9",":",";","?","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"
 stringa db 100 DUP("$")
 scelta db ?                    ;63h --> Cifratura | 64h --> Decifratura
 lenAlfabeto db 71 
 chiave db ?
 
 msg1 db 10,13,"Si vuole cifrare (c) o decifrare (d) una stringa? ", "$"
 msg2 db 10,13,"Inserire la chiave: ", "$"
 msg3 db 10,13,"Inserire una stringa: ", "$"
 msg4C db 10,13,"Stringa Cifrata: ", "$"
 msg4D db 10,13,"Stringa Decifrata: ", "$"
 
.code
.startup

mov ax,@data
mov ds,ax

;inserire qua il codice

 ;Chiedo all'utente se vuole cifrare (c) o decifrare (d) una stringa
  CALL Richiesta 
  MOV scelta,al
  
 ;Chiedo all'utente la chiave di cifratura (di quanti indici devo shiftare l'alfabeto) controllando che 1 < chiave < lunghezza Alfabeto
  CALL InputChiave
  MOV chiave,al 
 
 ;Creo il cifrario shiftanto l'alfabeto di n posizioni (n = chiave)
  CALL CreaCifrario  
 
 ;Chiedo all'utende di inserire una stringa che contenga solo caratteri presenti nell'alfabeto 
  CALL InputStringa
  
  CMP scelta,"d"
  JE scelta_d:
 ;Cifro la stringa 
  CALL Cifratura
  
  LEA dx,msg4C
  MOV ah,09h
  INT 21h
  JMP stampa
  
 scelta_d: 
 ;Decifro la stringa 
  CALL Decifratura
  LEA dx,msg4D
  MOV ah,09h
  INT 21h
 
 stampa:
  LEA dx,stringa
  MOV ah,09h
  INT 21h
   
fine:
mov ah,4ch
int 21h



;PARAMETRI: -
;RETURN: scelta tra cifratura (c) e decifratura (d) in al
;MODIFICATI: dx
PROC Richiesta    
;Procedura che ricava se l'utente vuole cifrare o decifrare una stringa

PUSH dx
  
 inizio_richiesta:
  LEA dx,msg1
  MOV ah,09h
  INT 21h
  
  MOV ah,01h
  INT 21h
 
 ;Controllo se l'utente ha inserito "c" (ovvero cifratura) 
  CMP al,"c"
  JE fine_richiesta             ;se si termino la procedura
 
 ;Controllo se l'utente ha inserito "d" (ovvero decifratura) 
  CMP al,"d"
  JNE inizio_richiesta          ;se no, l'utente non ha inserito ne "c" ne "d", quindi richiedo un input 

 fine_richiesta:

POP dx
     
RET
ENDP    



;PARAMETRI: -
;RETURN: Chiave (al)
;MODIFICATI: cx,dx
PROC InputChiave
;Procedura che ricava la chiave di cifratura (considerando che 1 < chiave < lunghezza Alfabeto)

PUSH cx
PUSH dx
 
 inizio_input_chiave: 
  MOV dl,0 
  MOV cx,2                      ;contatore per il loop
  
  LEA dx,msg2
  MOV ah,09h
  INT 21h
  
 input_chiave: 
  MOV ah,01h
  INT 21h
  SUB al,30h 
  
;scambio il contenuto di al (numero appena inserito) con il contenuto di dl (numero vecchio da moltiplicare * 10)
  MOV ah,0
  MOV dh,0
  PUSH ax                   
  PUSH dx
  POP ax
  POP dx
  
  MOV dh,10
  MUL dh
  ADD al,dl
  LOOP input_chiave 
 
 ;Controllo se Chiave > 1 
  CMP al,1
  JBE inizio_input_chiave
 
 ;Controllo se Chiave < lunghezza Alfabeto 
  CMP al,lenAlfabeto
  JGE inizio_input_chiave

POP dx
POP cx
    
RET
ENDP 



;PARAMETRI: alfabeto, chiave, lenAlfabeto 
;RETURN: cifrario 
;MODIFICATI: ax,cx,dx   
PROC CreaCifrario 
;Procedura che crea il cifrario shiftando (in avanti) l'alfabeto di n posizioni (n = chiave)

PUSH ax
PUSH cx
PUSH dx
   
  MOV ch,0
  MOV cl,lenAlfabeto            ;contatore per il loop
 
  LEA si,alfabeto               ;si --> indice alfabeto
  LEA di,cifrario               ;di --> indice cifrario
  MOV ah,0
  MOV al,chiave
  ADD di,ax                     ;aggiungo all'indirizzo del cifrario la chiave 
  SUB lenAlfabeto,1 
  MOV dh,0
  MOV dl,lenAlfabeto 
  
 inizio_cifrario_cifratura:
  
  MOV ah,[si]                   ;metto il contenuto del'indice i dell'alfabeto nell'indice i+chiave del cifrario
  MOV [di],ah
 
  CMP di,dx                     ;controllo se ho raggiunto il limite del cifrario
  JE primo_indice_cifrario      ;se si, porto si al primo indice
  
  INC di                        ;incremento gli indici
  INC si
  JMP fine_loop
  
 primo_indice_cifrario:
  LEA di,cifrario
  INC si
 
 fine_loop:  
  LOOP inizio_cifrario_cifratura

POP dx
POP cx
POP ax

RET    
ENDP 
     
     

;PARAMETRI: -
;RETURN; stringa
;MODIFICATI: ax,cx,dx
PROC InputStringa  
;Procedura che chiede all'utente l'inserimento di una stringa, controllando che i caratteri inseriti siano presenti nell'alfabeto

PUSH ax
PUSH cx
PUSH dx
    
  LEA dx,msg3
  MOV ah,09h
  INT 21h
  LEA si,stringa                ;carico in si l'indirizzo della prima cella di memoria della stringa
  MOV bx,si
  ADD bx,100
 
 inizio_input_stringa: 
  MOV ah,01h
  INT 21h 
  
 ;Controllo se l'utente ha premuto invio (carattere terminatore dell'inserimento) 
  CMP al,0Dh
  JE fine_input_stringa
  
  MOV ch,0
  MOV cl,lenAlfabeto            ;contatore per il loop
  LEA di,alfabeto               ;carico in si l'indirizzo della prima cella di memoria dell'alfabeto
  
 controllo_caratteri:
  
  CMP [di],al                   ;controllo se il carattere inserito e' presente nell'alfabeto
  JE carattere_corretto         ;se si, lo metto nella stringa ...
  INC di
  
  LOOP controllo_caratteri
  
  JMP inizio_input_stringa      ;... altrimenti chiedo all'utente di reinserire un carattere
  
 carattere_corretto: 
  MOV [si],al
  INC si
  CMP si,bx                     ;Controllo se ho raggiunto il limite della stringa
  JE fine_input_stringa
  JMP inizio_input_stringa 

 fine_input_stringa:

POP dx
POP cx
POP ax   

RET
ENDP 



;PARAMETRI: alfabeto, cifrario
;RETURN: stringa cifrata (stringa)
;MODIFICATI: ax,cx,dx
PROC Cifratura 
                                                  
PUSH ax
PUSH cx
PUSH dx
      
  LEA di,stringa
    
 inizio_cifratura:
  MOV dx,0  
  LEA si,alfabeto               ;Carico in si il primo indirizzo dell'alfabeto
  
  MOV ch,0
  MOV cl,lenAlfabeto            ;Contatore per il loop
  MOV al,[di]                   ;Sposto in al il contenuto dell'indice di della stringa, 
ricerca_carattere: 
  
  CMP [si],al                   ;cerco dove si trova la lettere corrispondente nell'alfabeto
  JE carattere_uguale
  
  INC si
  INC dx                        ;Contatore dei cicli
  LOOP ricerca_carattere
 
 carattere_uguale:
  LEA si,cifrario
  ADD si,dx                     ;Sommo al primo indirizzo del cifrario i cicli fatti (per raggiungere l'indice corrispondente all'alfabeto)
  MOV dl,[si]
  MOV [di],dl                   ;Metto nella stringa il simbolo corrispondente
  INC di
  CMP [di],"$"                  ;Controllo se ho raggiunto la fine della stringa
  JNE inizio_cifratura
 
POP dx
POP cx
POP ax 
      
RET
ENDP



;PARAMETRI: alfabeto, cifrario
;RETURN: stringa decifrata (stringa)
;MODIFICATI: ax,cx,dx
PROC Decifratura 

PUSH ax
PUSH cx
PUSH dx
      
  LEA di,stringa
    
 inizio_decifratura:
  MOV dx,0  
  LEA si,cifrario
  
  MOV ch,0
  MOV cl,lenAlfabeto
  MOV al,[di]
 ricerca_carattere_decifratura: 
  
  CMP [si],al
  JE carattere_uguale_decifratura
  
  INC si
  INC dx
  LOOP ricerca_carattere_decifratura
 
 carattere_uguale_decifratura:
  LEA si,alfabeto
  ADD si,dx
  MOV dl,[si]
  MOV [di],dl 
  INC di
  CMP [di],"$"
  JNE inizio_decifratura
 
POP dx
POP cx
POP ax 
      
RET
ENDP

end
