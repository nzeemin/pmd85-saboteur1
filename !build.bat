@echo off
set PROJNAME=sabot1
set FILENAME=sabot1

for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "DATESTAMP=%YYYY%-%MM%-%DD%"
for /f %%i in ('git rev-list HEAD --count') do (set REVISION=%%i)
echo VER.%REVISION% %DATESTAMP%
echo 	DEFM "VER.%REVISION% %DATESTAMP%" > version.inc

echo Compiling code...
tools\sjasmplus --nologo --msg=war --i8080 sabot1.asm --lst=sabot1.lst
if ERRORLEVEL 1 goto Failed

tools\salvador.exe -classic sabot1.bin sabot1.zx0
@if errorlevel 1 goto Failed

rem tools\quido -ptp -i8080 -a 0 -ja 0 -vram -ra 0xC030 -n SABOTEUR %FILENAME%.bin
tools\quido -ptp -i8080 -a 0 -ja 0 -n SABOTEUR %FILENAME%.bin
if ERRORLEVEL 1 goto Failed

tools\makepsn.exe -psn template.psn -reg PC 0 -mem 0 %FILENAME%.bin -o %FILENAME%.psn
if ERRORLEVEL 1 goto Failed

goto end

:Failed
echo ERROR

:end
