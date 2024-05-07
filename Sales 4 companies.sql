--Detalle de ventas de 4 empresas

with vtas_LPP_1 as (
Select	'LPP' Empresa
		,itemnumber
		,customernumber
		,year(fecha)*100+month(fecha) id_tiempo_mes
		,sum(cantidad) cantidad
		,sum(kilosvendidos) kilos
		,sum(ventatotaldolar) venta_usd
		,sum(subtotal_soles) venta_pen
from dbo.peru_sales_report
group by itemnumber,customernumber,year(fecha)*100+month(fecha)
)

,vtas_LPP_2 as (
Select	'LPP' Empresa
		,itemnumber cod_articulo
		,customernumber RUC
		,id_tiempo_mes
		,sum(cantidad) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) cantidad_U12M
		,sum(kilos) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) kilos_U12M
		,sum(venta_usd) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_usd_U12M
		,sum(venta_pen) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_pen_U12M
from vtas_LPP_1
group by itemnumber,customernumber,id_tiempo_mes,cantidad,kilos,venta_usd,venta_pen
)

,vtas_LPP_GP13_1 as (
Select	'LPP' Empresa
		,itemnumber
		,customernumber
		,year(fecha)*100+month(fecha) id_tiempo_mes
		,sum(cantidad) cantidad
		,sum(kilosvendidos) kilos
		,sum(ventatotaldolar) venta_usd
		,sum(subtotal_soles) venta_pen
from peru_sales_report
where año*100+month(fecha)<=201910
group by itemnumber,customernumber,year(fecha)*100+month(fecha)
)

,vtas_LPP_GP13_2 as (
Select	'LPP' Empresa
		,itemnumber cod_articulo
		,customernumber RUC
		,id_tiempo_mes
		,sum(cantidad) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) cantidad_U12M
		,sum(kilos) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) kilos_U12M
		,sum(venta_usd) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_usd_U12M
		,sum(venta_pen) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_pen_U12M
from vtas_LPP_GP13_1
group by itemnumber,customernumber,id_tiempo_mes,cantidad,kilos,venta_usd,venta_pen
)

,vtas_PET_1 as (
Select	'PET' Empresa
		,itemnumber
		,customernumber
		,year(fecha)*100+month(fecha) id_tiempo_mes
		,sum(cantidad) cantidad
		,sum(kilosvendidos) kilos
		,sum(ventatotaldolar) venta_usd
		,sum(subtotal_soles) venta_pen
from dbo.peru_sales_report
)

,vtas_PET_2 as (
Select	'LPP' Empresa
		,itemnumber cod_articulo
		,customernumber RUC
		,id_tiempo_mes
		,sum(cantidad) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) cantidad_U12M
		,sum(kilos) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) kilos_U12M
		,sum(venta_usd) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_usd_U12M
		,sum(venta_pen) over(partition by itemnumber,customernumber order by id_tiempo_mes asc rows between 11 preceding and current row) venta_pen_U12M
from vtas_LPP_1
group by itemnumber,customernumber,id_tiempo_mes,cantidad,kilos,venta_usd,venta_pen
)

,vtas_PET_GP13 as (
Select	'PET' Empresa
		,tipodoc COLLATE Latin1_General_CI_AS tipo_doc
		,sopnumber COLLATE Latin1_General_CI_AS factura
		,itemnumber COLLATE Latin1_General_CI_AS cod_articulo
		,customernumber COLLATE Latin1_General_CI_AS RUC
		,fecha
		,UM COLLATE Latin1_General_CI_AS UM
		,cantidad
		,kilosvendidos
		,punitsoles punit_pen
		,punitdolar punit_usd
		,cunitsoles cunit_pen
		,cunitdolar cunit_usd
		,punitsoles-cunitsoles mgunit_pen
		,punitdolar-cunitdolar mgunit_usd
		,ventatotaldolar venta_usd
		,subtotal_soles venta_pen
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototaldolar) else abs(costototaldolar) end costo_usd
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototalsoles) else abs(costototalsoles) end costo_pen
		,numpedido COLLATE Latin1_General_CI_AS pedido
		,numeroguia COLLATE Latin1_General_CI_AS guia
		,tipo_venta COLLATE Latin1_General_CI_AS tipo_venta
		,condicionpago COLLATE Latin1_General_CI_AS condicion_pago
		,moneda COLLATE Latin1_General_CI_AS moneda
		,tc_maestro
		,tc_doc
		,vendedor COLLATE Latin1_General_CI_AS vendedor_factura
		,almacen COLLATE Latin1_General_CI_AS cod_alm
from dbo.peru_sales_report
where año*100+month(fecha)<=201910
)

,vtas_EVS as (
Select	'EVS' Empresa
		,tipodoc tipo_doc
		,sopnumber factura
		,itemnumber cod_articulo
		,customernumber RUC
		,fecha
		,UM
		,cantidad
		,kilosvendidos
		,punitsoles punit_pen
		,punitdolar punit_usd
		,cunitsoles cunit_pen
		,cunitdolar cunit_usd
		,punitsoles-cunitsoles mgunit_pen
		,punitdolar-cunitdolar mgunit_usd
		,ventatotaldolar venta_usd
		,subtotal_soles venta_pen
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototaldolar) else abs(costototaldolar) end costo_usd
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototalsoles) else abs(costototalsoles) end costo_pen
		,numeropedido pedido
		,numeroguia guia
		,tipo_venta
		,condicionpago condicion_pago
		,moneda
		,tc_maestro
		,tc_doc
		,vendedor vendedor_factura
		,almacen cod_alm
from dbo.peru_sales_report
)

,vtas_CPL as (
Select	'CPL' Empresa
		,tipodoc tipo_doc
		,sopnumber factura
		,itemnumber cod_articulo
		,customernumber RUC
		,fecha
		,UM
		,cantidad
		,kilosvendidos
		,punitsoles punit_pen
		,punitdolar punit_usd
		,cunitsoles cunit_pen
		,cunitdolar cunit_usd
		,punitsoles-cunitsoles mgunit_pen
		,punitdolar-cunitdolar mgunit_usd
		,ventatotaldolar venta_usd
		,subtotal_soles venta_pen
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototaldolar) else abs(costototaldolar) end costo_usd
		,case when cantidad<0 or kilosvendidos<0 or ventatotaldolar<0 then -abs(costototalsoles) else abs(costototalsoles) end costo_pen
		,numeropedido pedido
		,numeroguia guia
		,tipo_venta
		,condicionpago condicion_pago
		,moneda
		,tc_maestro
		,tc_doc
		,vendedor vendedor_factura
		,almacen cod_alm
from dbo.peru_sales_report
)

Select	a.*
		,venta_usd - costo_usd margen_usd
		,venta_pen - costo_pen margen_pen
		,concat(empresa COLLATE Latin1_General_CI_AS,cod_alm) refer_alm
		,concat(empresa COLLATE Latin1_General_CI_AS,ruc) refer_cli
		,concat(empresa COLLATE Latin1_General_CI_AS,cod_articulo) refer_art
from
(select * from vtas_LPP union all
select * from vtas_PET union all
select * from vtas_EVS union all
select * from vtas_CPL union all
select * from vtas_LPP_GP13 union all
select * from vtas_PET_GP13) a
