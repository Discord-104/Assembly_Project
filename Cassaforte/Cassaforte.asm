; modello ASM
title
.model small
.stack 100h
.data
;dichiarazione variabili

str1 db "inserisci il codice ( numeri ) : $"
str2 db "codice debole!",10,13,"$" 
str3 db "reinserisci il codice $"  
str4 db "Cassaforte aperta!$"  
str5 db "Autodistruzione tra 3... 2... 1...$" 
str6 db 10,13,"$"


codice db 10 dup(?)
codice2 db 10 dup(?)
maxEl db 10


.code
.startup

mov ax,@data
mov ds,ax

;etichetta per richiedere il valore se non corretto ( 4 check ) 
jmp finecodDebole   ; ovviamente la prima volta salto la stampa 
codDebole:
call aCapo
mov ah,09h   
lea dx,str2
int 21h

finecodDebole:
mov ah,09h   
lea dx,str1
int 21h
         


    
; inserisco il codice          
mov cx,0
mov cl,maxEl 
lea di,codice
call inserisciCodice



; eseguo i check -> se uno ritorna in al = 0, vuol dire che non   passato il check
; ritorno in alto

lea di,codice  
mov cx,0
mov cl,maxEl   
call check1
cmp al,0
je codDebole 
 
call check2
cmp al,0
je codDebole 

call check3
cmp al,0
je codDebole

call check4
cmp al,0
je codDebole 


call aCapo


;rifaccio inserire il codice in un altro vettore
mov ah,09h   
lea dx,str3
int 21h
mov cx,0
mov cl,maxEl  
lea di,codice2
call inserisciCodice

 
; controllo che i 2 codici sono identici
call aCapo
lea di,codice
lea si,codice2 
mov cx,0
mov cl,maxEl
call checkUguali
cmp al,0
je distruzione



; stampo il messaggio corretto in base al return del check
aperta:
mov ah,09h   
lea dx,str4
int 21h

jmp fine
distruzione:
mov ah,09h   
lea dx,str5
int 21h




fine:
mov ah,4ch
int 21h  
 
;---stampa un vai a capo
;Parametri: -
;Ritorno: -
;Modificati: -
proc aCapo 
    push ax
    push dx
    
    mov ah,09h   
    lea dx,str6
    int 21h

    pop dx
    pop ax
ret
endp 

;---permette di fare un inserimento nel vettore passato
;Parametri
;di -> inizio vettore
;cx -> num elementi 

;Ritorno: -
;Modificati: -     
proc inserisciCodice 
    push cx
    push ax
    push di 
    
   inizio_inserimento:
   mov ah,01
   int 21h
   mov [di],al
   inc di
   
   loop inizio_inserimento 
   
   pop di
   pop ax
   pop cx
ret    
endp 


;---primo controllo  (codice composto da 10 cifre tra 0 e 9)
;Parametri
;di ->inizio vettore      
;cx -> num elementi

;Ritorno
;al -> 0 ERR | 1 OK  

;Modificati: -
proc check1
   push cx
   push di
   
   mov al,1  
   inizioCheck1:
   
   cmp [di],30h
   jl errCheck1
   cmp [di],39h
   jg errCheck1 
   
   loop inizioCheck1   
   
   jmp fineCheck1 
   errCheck1:
   mov al,0 
   
   fineCheck1:
   
   
   pop di
   pop cx
   
ret   
endp      


;---secondo controllo  (numeri devono essere alternati pari e dispari)
;Parametri
;di ->inizio vettore      
;cx -> num elementi

;Ritorno
;al -> 0 ERR | 1 OK  

;Modificati: -
proc check2
   push cx
   push di
   push bx 
  
   mov bl,2
   mov bh,33    ; qualsiasi numero diverso da 1 e 0
                ; la prima volta controlla che   diverso da questo e va avanti
                ; sostituendolo
    
   inizioCheck2:
      mov al,[di]
      mov ah,0  
      div bl    ; ris al | rest ah
      cmp ah,bh
      je errCheck2
      mov bh,ah ; mi salvo il resto
             ; il resto della prossima divisione deve essere
             ; diverso da questo    
      inc di
   
   loop inizioCheck2 
   
     
   
   jmp okCheck2 
   errCheck2:
   mov al,0 
   jmp fineCheck2
   okCheck2:
   mov al,1
   fineCheck2:
    
   pop bx
   pop di
   pop cx 
   
   
ret   
endp    








;---terzo controllo  (il 9 non potr  essere dopo il 4)
;Parametri
;di ->inizio vettore      
;cx -> num elementi
 

;Ritorno
;al -> 0 ERR | 1 OK  

;Modificati: -
proc check3
   push cx
   push di
   push bx 
  
   
   dec cx ; non arrivo in fondo
   
   inizioCheck3:
   
      cmp [di],'4'
      jne quattroNonTrovato
      
      mov si,di
      inc si
      
      cmp [si],'9'
      je errCheck3
     
     
      
      quattroNonTrovato:   
      inc di
   loop inizioCheck3 
   
     
   
   jmp okCheck3 
   errCheck3:
   mov al,0 
   jmp fineCheck3
   okCheck3:
   mov al,1
   fineCheck3:
   
   pop bx
   pop di
   pop cx
ret   
endp    




;---quarto controllo  (non pu  iniziare con 0)
;Parametri
;di ->inizio vettore      
;cx -> num elementi

;Ritorno
;al -> 0 ERR | 1 OK  

;Modificati: -
proc check4
   push cx
   push di
   push bx 
  
   
   cmp [di],'0'
   je errCheck4
   jmp okCheck4
     
   
   jmp fineCheck4 
   errCheck4:
   mov al,0 
   jmp fineCheck4
   okCheck4:
   mov al,1
   fineCheck4:
   
   pop bx
   pop di
   pop cx
ret   
endp  



;---controlla se 2 vettori di dimensioni uguali sono identici
;Parametri
;di ->inizio vettore
;si ->inizio vettore2      
;cx -> num elementi  

;Ritorno
;al -> 0=diversi | 1=uguali  

;Modificati: -
proc checkUguali
   push cx
   push di
   push bx 
  
   
   inizioCheckUguali:
   
      mov bl,[di]
      cmp bl,[si]
      jne errCheckUguali
      
     
     
      inc di
      inc si
   loop inizioCheckUguali 
   
   
   jmp okCheckUguali 
   errCheckUguali:
   mov al,0 
   jmp fineCheckUguali
   okCheckUguali:
   mov al,1
   fineCheckUguali:
   
   
   
   pop bx
   pop di
   pop cx
ret   
endp 

end