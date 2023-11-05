.686
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\masm32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\user32.lib

.data
file_name db "input.bmp", 0
output_file_name db "output.bmp", 0

fileHandle HANDLE 0
outputFileHandle HANDLE 0
byteCount dd 0
headerBuffer db 54 dup(0)
imageBuffer db 6480 dup(0)

.code
start:
    ; Abrir o arquivo de entrada
    invoke CreateFile, addr file_name, GENERIC_READ, 0, 0, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0
    mov fileHandle, eax
    cmp fileHandle, INVALID_HANDLE_VALUE
    je FileOpenError

    ; Abrir o arquivo de saída
    invoke CreateFile, addr output_file_name, GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0
    mov outputFileHandle, eax
    cmp outputFileHandle, INVALID_HANDLE_VALUE
    je FileCreationError

    ; Ler o cabeçalho da imagem
    invoke ReadFile, fileHandle, addr headerBuffer, 54, addr byteCount, 0
    invoke WriteFile, outputFileHandle, addr headerBuffer, 54, addr byteCount, 0

    ; Ler o restante da imagem e gravar no arquivo de saída
    invoke SetFilePointer, fileHandle, 54, NULL, FILE_BEGIN

    readLoop:
        invoke ReadFile, fileHandle, addr imageBuffer, 6480, addr byteCount, 0
        test eax, eax
        jz readLoop_concluid
        invoke WriteFile, outputFileHandle, addr imageBuffer, byteCount, addr byteCount, 0
        jmp readLoop

    readLoop_concluid:

    ; Fechar o arquivo de entrada
    invoke CloseHandle, fileHandle

    ; Fechar o arquivo de saída
    invoke CloseHandle, outputFileHandle

    ; Encerrar o programa
    invoke ExitProcess, 0

FileOpenError:
    ; Lidar com erro na abertura do arquivo de entrada
    jmp Exit

FileCreationError:
    ; Lidar com erro na criação do arquivo de saída
    jmp Exit

Exit:
    ; Encerrar o programa
    invoke ExitProcess, 1

end start




