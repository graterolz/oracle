-- Ver los parámetros asociados a una vista materializada
SELECT refresh_method, refresh_mode, staleness,  last_refresh_type, last_refresh_date
FROM user_mviews
WHERE mview_name = 'MV_name';

-- Refresca la vista materializada especificada ejecutar desde sqlplus
begin
dbms_mview.refresh(‘sh.sales_mv,sh.cal_month_sales_mv’);
end;
/

-- Parámetros para dbms_mview
-- Metoh: indica como se hace el refresco (‘c’ completo, ‘f’ fast y ‘?’ para force)
-- atomic_refresh: Si se pone a FALSE, cuando se hace un refresco completo en vez de borrar la tabla la trunca