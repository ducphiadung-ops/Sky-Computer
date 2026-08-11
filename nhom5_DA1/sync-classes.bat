@echo off
:: Chay file nay sau khi Build Project trong IntelliJ (Ctrl+F9 hoac Rebuild)
:: De dong bo .class tu target\classes sang WEB-INF\classes
:: Sau do Restart Tomcat trong IntelliJ

set PROJECT=c:\Users\DUNG\OneDrive\Documents\nhom5_DA1 (3)\nhom5_DA1\nhom5_DA1
set SRC=%PROJECT%\target\classes
set DST=%PROJECT%\target\nhom5_DA1-1.0-SNAPSHOT\WEB-INF\classes

echo Syncing classes...
xcopy /E /Y /Q "%SRC%\*" "%DST%\"

if %ERRORLEVEL% == 0 (
    echo DONE - Now restart Tomcat in IntelliJ
) else (
    echo ERROR
)
pause
