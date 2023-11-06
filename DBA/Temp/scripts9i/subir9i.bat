@echo off
set date=%DATE%
set time=%TIME%
set ORACLE_HOME=C:\oracle\ora92
set ORACLE_SID=scs


for /f "tokens=1-4 delims=/: " %%a in ("%date%") do (
set vDate=%%a%%b%%c%%d
)

for /f "tokens=1-3 delims=:: " %%a in ("%time%") do (
set vTime=%%a%%b%%c
)

for /f "tokens=1-2 delims=.: " %%a in ("%time%") do (
set vTime2=%%a%%b
)


net start Oracleagent11g1Agent

net start OracleOraHome92TNSListener

net start OracleService%oracle_sid%


%ORACLE_HOME%\bin\sqlplus /nolog @C:\oracle\ora92\scripts\subir9i.sql


pause