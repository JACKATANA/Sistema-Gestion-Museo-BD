CREATE SEQUENCE seq_lugar START WITH 1 INCREMENT BY 1;

CREATE TABLE lugar(
  id_lugar NUMERIC DEFAULT nextval('seq_lugar') primary key,
  nombre_lugar VARCHAR(50) NOT NULL,
  tipo VARCHAR(20),
  id_jerarquia NUMERIC,
  CONSTRAINT ch_tipo CHECK(tipo IN('ciudad', 'pais')),
  CONSTRAINT fk_jerarquia FOREIGN KEY(id_jerarquia) REFERENCES LUGAR(id_lugar)
);

CREATE SEQUENCE seq_obra START WITH 1 INCREMENT BY 1;
CREATE TABLE obra(
    id_obra NUMERIC DEFAULT nextval('seq_obra') PRIMARY KEY,
    nombre_obra VARCHAR(250) NOT NULL, 
    fecha_periodo VARCHAR(100) NOT NULL,
    tipo_obra VARCHAR(9) NOT NULL,
    dimensiones VARCHAR(80) NOT NULL,
    estilo_descripcion VARCHAR(80) NOT NULL, 
    descripcion_materiales_tecnicas VARCHAR(300) NOT NULL,
    CONSTRAINT ch_tipo_obra CHECK (tipo_obra IN('pintura', 'escultura'))
);

CREATE SEQUENCE seq_artista START WITH 1 INCREMENT BY 1;
CREATE TABLE artista(
    id_artista NUMERIC DEFAULT nextval('seq_artista') primary key,
    nombre_artista VARCHAR(60),
    apellido_artista VARCHAR(60),
    fecha_nacimiento DATE, 
    apodo_artista VARCHAR(60), 
    fecha_muerte DATE,
    descripcion_estilo_tecnicas VARCHAR(300) NOT NULL
);

CREATE TABLE art_obra(
    id_artista NUMERIC NOT NULL,
    id_obra NUMERIC NOT NULL,
    CONSTRAINT fk_artista FOREIGN KEY(id_artista) REFERENCES artista(id_artista),
    CONSTRAINT fk_obra FOREIGN KEY(id_obra) REFERENCES obra(id_obra),
    PRIMARY KEY(id_artista, id_obra)
);

CREATE SEQUENCE seq_museo START WITH 1 INCREMENT BY 1;
CREATE TABLE museo(
  id_museo NUMERIC DEFAULT nextval('seq_museo') primary key,
  nombre VARCHAR(50) NOT NULL,
  mision VARCHAR(350),
  fecha_fundacion DATE NOT NULL, 
  id_lugar NUMERIC NOT NULL, 
  CONSTRAINT fk_lugar FOREIGN KEY(id_lugar) REFERENCES lugar(id_lugar)
);

CREATE TABLE resumen_hist(
    id_museo NUMERIC NOT NULL,
    ano DATE NOT NULL,
    hechos_hist VARCHAR(350) NOT NULL,
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY (id_museo, ano)
);

CREATE TABLE tipo_ticket_historico(
    id_museo NUMERIC NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    precio NUMERIC NOT NULL, 
    tipo_ticket VARCHAR(15) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    CONSTRAINT ch_tipo_ticket CHECK (tipo_ticket IN('niño', 'adulto', 'tercera edad')),
    PRIMARY KEY(id_museo, fecha_inicio)
);

CREATE SEQUENCE seq_evento START WITH 1 INCREMENT BY 1;
CREATE TABLE evento(
    id_museo NUMERIC NOT NULL,
    id_evento NUMERIC DEFAULT nextval('seq_evento') NOT NULL,
    fecha_inicio_evento DATE NOT NULL,
    fecha_fin_evento DATE NOT NULL, 
    nombre_evento VARCHAR(150) NOT NULL,
    institucion_educativa VARCHAR(150), 
    cantidad_asistentes NUMERIC,
    lugar_exposicion VARCHAR(100),
    costo_persona NUMERIC,  
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_evento)
);

