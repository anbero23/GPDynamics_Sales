-----------para reporte de despachos

with despachos as (

--Join entre Perú_guías y la IV00101, otros campos son calculados
SELECT 
	a.[NumDOC] as Num_guia
      ,a.[DOCDATE] as Fecha
      ,a.[CUSTNMBR] as Cod_cliente
      ,a.[CUSTNAME] as Nombre_cliente
      ,a.[CodArt] as Cod_articulo
      ,a.[ITEMDESC] as Desc_articulo
      ,a.[QUANTITY] as Cantidad
      ,a.[ComentDOC] 
      ,a.[LOCNCODE]
      ,a.[ADDRESS1] as Direccion
      ,a.[SHIPMTHD] as Tipo_entrega
      ,a.[MODIFDT] as Fecha_modif
      ,a.[Det_Impresion] 
      ,a.[NumDOC_CODArticulo]
      ,a.[CSTPONBR] as Num_factura
      ,a.[Estado]
	  ,Month(a.[DOCDATE]) as Mes
	  ,year(a.[DOCDATE]) as Año	   
	  ,case when uomschdl='kilo' then 1 else cast(b.USCATVLS_1 as float) end as Peso_unitario_Kg
	  ,((case when uomschdl='kilo' then 1 else cast(b.USCATVLS_1 as float) end)*a.[QUANTITY]) as Peso_total_Kg	  
	  ,Sede =
		CASE   
      WHEN SUBSTRING(a.LOCNCODE, 1, 2) = '01' THEN 'Callao'   
	  ELSE 'Trujillo'   
		END

--SELECT * FROM DBO.IV00101
FROM [dbo].[Peru_Guias] a
left join [dbo].[IV00101] b
on (a.CodArt = b.ITEMNMBR)

----------------------------------------------------------------------------------
UNION ALL

SELECT 
	a.[NumDOC] COLLATE SQL_Latin1_General_CP1_CI_AS as Num_guia
      ,a.[DOCDATE] as Fecha
      ,a.[CUSTNMBR] COLLATE SQL_Latin1_General_CP1_CI_AS as Cod_cliente
      ,a.[CUSTNAME] COLLATE SQL_Latin1_General_CP1_CI_AS as Nombre_cliente
      ,a.[CodArt] COLLATE SQL_Latin1_General_CP1_CI_AS as Cod_articulo
      ,a.[ITEMDESC] COLLATE SQL_Latin1_General_CP1_CI_AS as Desc_articulo
      ,a.[QUANTITY] as Cantidad
      ,a.[ComentDOC] COLLATE SQL_Latin1_General_CP1_CI_AS 
      ,a.[LOCNCODE] COLLATE SQL_Latin1_General_CP1_CI_AS
      ,a.[ADDRESS1] COLLATE SQL_Latin1_General_CP1_CI_AS as Direccion
      ,a.[SHIPMTHD] COLLATE SQL_Latin1_General_CP1_CI_AS as Tipo_entrega
      ,a.[MODIFDT] as Fecha_modif
      ,a.[Det_Impresion] COLLATE SQL_Latin1_General_CP1_CI_AS 
      ,a.[NumDOC_CODArticulo] COLLATE SQL_Latin1_General_CP1_CI_AS
      ,a.[CSTPONBR] COLLATE SQL_Latin1_General_CP1_CI_AS as Num_factura
      ,a.[Estado] COLLATE SQL_Latin1_General_CP1_CI_AS
	  ,Month(a.[DOCDATE]) as Mes
	  ,year(a.[DOCDATE]) as Año	   
	  ,case when uomschdl='kilo' then 1 else cast(b.USCATVLS_1 COLLATE SQL_Latin1_General_CP1_CI_AS as float) end as Peso_unitario_Kg
	  ,((case when uomschdl='kilo' then 1 else cast(b.USCATVLS_1 COLLATE SQL_Latin1_General_CP1_CI_AS as float) end)*a.[QUANTITY]) as Peso_total_Kg	  
	  ,Sede =
		CASE   
      WHEN SUBSTRING(a.LOCNCODE COLLATE SQL_Latin1_General_CP1_CI_AS, 1, 2) = '01' THEN 'Callao'   
	  ELSE 'Trujillo'   
		END
	  
FROM [dbo].[Peru_Guias] a
left join [dbo].[IV00101] b
on (a.CodArt = b.ITEMNMBR)
)


