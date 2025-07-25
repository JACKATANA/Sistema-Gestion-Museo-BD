# Proyecto de Base de Datos: Sistema de Gestión de Museo

Este repositorio contiene la implementación de una base de datos para un sistema de gestión de museo, desarrollado como parte de la asignatura "Sistema de Base de Datos" en la Universidad Católica Andrés Bello, bajo la tutela de la Profesora Lucía Cardoso.

## Descripción del Proyecto

El objetivo de este proyecto es diseñar e implementar una base de datos relacional robusta y eficiente para la administración integral de un museo. Esto incluye la gestión de obras de arte, artistas, colecciones, empleados, eventos, tickets, mantenimiento y la estructura organizacional y física del museo. El sistema busca optimizar las operaciones diarias y facilitar la generación de informes clave para la toma de decisiones.

## Tecnologías Utilizadas

* **Sistema de Gestión de Base de Datos (SGBD):** PostgreSQL

## Estructura del Repositorio

El repositorio se organiza en archivos SQL, cada uno con una función específica dentro del ciclo de vida y operación de la base de datos:

* `scripts - create tables.sql`: Este script contiene todas las sentencias `CREATE TABLE` y `CREATE SEQUENCE` necesarias para construir el esquema completo de la base de datos. Define las tablas, sus columnas, tipos de datos, claves primarias, claves foráneas y las restricciones de integridad correspondientes.
* `scripts - drop database.sql`: Contiene sentencias `DROP TABLE` en el orden inverso de dependencia para eliminar todas las tablas y secuencias de la base de datos de manera limpia. Es útil para reinicializar el entorno o para propósitos de desarrollo y prueba.
* `scripts-selects reportes.sql`: Incluye diversas consultas `SELECT` diseñadas para generar informes y extraer información relevante del sistema. Entre los reportes disponibles se encuentran fichas de artistas, fichas de obras (esculturas y pinturas), itinerarios de obras destacadas y fichas de itinerarios de colecciones.
* `scripts-triggers-funciones-precedimientos.sql`: Este archivo alberga la lógica de negocio implementada a través de triggers, funciones y procedimientos almacenados en PostgreSQL. Estos elementos aseguran la integridad de los datos, automatizan procesos y validan operaciones específicas (ej. validación de fechas en movimientos de obras, reordenamiento de elementos).
* `DEFENSA 2.sql`: Contiene la definición de roles y la asignación de permisos específicos para diferentes tipos de usuarios (curador, restaurador, director, mantenimiento/vigilancia, administrador de RRHH). También incluye una función para calcular los ingresos totales por tickets de un museo.

## Cómo Ejecutar el Proyecto

Para poner en marcha la base de datos y explorar su funcionalidad, siga los pasos a continuación:

### Prerrequisitos

Asegúrese de tener instalado **PostgreSQL** en su sistema. Puede descargarlo desde el [sitio oficial de PostgreSQL](https://www.postgresql.org/download/).

### Pasos de Ejecución

1.  **Crear una Base de Datos en PostgreSQL:**
    Primero, conéctese a su servidor PostgreSQL (por ejemplo, a través de `psql` o pgAdmin) y cree una nueva base de datos para el proyecto. Puede usar un comando similar a este:

    ```sql
    CREATE DATABASE museo_db;
    ```

    Donde `museo_db` es el nombre que le asignará a su base de datos.

2.  **Conectarse a la Nueva Base de Datos:**
    Una vez creada, conéctese a esta nueva base de datos.

3.  **Ejecutar los Scripts SQL en Orden:**
    Es crucial ejecutar los scripts en el orden correcto para asegurar que todas las dependencias se satisfagan. Puede ejecutar estos scripts desde su cliente PostgreSQL (pgAdmin, DBeaver, psql, etc.).

    * **Creación de Tablas y Secuencias:**
        Ejecute el script que define el esquema de la base de datos. Este script crea todas las tablas y secuencias necesarias.

        ```sql
        \i 'ruta/a/scripts - create tables.sql'
        ```

    * **Triggers, Funciones y Procedimientos Almacenados:**
        Una vez que las tablas están creadas, ejecute este script para definir la lógica de negocio, incluyendo validaciones y automatizaciones.

        ```sql
        \i 'ruta/a/scripts-triggers-funciones-precedimientos.sql'
        ```

    * **Roles, Permisos y Funciones Adicionales:**
        Este script establece los roles de usuario, sus permisos y funciones adicionales como el cálculo de ingresos por tickets.

        ```sql
        \i 'ruta/a/DEFENSA 2.sql'
        ```

    * **Consultas para Reportes:**
        Este script contiene ejemplos de consultas para generar diversos informes. Puede ejecutar estas consultas individualmente según sus necesidades para extraer información del sistema.

        ```sql
        \i 'ruta/a/scripts-selects reportes.sql'
        ```

    * **Opcional: Limpiar la Base de Datos:**
        Si en algún momento necesita resetear la base de datos (por ejemplo, para realizar pruebas limpias), puede ejecutar el script de eliminación de tablas. **¡ADVERTENCIA: Esto borrará todos los datos!**

        ```sql
        \i 'ruta/a/scripts - drop database.sql'
        ```

    **Nota:** Reemplace `ruta/a/nombre_del_archivo.sql` con la ruta real de los archivos en su sistema.

## Roles y Permisos

El proyecto incluye la definición de roles específicos para manejar el acceso y las operaciones dentro de la base de datos, garantizando la seguridad y la separación de responsabilidades:

* **`rol_curador`**: Permisos para gestionar el histórico de movimientos de obras y las relaciones entre colecciones y salas.
* **`rol_restaurador`**: Permisos para registrar mantenimientos de obras.
* **`rol_director`**: Acceso para gestionar eventos, tickets y la estructura organizacional.
* **`rol_mantenimiento_vigilancia`**: Permisos para la gestión de asignaciones mensuales y consulta de información de empleados y estructuras físicas.
* **`rol_administrador_rrhh`**: Control total sobre la información de empleados, su formación, idiomas y asignaciones.

Además, se incluyen ejemplos de creación de usuarios y asignación de estos roles para facilitar la configuración inicial.

## Reportes Generados

El sistema está diseñado para generar varios reportes importantes que facilitan la gestión del museo, entre ellos:

* **Ficha de Artista**: Detalle completo de un artista, incluyendo sus obras, dimensiones, estilos y colecciones a las que pertenecen.
* **Ficha de Escultura y Pintura**: Información específica sobre obras de arte, diferenciando entre esculturas y pinturas.
* **Ficha de Itinerario de Obras Destacadas**: Muestra el recorrido y la ubicación actual de obras consideradas destacadas.
* **Ficha de Itinerario de Colecciones**: Detalla el orden de recorrido de las colecciones permanentes y las salas en las que se exhiben.
* **Ingresos por Tickets**: Permite consultar las ganancias totales por tickets para un museo específico.
