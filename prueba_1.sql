-- Abrir la terminal
psql "port=5432 dbname=postgres user=postgres password=postgres";

-- Crear la base de datos dondde estarán las tablas del desafío
create database pruebasql_claudia_leiva123;

-- 01.- Crea el modelo, respeta las claves primarias, foráneas y tipos de datos.
-- 01.- Crear tabla Peliculas
CREATE TABLE IF NOT EXISTS peliculas(
    id Integer,
    anno Integer,
    nombre VARCHAR(255),
    PRIMARY KEY ("id")
);

-- 01.- Crear tabla tags
CREATE TABLE IF NOT EXISTS tags(id Integer, tag VARCHAR(32),
    PRIMARY KEY ("id"));

-- 01.- Crear tabla Peliculas Tags
CREATE TABLE "peliculas_tags" (
    "pelicula_id" Integer,
    "tag_id" Integer,
    FOREIGN KEY ("pelicula_id") REFERENCES "peliculas"("id"),
    FOREIGN KEY ("tag_id") REFERENCES "tags"("id")
);
-- 02.- Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la segunda película debe tener dos tags asociados.
-- 02.- Insertar datos tabla tags
INSERT INTO tags (id, tag) VALUES 
(1,'Horror'),
(2,'Comedia'),
(3,'Drama'),
(4,'Animacion'),
(5,'Documental');

-- 02.- Insertar datos tabla Peliculas
INSERT INTO peliculas (id, anno, nombre) VALUES 
(1,2002,'Blade Runner'),
(2,2015,'Dunne'),
(3,1984,'Jojo Rabbit'),
(4,1990,'Pulp Fiction'),
(5,2023,'Titanic');

-- 02.- Insertar datos tabla Peliculas Tags
INSERT INTO peliculas_tags ("pelicula_id", "tag_id") VALUES 
(1, 1),
(1, 2),
(1, 3),
(2, 1),
(2, 2);

-- 03.- Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe mostrar 0
select peliculas.nombre, count(peliculas_tags.pelicula_id) as "total_tags" from peliculas
left join peliculas_tags on peliculas_tags.pelicula_id = peliculas.id
group by peliculas.id, peliculas.nombre
order by "total_tags" desc;


-- Modelo 2
-- 04.- Crear tabla preguntas
CREATE TABLE IF NOT EXISTS preguntas(
    id Integer,
    respuesta_correcta VARCHAR,
    pregunta VARCHAR(255),
    PRIMARY KEY ("id")
);

-- 04.- Crear tabla usuarios
CREATE TABLE IF NOT EXISTS usuarios(
    id Integer,
    nombre VARCHAR(255),
    edad Integer,
    PRIMARY KEY ("id")
);

-- 04.- Crear tabla respuestas
CREATE TABLE respuestas (
    id Integer,
    respuesta VARCHAR(255),
    "usuario_id" Integer,
    "pregunta_id" Integer,
    FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id"),
    FOREIGN KEY ("pregunta_id") REFERENCES "preguntas"("id"),
    PRIMARY KEY ("id")
);

-- 05.- Insertar datos a tabla preguntas
INSERT INTO
    preguntas (id, respuesta_correcta, pregunta)
VALUES
    (1, 'pez', '¿Pregunta 1?'),
    (2, 'perro', '¿Pregunta 2?'),
    (3, 'hormiga', '¿Pregunta 3?'),
    (4, 'ballena', '¿Pregunta 4?'),
    (5, 'elefante', '¿Pregunta 5?');

-- 05.- Insertar datos a tabla usuarios
INSERT INTO
    usuarios (id, edad, nombre)
VALUES
    (1, 20, 'Claudia'),
    (2, 30, 'Luis'),
    (3, 35, 'Ignacio'),
    (4, 22, 'Ana'),
    (5, 26, 'Sergio');

-- 05.- Insertar datos a tabla respuestas
INSERT INTO
    respuestas (id, respuesta, usuario_id, pregunta_id)
VALUES
    (1, 'pez', 1, 1),
    (2, 'pez', 3, 1),
    (3, 'perro', 4, 2),
    (4, 'gato', 2, 2),
    (5, 'pato', 1, 2);

-- 06.- Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la pregunta)
select
    count(r.correcta) as correctas,
    usuarios.nombre
from
    usuarios
    left join (
        select
            respuestas.respuesta = preguntas.respuesta_correcta as correcta,
            respuestas.usuario_id
        from
            respuestas
            left join preguntas ON preguntas.id = respuestas.pregunta_id
    ) r on r.usuario_id = usuarios.id
    and r.correcta = true
group by
    usuarios.nombre,
    usuarios.id
order by
    correctas desc;

-- 07.- Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la respuesta correcta
select
    r.pregunta_id,
    r.pregunta,
    sum(r.correctas) as correctas
from
    (
        select
            preguntas.id as pregunta_id,
            preguntas.pregunta,
            (
                not(
                    preguntas.respuesta_correcta = respuestas.respuesta IS NOT true
                )
            ) :: int as correctas
        from
            preguntas
            left join respuestas on preguntas.id = respuestas.pregunta_id
    ) r
group by
    r.pregunta_id,
    r.pregunta
order by
    correctas desc;

-- 08.- Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el primer usuario para probar la implementación
ALTER TABLE
    respuestas DROP CONSTRAINT respuestas_usuario_id_fkey,
ADD
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id) ON DELETE CASCADE;

DELETE FROM
    usuarios
where
    usuarios.id = 1;

select
    *
from
    respuestas;

-- 09.- Crea una restricción que impida insertar usuarios menores de 18 años en la base de datos
ALTER TABLE
    usuarios
ADD
    CONSTRAINT usuarios_edad__18 CHECK (edad >= 18);

 -- 10.- Altera la tabla existente de usuarios agregando el campo email con la restricción de único
ALTER TABLE
    usuarios
ADD
    email VARCHAR;

ALTER TABLE
    usuarios
ADD
    UNIQUE(email);

\q

Link YouTube 