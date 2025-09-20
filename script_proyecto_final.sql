USE netflix;

-- PARTE 1
-- 1. ¿Cuántos títulos existen en el catálogo?
SELECT COUNT(show_id) AS cantidadTitulos
FROM shows;
-- 5837

-- 2. ¿Cuántos tipos de contenido diferentes hay registrados (Movie, TV Show, etc.)?
SELECT COUNT(type_id) AS cantidadContenido
FROM ShowType;
-- 2


-- 3. ¿Cuántos países distintos están representados en las producciones?
SELECT COUNT(country_id) AS total_countries
FROM Country;
-- 108


-- 4. ¿Cuántas clasificaciones de edad (rating) diferentes existen?
SELECT COUNT(rating_id) AS total_ratings
FROM Rating;
-- 15

-- PARTE 2
-- 5. ¿Cuál es el país con mayor cantidad de títulos disponibles en el catálogo?
SELECT c.name AS country, COUNT(*) AS total_titulos
FROM show_country sc
INNER JOIN Country c ON sc.country_id = c.country_id
GROUP BY c.name
ORDER BY total_titulos DESC
LIMIT 1;


-- 6. ¿Cuáles son los 5 géneros más frecuentes en el catálogo?

SELECT g.name, COUNT(*) AS total_genero
FROM show_genre sg
INNER JOIN Genre g ON sg.genre_id = g.genre_id
GROUP BY g.name
ORDER BY total_genero DESC
LIMIT 5;


-- 7. ¿Qué clasificación por edad (rating) es la más común en las películas y cuál en las series?

SELECT CASE WHEN st.name = 'Movie' THEN 'Pelicula' ELSE 'Serie' END AS Tipo_contenido,
		r.code AS clasificacion,
		COUNT(s.show_id) AS cantidad
FROM shows s
INNER JOIN Rating r ON s.rating_id = r.rating_id
INNER JOIN ShowType st ON s.type_id = st.type_id 
WHERE st.name IN ('Movie', 'TV Show')
GROUP BY tipo_contenido, clasificacion
ORDER BY tipo_contenido, cantidad DESC;


-- 8. ¿Cómo ha cambiado la duración promedio de las películas a lo largo de los años de lanzamiento?

SELECT s.release_year,
		ROUND(AVG(CAST(REGEXP_SUBSTR(s.duration, '^[0-9]+') AS UNSIGNED))) AS avg_duration
FROM shows s
INNER JOIN ShowType st ON s.type_id = st.type_id
WHERE st.name = 'Movie'
GROUP BY s.release_year
ORDER BY s.release_year;

-- 9. ¿Qué país tiene la mayor diversidad de géneros distintos en su catálogo?

SELECT c.name AS country, 
		COUNT(DISTINCT genre_id) AS genre_count
FROM show_country sc
INNER JOIN Country c ON sc.country_id = c.country_id
INNER JOIN shows s ON sc.show_id = s.show_id
INNER JOIN show_genre sg ON sc.show_id = sg.show_id
GROUP BY c.name
ORDER BY genre_count DESC
LIMIT 1;

-- 10. ¿Cuáles es el título más antiguos disponibles en la plataforma? (Usando subqueries)

SELECT title, release_year
FROM shows
WHERE release_year = (SELECT MIN(release_year)
					  FROM shows);


-- PARTE 3

-- 1. Para la clasificación de edad 'TV-MA' ¿cuáles son los 3 géneros más comunes?
SELECT g.name AS genero,
		COUNT(s.show_id) AS total_titulos
FROM shows AS s
INNER JOIN show_genre AS sg ON s.show_id = sg.show_id
INNER JOIN Genre AS g ON sg.genre_id = g.genre_id
INNER JOIN Rating AS r ON s.rating_id = r.rating_id
WHERE r.code = 'TV-MA'
GROUP BY genero
ORDER BY total_titulos DESC
LIMIT 3;

-- 2. ¿Cuántas TV Show por año se estrenaron durante los utlimos 15 años de menor a mayor?
SELECT s.release_year AS anio,
	COUNT(s.show_id) As contar_peli
FROM shows s 
INNER JOIN ShowType st ON s.type_id = st.type_id
WHERE (st.name = "Movie" AND s.release_year >= YEAR(CURDATE()) - 15)
GROUP BY  s.release_year
ORDER BY s.release_year ASC;


-- 3. ¿Cuáles son los 5 países con más títulos en el catálogo?
SELECT c.name AS pais, COUNT(*) AS total_titulos
FROM show_country sc
INNER JOIN Country c ON sc.country_id = c.country_id
GROUP BY c.name
ORDER BY total_titulos DESC
LIMIT 5;

-- 4. Cual es el año con mayor cantidad de titulos agregados al catalogo

SELECT YEAR(date_added) AS año, COUNT(*) AS cantidad_agregados
FROM shows
GROUP BY año
ORDER BY cantidad_agregados desc
LIMIT 1;



-- 5. Cuáles con las 5 series con mayor número de Temporadas en Netflix y su año de Lanzamiento?				
SELECT title AS titulo, release_year AS año_lanzamiento,
CAST(REGEXP_SUBSTR(duration, '^[0-9]+') AS UNSIGNED) AS numero_temporadas
FROM shows s
INNER JOIN ShowType st ON s.type_id = st.type_id
WHERE st.name = 'TV Show' AND duration REGEXP '^[0-9]+ Season'
ORDER BY numero_temporadas DESC
LIMIT 5;



