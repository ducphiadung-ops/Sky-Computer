@echo off
set JAVA_HOME=C:\PROGRA~1\Java\jdk-17
set PATH=%JAVA_HOME%\bin;%PATH%
cd /d %~dp0
echo JAVA_HOME=%JAVA_HOME%
java -version
call mvnw.cmd clean compile
echo.
echo BUILD EXIT CODE: %ERRORLEVEL%
