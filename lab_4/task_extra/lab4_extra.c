#include <iostream>
#include <fstream>
#include <stdio.h>
#include <windows.h>
#include <tchar.h>
using namespace std;
char input[81];
char output[162];
int sum = 0;
int main()
{
    system("chcp 1251 > nul");
    setlocale(LC_CTYPE, "rus");
    cin.getline(input, 81);

    __asm {
        mov esi, offset input
        mov edi, offset output

        read :
        lodsb
            cmp al, '\0'
            je exit_prog

            cmp al, 'ё'
            je yo

            cmp al, 'Ё'
            je yo

            cmp al, 'А'
            jb write

            cmp al, 'а'
            jb check_yo
            sub al, 32

            check_yo:
        cmp al, 'Ж'
            jb process
            add al, 1

            process :
            sub al, 'А'
            add al, 1
            mov bl, al
            and bl, 15; lower digit
            and al, 240; higher digit
            shr al, 4
            mov dl, 0

            writedigit :
        add al, '0'
            cmp al, '9'
            jg hexletter
            cmp dl, 1
            je write
            stosb
            jmp nextdigit

            hexletter :
        add al, 7
            cmp dl, 1
            je write
            stosb
            jmp nextdigit

            nextdigit :
        mov dl, 1
            mov al, bl
            jmp writedigit

            yo :
        mov ax, 3730h
            stosw
            jmp read

            write :
        stosb
            jmp read

            exit_prog :
        stosb

            mov cl,0
            mov esi, offset output

            dop_task:

            lodsb
            cmp al,'\0'
            je end_dop_task

            cmp al,'0'
            jb skip_iter

            cmp al,'9'
            ja skip_iter

            sub al,'0'
            add cl,al

            skip_iter:

            jmp dop_task

            end_dop_task:

            mov edi, offset sum
            mov [edi], cl



    };
    cout << output;
    cout << "\n";
    cout << sum;
    return 0;
}
