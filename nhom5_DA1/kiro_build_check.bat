@echo off
set JAVA_HOME=C:\Program Files\Java\jdk-21.0.11
set PATH=%JAVA_HOME%\bin;%PATH%
cd /d C:\Users\DUNG\OneDrive\DOCUME~1\NHOM5_~1\nhom5_DA1
call mvnw.cmd compile
echo EXIT_CODE=%ERRORLEVEL%