CREATE SEQUENCE seq_ticket START WITH 1 INCREMENT BY 1;
CREATE TABLE ticket(
    id_museo NUMERIC NOT NULL,
    id_ticket NUMERIC DEFAULT nextval('seq_ticket') NOT NULL,
    precio NUMERIC NOT NULL,
    tipo_ticket VARCHAR(20) NOT NULL,
    fecha_hora_ticket DATE NOT NULL,
    CONSTRAINT ch_tipo_ticket CHECK (tipo_ticket IN('niño', 'adulto', 'tercera edad')),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_ticket)
);

CREATE TABLE horario(
  id_museo NUMERIC NOT NULL,
  dia NUMERIC NOT NULL,
  hora_apertura TIME NOT NULL, 
  hora_cierre TIME NOT NULL,
  CONSTRAINT id_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
  CONSTRAINT rang_dia  CHECK(dia between 1 and 7),
  PRIMARY KEY (id_museo, dia)
);

CREATE SEQUENCE seq_empleado_prof START WITH 1 INCREMENT BY 1;
CREATE TABLE empleado_profesional(
    id_empleado_prof NUMERIC DEFAULT nextval('seq_empleado_prof') primary key,
    primer_nombre VARCHAR(20) NOT NULL,
    primer_apellido VARCHAR(20) NOT NULL, 
    segundo_apellido varchar(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    doc_identidad NUMERIC NOT NULL,
    dato_contacto VARCHAR(100),
    segundo_nombre VARCHAR(20)
);

CREATE SEQUENCE seq_formacion START WITH 1 INCREMENT BY 1;
CREATE TABLE formacion_profesional(
    id_empleado_prof NUMERIC NOT NULL,
    id_formacion NUMERIC DEFAULT nextval('seq_formacion') NOT NULL,
    nombre_titulo VARCHAR(100) NOT NULL,
    ano DATE NOT NULL, 
    descripcion_especialidad VARCHAR(200) NOT NULL, 
    CONSTRAINT fk_empleado_prof FOREIGN KEY(id_empleado_prof) REFERENCES empleado_profesional(id_empleado_prof),
    PRIMARY KEY(id_empleado_prof, id_formacion)
);

CREATE SEQUENCE seq_idioma START WITH 1 INCREMENT BY 1;
CREATE TABLE idioma(
    id_idioma NUMERIC DEFAULT nextval('seq_idioma') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE emp_idi(
    id_idioma NUMERIC NOT NULL,
    id_empleado_prof NUMERIC NOT NULL,
    CONSTRAINT fk_idioma FOREIGN KEY(id_idioma) REFERENCES idioma(id_idioma),
    CONSTRAINT fk_empleado_prof FOREIGN KEY(id_empleado_prof) REFERENCES empleado_profesional(id_empleado_prof),
    PRIMARY KEY(id_idioma, id_empleado_prof)
);

CREATE SEQUENCE seq_estructura_org START WITH 1 INCREMENT BY 1;
CREATE TABLE estructura_organizacional(
    id_museo NUMERIC NOT NULL,
    id_estructura_org NUMERIC DEFAULT nextval('seq_estructura_org') NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    nivel VARCHAR(50) NOT NULL, 
    tipo VARCHAR(50) NOT NULL,
    id_jerarquia_estructura NUMERIC,
    id_jerarquia_museo NUMERIC,
    CONSTRAINT ch_nivel CHECK(nivel IN('Nivel 1', 'Nivel 2', 'Nivel 3', 'Nivel 4')),
    CONSTRAINT ch_tipo CHECK(tipo IN('direccion', 'departamento', 'seccion', 'subdepartamento', 'subseccion')),
    CONSTRAINT fk_jerarquia FOREIGN KEY(id_jerarquia_museo, id_jerarquia_estructura) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_estructura_org)
); 

CREATE SEQUENCE seq_coleccion START WITH 1 INCREMENT BY 1;
CREATE TABLE coleccion_permanente(
    id_museo NUMERIC NOT NULL,
    id_estructura_org NUMERIC NOT NULL,
    id_coleccion NUMERIC DEFAULT nextval('seq_coleccion') NOT NULL,
    nombre_coleccion VARCHAR(80) NOT NULL,
    descripcion_caracteristica VARCHAR(300) NOT NULL,
    palabra_clave VARCHAR(50) NOT NULL,
    orden_recorrido NUMERIC NOT NULL, 
    CONSTRAINT fk_estructura_org FOREIGN KEY(id_museo, id_estructura_org) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    PRIMARY KEY( id_museo, id_estructura_org, id_coleccion)
);

CREATE SEQUENCE seq_estructura_fisica START WITH 1 INCREMENT BY 1;
CREATE TABLE estructura_fisica(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC DEFAULT nextval('seq_estructura_fisica') NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    tipo_estructura VARCHAR(15),
    descripcion VARCHAR(150),
    direccion VARCHAR(250),
    id_jerarquia_museo NUMERIC,
    id_jerarquia_estructura NUMERIC,
    CONSTRAINT fk_jerarquia_estructura FOREIGN KEY(id_jerarquia_museo, id_jerarquia_estructura) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    CONSTRAINT ch_tipo_estructura CHECK(tipo_estructura IN('edificio', 'piso', 'area seccion')),
    PRIMARY KEY(id_museo, id_estructura_fisica) 
);

CREATE SEQUENCE seq_sala START WITH 1 INCREMENT BY 1;
CREATE TABLE sala_exposicion(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC DEFAULT nextval('seq_sala') NOT NULL, 
    nombre_sala VARCHAR(50),
    descripcion VARCHAR(250),
    CONSTRAINT fk_estructura_fisica FOREIGN KEY(id_museo, id_estructura_fisica) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_sala)
);

