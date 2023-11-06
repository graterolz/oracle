@echo off
set date=%DATE%
set time=%TIME%
set ORACLE_HOME=D:\oracle\product\10.2.0\db_2
set ORACLE_SID=icsdesa


for /f "tokens=1-4 delims=/: " %%a in ("%date%") do (
set vDate=%%a%%b%%c%%d
)

for /f "tokens=1-3 delims=:: " %%a in ("%time%") do (
set vTime=%%a%%b%%c
)

for /f "tokens=1-2 delims=.: " %%a in ("%time%") do (
set vTime2=%%a%%b
)


%ORACLE_HOME%\bin\sqlplus /nolog @D:\oracle\product\10.2.0\db_2\scripts\bajar10g.sql

net stop OracleService%oracle_sid%

net stop OracleOraDb10g_home1TNSListener

net stop Oracleagent11g1Agent

pause