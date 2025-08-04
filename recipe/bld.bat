if not exist %PREFIX% mkdir %PREFIX%
@echo on

REM robocopy returns 0-7 for various successful conditions
robocopy lib\x64 %LIBRARY_LIB%\x64 /MOVE /E
if %ERRORLEVEL% GEQ 8 exit 1
robocopy include %LIBRARY_INC% /MOVE /E
if %ERRORLEVEL% GEQ 8 exit 1
