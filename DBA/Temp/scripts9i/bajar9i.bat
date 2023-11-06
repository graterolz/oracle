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


%ORACLE_HOME%\bin\sqlplus /nolog @C:\oracle\ora92\bajar9i.sql

net stop OracleService%oracle_sid%

net stop OracleOraHome92TNSListener

net stop Oracleagent11g1Agent

pause