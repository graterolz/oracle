SELECT 
	a.owner,
	a.segment_name,
	a.segment_type, round(a.bytes/1024/1024,0) Actual,
	round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0) Esperado,
	round((round((a.bytes-(b.num_rows*b.avg_row_len) )/1024/1024,0)/round(a.bytes/1024/1024,0))*100,2) porcentaje,
	b.LAST_ANALYZED
FROM dba_segments a, dba_tables b
WHERE a.owner=b.owner
AND a.segment_name = b.table_name
AND a.segment_type='TABLE'
AND a.owner='OPENCARD'
AND round(a.bytes/1024/1024,0)>10
ORDER BY round(a.bytes/1024/1024,0) DESC;