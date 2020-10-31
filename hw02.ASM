format PE console

entry Start

include 'win32a.inc'

section '.data' data readable writable

        enterArraySizeStr db 'enter array size:',10,0
        enterArrayStr db 'enter array elements separated by space:',10,0
        arrayBStr db 'array B:',10,0
        numberStr db '%d',0
        spaceStr db ' ',0
        newLineStr db 10,0
        _heap dd ?
        _arrA dd ?
        _arrB dd ?
        number dd ?
        i dd ?
        j dd ?
        lastPositive dd ?
        sizeA dd ?
        sizeB dd ?
        sizeInBytesA dd ?
        sizeInBytesB dd ?
        sizeOfInt dd 4

section '.code' code readable executable

        Start:
                push enterArraySizeStr
                call [printf]
                push sizeA
                push numberStr
                call [scanf]

                cmp [sizeA], 0
                jle Start

                mov eax, [sizeA]
                mul [sizeOfInt]
                mov [sizeInBytesA], eax

        ; creating heap
        CreateHeap:
                push 0
                push 0
                push 0
                call [HeapCreate]
                mov [_heap], eax

        ; allocating space for array A
        AllocArrayA:
                push [sizeInBytesA]
                push 0
                push [_heap]
                call [HeapAlloc]
                mov [_arrA], eax

        ; reading array A
        ReadArrayA:
                push enterArrayStr
                call [printf]

                mov [i], 0
                ReadArrayLoop:
                        mov eax, [i]
                        cmp eax, [sizeA]
                        jge FindLastPositive

                        push number
                        push numberStr
                        call [scanf]

                        mov eax, [i]
                        mul [sizeOfInt]
                        add eax, [_arrA]
                        mov ebx, [number]
                        mov [eax], ebx

                        inc [i]
                jmp ReadArrayLoop

        ; finding the position of the last positive number in array A
        FindLastPositive:
                mov [lastPositive], -1

                mov [i], 0
                FindLastPositiveLoop:
                        mov eax, [i]
                        cmp eax, [sizeA]
                        jge CreateArrayB

                        mov eax, [i]
                        mul [sizeOfInt]
                        add eax, [_arrA]

                        mov ebx, [eax]
                        cmp ebx, 0
                        jle L1
                            mov ecx, [i]
                            mov [lastPositive], ecx
                        L1:

                        inc [i]
                jmp FindLastPositiveLoop

        ; creating array B of numbers going after the last positive number in array A
        CreateArrayB:
                inc [lastPositive]

                mov eax, [sizeA]
                sub eax, [lastPositive]
                mov [sizeB], eax
                mul [sizeOfInt]
                mov [sizeInBytesB], eax
                ; alloc array B
                push [sizeInBytesB]
                push 0
                push [_heap]
                call [HeapAlloc]
                mov [_arrB], eax

                mov eax, [lastPositive]
                mov [i], eax
                mov [j], 0
                CreateArrayBLoop:
                        mov eax, [i]
                        cmp eax, [sizeA]
                        jge PrintArrayB

                        mov eax, [i]
                        mul [sizeOfInt]
                        add eax, [_arrA]
                        mov ebx, [eax]
                        mov [number], ebx

                        mov eax, [j]
                        mul [sizeOfInt]
                        add eax, [_arrB]
                        mov ebx, [number]
                        mov [eax], ebx

                        inc [i]
                        inc [j]
                jmp CreateArrayBLoop

        ; printing array B
        PrintArrayB:
                push arrayBStr
                call [printf]

                mov [i], 0
                PrintArrayBLoop:
                        mov eax, [i]
                        cmp eax, [sizeB]
                        jge Finish

                        mov eax, [i]
                        mul [sizeOfInt]
                        add eax, [_arrB]
                        mov ebx, [eax]
                        mov [number], ebx

                        push [number]
                        push numberStr
                        call [printf]
                        push spaceStr
                        call [printf]

                        inc [i]
                jmp PrintArrayBLoop
;



        Finish:
                push newLineStr
                call [printf]
; heap free
;        push [_arrA]
;        push 0
;        push [_heap]
;        call [HeapFree]
;



                call [getch]
                push 0
                call [ExitProcess]


section '.idata' import data readable

        library kernel32, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel32,\
               ExitProcess, 'ExitProcess',\
               GetProcessHeap, 'GetProcessHeap',\
               HeapCreate, 'HeapCreate',\
               HeapAlloc, 'HeapAlloc',\
               HeapFree, 'HeapFree'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               getch, '_getch'