select distinct 	year(a.fecha) Año
		,datepart(week,a.fecha) Semana
		,a.Fecha
		,a.Cod_cliente 'Ruc Cliente'
		,ln.nombre Linea_negocio
		,tf.nombre Familia
		,sf.nombre SubFamilia
		,a.locncode Bodega_despacho
		,case left(a.locncode,2) when '01' then 'Callao' else 'Trujillo'
		end 'Sede_despacho'
		,a.Nombre_Cliente Cliente
		,a.Direccion Destino
		,vta.envío 'Sede destino'
		,a.Num_guia 'Guía Remisión'
		,a.Num_factura 'Pedido'
		,base.vendedor 'Vendedor actual'
		--,fl.rasonsocial Transporte
		--,fl.Chofer Chofer
		,a.Cod_articulo Producto
		,a.Desc_articulo 'Desc_producto'
		,a.Cantidad Cantidad
		,case when vta.oruntprc=vta.UNITPRCE then 'PEN' else 'USD' end 'Moneda-vta'
		,vta.unitprce/tipo_cambio.cambio 'Precio unit USD' --precio unit
		,vta.unitcost/tipo_cambio.cambio 'Costo unit USD' --costo unit
		,case when vta.envío like 'EXW%' then vta.unitprce/tipo_cambio.cambio else null end 'Precio unit EXW'
		,case when vta.envío like 'EXW%' then vta.unitprce/tipo_cambio.cambio*a.cantidad else null end 'Total Venta EXW'
		,a.Cantidad*vta.unitprce/tipo_cambio.cambio 'Total Venta USD' --total venta neta
		,a.Cantidad*vta.unitcost/tipo_cambio.cambio 'Total Costo USD' --total costo neto
		,a.peso_unitario_kg 'Peso Unitario kg'
		,a.Peso_total_kg 'Peso Total kg'
from despachos a
--select * from dbo.neLgTbCategoria where empresaid='gppet'
		left join dbo.neLgTbCategoria ln
on		ln.categoriaid = substring(a.cod_articulo, 1, 3) and ln.empresaid = 'GPPET'
		left join dbo.nelgtbcategoria tf
on		tf.categoriaid= substring(a.cod_articulo, 1, 5) and tf.empresaid = 'GPPET'
		left join dbo.nelgtbcategoria sf
on		sf.categoriaid= substring(a.cod_articulo, 1, 7) and sf.empresaid = 'GPPET'
--		left join (select gr_numero,ruc,rasonsocial,chofer
--		from dbo.Peru_Adicional_DatosTransportista
--		union all
--		select gr_numero,ruc,razonsocial,null chofer
--		from (select gr_numero,ruc,b.nombre Razonsocial
--		from dbo.Peru_Adicional_DatosTransportista a
--		left join dbo.Peru_Maestro_Proveedores b
--		on b.id=a.ruc) a
--		) fl
--on		fl.gr_numero COLLATE SQL_Latin1_General_CP1_CI_AS = a.Num_guia
		left join (select distinct sopnumbe,itemnmbr,itemdesc,uofm,locncode,unitcost,unitprce,oruntcst,oruntprc,quantity,shiptoname,prstadcd 'envío',reqshipdate,slprsnid 'Vendedor'
		from dbo.sop30300
		union all
		select distinct sopnumbe COLLATE Latin1_General_CI_AS,itemnmbr COLLATE Latin1_General_CI_AS,itemdesc COLLATE Latin1_General_CI_AS,uofm COLLATE Latin1_General_CI_AS,locncode COLLATE Latin1_General_CI_AS,unitcost,unitprce,oruntcst,oruntprc,quantity,shiptoname COLLATE Latin1_General_CI_AS,prstadcd COLLATE Latin1_General_CI_AS 'envío',reqshipdate,slprsnid COLLATE Latin1_General_CI_AS
		from dbo.sop30300) vta
on		vta.sopnumbe COLLATE Latin1_General_CI_AS=a.Num_Guia and vta.itemnmbr COLLATE Latin1_General_CI_AS=a.Cod_articulo and vta.quantity=a.Cantidad
		left join (select distinct exchdate fecha
		,case exchdate when '20190119' then 3.319 when '20190228' then 3.306 when '20191201' then 3.399 else xchgrate
		end cambio
		from dbo.Peru_Maestro_Tipo_Cambio
		where exgtblid='PEN-USD-VENT' and year(exchdate)*100+month(exchdate)>=201910
		union all
		select distinct exchdate fecha
		,case exchdate when '20181126' then 3.379 else xchgrate
		end cambio
		from dbo.Peru_Maestro_Tipo_Cambio
		where exgtblid='PEN-USD-VENT' and year(exchdate)*100+month(exchdate)>=201800) tipo_cambio
on		tipo_cambio.fecha=a.Fecha
		left join (SELECT custnmbr RUC,custname nombre,slprsnid Vendedor,salsterr Zona
		FROM dbo.RM00101) base
on		base.ruc=a.Cod_cliente

where a.año>=2018
--and a.Num_guia='GR 05N-00000958'

