if "%TARGET_PLATFORM%" == "win-arm64" (
    set CUDA_ARCH=arm64
) else (
    set CUDA_ARCH=x64
)

if not exist %PREFIX% mkdir %PREFIX%
@echo on

REM robocopy returns 0-7 for various successful conditions
robocopy lib\%CUDA_ARCH% %LIBRARY_LIB%\%CUDA_ARCH% /MOVE /E
if %ERRORLEVEL% GEQ 8 exit 1
robocopy include %LIBRARY_INC% /MOVE /E
if %ERRORLEVEL% GEQ 8 exit 1
