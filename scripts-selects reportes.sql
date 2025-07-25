-- Select Ficha de Artista
SELECT
    a.id_artista,
    a.nombre_artista,
    a.apellido_artista,
    a.fecha_nacimiento,
    a.fecha_muerte,
    a.apodo_artista,
    a.descripcion_estilo_tecnicas,
    o.nombre_obra,
    o.dimensiones,              
    o.estilo_descripcion,      
    cp.nombre_coleccion,        
    m.nombre AS nombre_museo

FROM 
    artista AS a
JOIN 
    art_obra AS ao ON a.id_artista = ao.id_artista
JOIN 
    obra AS o ON ao.id_obra = o.id_obra
LEFT JOIN 
    historico_obra_movimiento AS hom ON o.id_obra = hom.id_obra AND hom.fecha_fin IS NULL
LEFT JOIN 
    museo AS m ON hom.id_museo_sala = m.id_museo
LEFT JOIN 
    coleccion_permanente AS cp ON hom.id_museo_coleccion = cp.id_museo AND hom.id_coleccion = cp.id_coleccion
WHERE 
    a.id_artista = $P{ID_ARTISTA}
ORDER BY
    o.nombre_obra;

-- Select Ficha de Escultura y Pintura

SELECT 
    o.id_obra,
	  o.nombre_obra,
	  o.tipo_obra,
	  o.fecha_periodo,
	  o.dimensiones,
	  o.estilo_descripcion,
	  o.descripcion_materiales_tecnicas,
	  a.nombre_artista || ' ' || a.apellido_artista AS nombre_completo_artista,
	  a.apodo_artista,
	  hom.fecha_inicio AS fecha_inicio_movimiento,
	  hom.fecha_fin AS fecha_fin_movimiento,
	  hom.tipo_obtencion,
	  hom.valor_obra,
	  hom.destacada,
	  m.nombre AS nombre_museo,
	  s.nombre_sala,
	  cp.nombre_coleccion,
	  emp.primer_nombre || ' ' || emp.primer_apellido AS nombre_curador_responsable
FROM obra AS o
	LEFT JOIN 
      art_obra AS ao ON o.id_obra = ao.id_obra 
	LEFT JOIN 
      artista AS a ON ao.id_artista = a.id_artista 
	LEFT JOIN
      historico_obra_movimiento AS hom ON o.id_obra = hom.id_obra 
	LEFT JOIN 
      museo AS m ON hom.id_museo_sala = m.id_museo 
	LEFT JOIN 
      sala_exposicion AS s ON hom.id_museo_sala = s.id_museo AND hom.id_sala = s.id_sala 
	LEFT JOIN
      coleccion_permanente AS cp ON hom.id_museo_coleccion = cp.id_museo AND hom.id_coleccion = cp.id_coleccion 
	LEFT JOIN 
      historico_empleado AS he ON hom.id_empleado = he.id_empleado AND hom.id_museo_empleado = he.id_museo AND hom.fecha_inicio_empleado = he.fecha_inicio 
	LEFT JOIN
      empleado_profesional AS emp ON he.id_empleado = emp.id_empleado_prof 
WHERE 
	 o.nombre_obra = $P{NOMBRE_ESCULTURA} 
ORDER BY 
  hom.fecha_inicio DESC;

-- Select Ficha de Itinerario de Obras Destacadas

SELECT DISTINCT 
  o.nombre_obra, 
  se.nombre_sala,
  hom.orden_recomendado
FROM 
  historico_obra_movimiento hom
INNER JOIN
  obra o ON hom.id_obra = o.id_obra
INNER JOIN
  sala_exposicion se ON hom.id_museo_sala = se.id_museoAND hom.id_estructura_fisica = se.id_estructura_fisica AND hom.id_sala = se.id_sala
INNER JOIN
  museo m On se.id_museo = m.id_museo 	
WHERE (hom.fecha_fin IS NULL) AND ( LOWER(hom.destacada) = 'si') AND (LOWER(m.nombre) LIKE CONCAT('%', LOWER($P{P_MUSEO}), '%'))
ORDER BY 
  hom.orden_recomendado

-- Select Ficha de Itinerario de Colecciones

SELECT DISTINCT
    c.nombre_coleccion,
    c.descripcion_caracteristica,
    c.orden_recorrido AS orden_recorrido_coleccion,
    se.nombre_sala,
    cs.orden_recorrido AS orden_recorrido_sala,
    m.nombre
FROM
    coleccion_permanente c
    LEFT JOIN
      col_sal cs ON c.id_museo = cs.id_museo_coleccion AND c.id_estructura_org = cs.id_estructura_org AND c.id_coleccion = cs.id_coleccion
    LEFT JOIN
      sala_exposicion se ON cs.id_museo_sala = se.id_museo AND cs.id_estructura_fisica = se.id_estructura_fisica AND cs.id_sala = se.id_sala
    LEFT JOIN
      museo m ON se.id_museo = m.id_museo    
WHERE
    $P{P_MUSEO} IS NOT NULL AND $P{P_MUSEO} != '' AND LOWER(m.nombre) LIKE CONCAT('%', LOWER($P{P_MUSEO}), '%')
ORDER BY
    c.orden_recorrido,
    cs.orden_recorrido
