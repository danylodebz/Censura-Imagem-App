.386
.model flat, stdcall
option casemap:none

include \masm32\include\windows.inc
include \masm32\include\kernel32.inc
include \masm32\include\user32.inc
include \masm32\include\gdi32.inc
includelib \masm32\lib\kernel32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\gdi32.lib

.data
    fileName db "exemplo.bmp",0
    imgWidth dd 0
    imgHeight dd 0

    WINDOW_NAME db "BMP Viewer",0 ; Defina o nome da janela

.code
start:
    invoke LoadImage, 0, addr fileName, IMAGE_BITMAP, 0, 0, LR_LOADFROMFILE
    test eax, eax
    jz imageError

    invoke GetObject, eax, sizeof BITMAP, addr imgWidth
    mov eax, imgWidth.bmWidth
    mov imgWidth, eax
    mov eax, imgWidth.bmHeight
    mov imgHeight, eax

    invoke CreateWindowEx, 0, addr CLASS_NAME, addr WINDOW_NAME, WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT, imgWidth, imgHeight, NULL, NULL, NULL, NULL
    test eax, eax
    jz windowError

    invoke ShowWindow, eax, SW_SHOWNORMAL
    invoke UpdateWindow, eax

    .while TRUE
        invoke GetMessage, addr msg, NULL, 0, 0
        .break .if (!eax)
        invoke TranslateMessage, addr msg
        invoke DispatchMessage, addr msg
    .endw

    invoke ExitProcess, 0

imageError:
    invoke MessageBox, NULL, addr fileName, addr fileName, MB_OK
    invoke ExitProcess, 1

windowError:
    invoke MessageBox, NULL, addr WINDOW_NAME, addr WINDOW_NAME, MB_OK
    invoke ExitProcess, 1

.const
    CLASS_NAME db "BMPViewer", 0

.data?
    msg MSG
    hwnd dd ?

end start

