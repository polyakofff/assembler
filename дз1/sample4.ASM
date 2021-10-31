                   format pe console 4.0
include 'WIN32AX.INC'
 
.data
 buf db 'This text is in test.txt.'
 bufsize = $ - buf
 byteswritten dd ?
.code
 main:
 invoke  CreateFile, 'test.txt', GENERIC_WRITE, 0, 0, 4, FILE_ATTRIBUTE_NORMAL, 0
 invoke  WriteFile, eax, buf, bufsize, byteswritten, 0
 invoke  WriteConsole,<invoke GetStdHandle,STD_OUTPUT_HANDLE>,"Successfully Created!",21,0
 invoke  Sleep,-1
 invoke  ExitProcess, 0
 
.end main