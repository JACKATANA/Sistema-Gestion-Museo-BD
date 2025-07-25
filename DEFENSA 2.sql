CREATE OR REPLACE FUNCTION Ingresos_Tickets(p_id_museo NUMERIC)
RETURNS TABLE (nombre_museo VARCHAR, ganancias_totales_por_ticket NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.nombre,
        SUM(t.precio) AS ganancias_totales
    FROM
        museo m,
        ticket t
    WHERE
        m.id_museo = t.id_museo AND m.id_museo = p_id_museo
    GROUP BY
        m.nombre;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM Ingresos_Tickets(1); 


-- Creación de Roles 
CREATE ROLE rol_curador;
CREATE ROLE rol_restaurador;
CREATE ROLE rol_director;
CREATE ROLE rol_mantenimiento_vigilancia;
CREATE ROLE rol_administrador_rrhh;

-- Permisos para rol_curador 
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_obra_movimiento TO rol_curador;
GRANT SELECT, INSERT, UPDATE, DELETE ON col_sal TO rol_curador;

GRANT SELECT ON obra, artista, art_obra, museo, lugar,
                 coleccion_permanente, estructura_fisica, sala_exposicion,
                 horario, hist_cierre, empleado_profesional, historico_empleado
TO rol_curador;

GRANT USAGE ON SEQUENCE seq_historico_obra TO rol_curador;


-- Permisos para rol_restaurador 
GRANT SELECT, INSERT, UPDATE, DELETE ON mantenimiento_obra TO rol_restaurador;
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_mantenimiento_realizado TO rol_restaurador;

GRANT SELECT ON obra, historico_obra_movimiento,
                 empleado_profesional, historico_empleado
TO rol_restaurador;

GRANT USAGE ON SEQUENCE seq_mantenimiento_obra, seq_historico_mant_re TO rol_restaurador;


-- Permisos para rol_director 
GRANT SELECT ON museo, resumen_hist, evento, ticket, tipo_ticket_historico, horario,
                 obra, historico_obra_movimiento, coleccion_permanente,
                 estructura_organizacional, empleado_profesional, historico_empleado,
                 lugar, estructura_fisica, sala_exposicion
TO rol_director;

-- PERMISO PARA EJECUTAR FUNCION
GRANT EXECUTE ON FUNCTION Ingresos_Tickets(NUMERIC) TO rol_director;


-- Permisos para rol_mantenimiento_vigilancia 
GRANT SELECT, INSERT, UPDATE ON asignacion_mensual TO rol_mantenimiento_vigilancia;
GRANT SELECT ON empleado_mantenimiento_vigilancia, estructura_fisica, museo TO rol_mantenimiento_vigilancia;
GRANT USAGE ON SEQUENCE seq_empleado_mv TO rol_mantenimiento_vigilancia;


-- Permisos para rol_administrador_rrhh 
GRANT SELECT, INSERT, UPDATE, DELETE ON
    empleado_profesional, formacion_profesional, idioma, emp_idi, historico_empleado,
    empleado_mantenimiento_vigilancia, asignacion_mensual
TO rol_administrador_rrhh;

GRANT SELECT ON museo, estructura_organizacional, estructura_fisica TO rol_administrador_rrhh;

GRANT USAGE ON SEQUENCE seq_empleado_prof, seq_formacion, seq_idioma, seq_empleado_mv TO rol_administrador_rrhh;

-- Creación de Usuarios y Asignación de Roles
CREATE USER jac WITH PASSWORD '1234';
GRANT rol_curador TO jac;

CREATE USER isaac WITH PASSWORD '1234';
GRANT rol_restaurador TO isaac;

CREATE USER adley WITH PASSWORD '1234';
GRANT rol_director TO adley;

CREATE USER juan WITH PASSWORD '1234';
GRANT rol_mantenimiento_vigilancia TO juan;

CREATE USER angel WITH PASSWORD '1234';
GRANT rol_administrador_rrhh TO angel;

-- REVOKE

REVOKE INSERT ON TABLE ticket FROM Jac;
REVOKE EXECUTE ON FUNCTION ingresos_tickets(NUMERIC) FROM rol_director;
REVOKE USAGE ON SEQUENCE seq_obra FROM rol_curador;
DROP USER user_name;
DROP ROLE role_name;
REVOKE [ROLENAME] FROM [USERNAME];