CREATE TABLE col_sal(
    id_museo_sala NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL, 
    id_sala NUMERIC NOT NULL,
    id_museo_coleccion NUMERIC NOT NULL,
    id_estructura_org NUMERIC NOT NULL, 
    id_coleccion NUMERIC NOT NULL, 
    orden_recorrido NUMERIC NOT NULL,
    CONSTRAINT fk_sala FOREIGN KEY(id_museo_sala, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),
    CONSTRAINT fk_coleccion FOREIGN KEY(id_museo_coleccion, id_estructura_org, id_coleccion) REFERENCES coleccion_permanente(id_museo, id_estructura_org, id_coleccion),
    PRIMARY KEY(id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion)
);

CREATE TABLE hist_cierre(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC NOT NULL,
    fecha_ini DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_sala_exposicion FOREIGN KEY(id_museo, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_sala)
);

CREATE SEQUENCE seq_empleado_mv START WITH 1 INCREMENT BY 1;
CREATE TABLE empleado_mantenimiento_vigilancia(
    id_empleado_mantenimiento_vigilancia NUMERIC DEFAULT nextval('seq_empleado_mv') primary key,
    nombre_empleado_mv VARCHAR(20) NOT NULL,
    apellido_empleado_mv VARCHAR(20) NOT NULL, 
    doc_identidad NUMERIC NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT ch_tipo CHECK(tipo IN('vigilancia', 'mantenimiento'))
);

CREATE TABLE asignacion_mensual(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL, 
    id_empleado_mantenimiento_vigilancia NUMERIC NOT NULL,
    mes_ano DATE NOT NULL,
    turno VARCHAR(15),
    CONSTRAINT ch_turno CHECK(turno IN('matutino', 'vesperino', 'nocturno')),
    CONSTRAINT fk_estructura_fisica FOREIGN KEY(id_museo, id_estructura_fisica) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    CONSTRAINT fk_empleado_mv FOREIGN KEY(id_empleado_mantenimiento_vigilancia) REFERENCES empleado_mantenimiento_vigilancia(id_empleado_mantenimiento_vigilancia),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_empleado_mantenimiento_vigilancia, mes_ano)
);

CREATE TABLE historico_empleado(
    id_empleado NUMERIC NOT NULL,
    id_museo NUMERIC NOT NULL, 
    id_estructura_org NUMERIC NOT NULL,
    fecha_inicio DATE NOT NULL,
    rol_empleado VARCHAR(70) NOT NULL,
    fecha_fin DATE, 
    CONSTRAINT fk_estructura_org FOREIGN KEY(id_museo, id_estructura_org) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    CONSTRAINT fk_empleado FOREIGN KEY(id_empleado) REFERENCES empleado_profesional(id_empleado_prof),
    CONSTRAINT ch_rol CHECK(rol_empleado IN('curador', 'restaurador', 'administrativo', 'director')),
    PRIMARY KEY(id_empleado, id_museo, id_estructura_org, fecha_inicio)
);

