@echo off
setlocal enabledelayedexpansion

set BASE=X:
set DST=X:\target\nhom5_DA1-1.0-SNAPSHOT\WEB-INF\classes
set LIB=X:\target\nhom5_DA1-1.0-SNAPSHOT\WEB-INF\lib
set SRC=X:\src\main\java
set ARGFILE=%TEMP%\javac_args.txt

rem Build classpath
set CP=%DST%
for %%f in ("%LIB%\*.jar") do set CP=!CP!;%%f

rem Write args file (one option per line for @argfile)
(
echo -encoding
echo UTF-8
echo -source
echo 17
echo -target
echo 17
echo -d
echo %DST%
echo -cp
echo %CP%
echo %SRC%\demo\util\HibernateConfig.java
echo %SRC%\demo\listener\AppInitListener.java
) > "%ARGFILE%"

echo Compiling with argfile...
"C:\Program Files\Java\jdk-17\bin\javac.exe" @"%ARGFILE%"

if %ERRORLEVEL% == 0 (
    echo COMPILE SUCCESS
) else (
    echo COMPILE FAILED
)
del "%ARGFILE%" 2>nul
