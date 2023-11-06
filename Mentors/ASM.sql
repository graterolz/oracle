SELECT name, floor(total_mb/1024) "Capacyty Total GB", floor(free_mb/1024) "available capacity GB", ROUND(free_mb/total_mb*100,2) "% available capacity" FROM v$asm_diskgroup;

select GROUP_NUMBER, NAME,TOTAL_MB, FREE_MB, USABLE_FILE_MB from V$ASM_DISKGROUP;