CREATE SEQUENCE seq_historico_obra START WITH 1 INCREMENT BY 1;
CREATE TABLE historico_obra_movimiento(
  
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC DEFAULT nextval('seq_historico_obra') NOT NULL,
    fecha_inicio DATE NOT NULL,
    tipo_obtencion VARCHAR NOT NULL,
    destacada VARCHAR(2) NOT NULL,
  
    id_museo_sala NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC NOT NULL,
  
    id_museo_coleccion NUMERIC NOT NULL,
    id_estructura_org_coleccion NUMERIC NOT NULL,
    id_coleccion NUMERIC NOT NULL,

    id_museo_empleado NUMERIC NOT NULL,
    id_estructura_org_empleado NUMERIC NOT NULL,
    id_empleado NUMERIC NOT NULL, 
    fecha_inicio_empleado DATE NOT NULL,
  
    fecha_fin DATE, 
    valor_obra NUMERIC NOT NULL,
    orden_recomendado NUMERIC, 

    CONSTRAINT fk_obra FOREIGN KEY(id_obra) REFERENCES obra(id_obra),
    CONSTRAINT fk_sala FOREIGN KEY(id_museo_sala, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),  
    CONSTRAINT fk_coleccion FOREIGN KEY(id_museo_coleccion, id_estructura_org_coleccion, id_coleccion) REFERENCES coleccion_permanente(id_museo, id_estructura_org, id_coleccion),
    CONSTRAINT fk_historico_empleado FOREIGN KEY(id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado) REFERENCES historico_empleado(id_museo, id_estructura_org, id_empleado, fecha_inicio),
    CONSTRAINT ch_tipo_obtencion CHECK(tipo_obtencion IN('comprado', 'donado', 'comprado a otro museo', 'donado de otro museo')),
    CONSTRAINT ch_destacada CHECK(destacada IN('si', 'no')),
    primary key(id_obra, id_historico_obra_movimiento)
);

CREATE SEQUENCE seq_mantenimiento_obra START WITH 1 INCREMENT BY 1;

CREATE TABLE mantenimiento_obra(
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC NOT NULL,
    id_mantenimiento_obra NUMERIC DEFAULT nextval('seq_mantenimiento_obra') NOT NULL, 
    actividad VARCHAR(250) NOT NULL,
    frecuencia NUMERIC NOT NULL, 
    tipo_resposable VARCHAR(15), 
    CONSTRAINT ch_tipo_responsable CHECK(tipo_resposable IN('curador', 'restaurador', 'otro')),
    CONSTRAINT fk_historico_obra_movimiento FOREIGN KEY(id_obra, id_historico_obra_movimiento) REFERENCES historico_obra_movimiento(id_obra, id_historico_obra_movimiento),
    PRIMARY KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra)
);

CREATE SEQUENCE seq_historico_mant_re START WITH 1 INCREMENT BY 1;
CREATE TABLE historico_mantenimiento_realizado(
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC NOT NULL,
    id_mantenimiento_obra NUMERIC NOT NULL,
    id_historico_mant_re NUMERIC DEFAULT nextval('seq_historico_mant_re') NOT NULL,
    fecha_inicio DATE NOT NULL, 
    observaciones VARCHAR(250) NOT NULL,
    id_empleado NUMERIC NOT NULL,
    id_museo NUMERIC NOT NULL, 
    id_estructura_org NUMERIC NOT NULL,
    fecha_inicio_hist_empleado DATE NOT NULL,
    fecha_fin DATE, 
    CONSTRAINT fk_historico_empleado FOREIGN KEY(id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado) REFERENCES historico_empleado(id_empleado, id_museo, id_estructura_org, fecha_inicio),
    CONSTRAINT fk_mantenimiento_obra FOREIGN KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra) REFERENCES mantenimiento_obra(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra),
    PRIMARY KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, id_historico_mant_re)
);

SET datestyle = 'ISO, MDY';
