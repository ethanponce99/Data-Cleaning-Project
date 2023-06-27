SELECT * FROM audible;

-- Mantener el texto despues del delimitador ':' para columnas author y narrator

SELECT author
FROM audible
WHERE author LIKE '%.%';

SELECT SUBSTRING(author,(CHARINDEX(':',author)+1),LEN(author))
FROM audible;

UPDATE audible
SET author = SUBSTRING(author,(CHARINDEX(':',author)+1),LEN(author));

SELECT narrator
FROM audible
WHERE narrator LIKE '%.%';

-- Tampoco se puede utilizar PARSENAME junto a REPLACE aqui porque hay nombres con '.'

SELECT SUBSTRING(narrator,(CHARINDEX(':',narrator)+1),LEN(narrator))
FROM audible;

UPDATE audible
SET narrator = SUBSTRING(narrator,(CHARINDEX(':',narrator)+1),LEN(narrator));


-- Estandarizar texto en columna language, haciendo que el texto comience con mayuscula y el resto sea minuscula

SELECT UPPER(LEFT(language,1))+LOWER(SUBSTRING(language,2,LEN(language)))
FROM audible;

UPDATE audible
SET language = UPPER(LEFT(language,1))+LOWER(SUBSTRING(language,2,LEN(language)));


-- Separar rating desde la columna star y hacer su propia columna

SELECT stars
FROM audible
WHERE stars LIKE '%ratings' OR stars LIKE '%rating';

SELECT SUBSTRING(stars,(CHARINDEX('s',stars)+5),LEN(stars))
FROM audible
WHERE stars LIKE '%ratings' OR stars LIKE '%rating';

SELECT SUBSTRING(stars,(CHARINDEX('s',stars)+5),LEN(stars))
FROM audible

ALTER TABLE audible
ADD ratings nvarchar(50) null;

UPDATE audible
SET ratings = SUBSTRING(stars,(CHARINDEX('s',stars)+5),LEN(stars));

-- Transformar texto en nulls para luego transformarlos en 0's

SELECT ratings, 
	CASE 
	WHEN ratings LIKE 'rated yet' THEN null
	ELSE ratings  
	END
FROM audible
ORDER BY 2 DESC;

UPDATE audible
SET ratings = CASE 
	WHEN ratings LIKE 'rated yet' THEN null
	ELSE ratings  
	END;

-- Transformar nulls en 0

SELECT ISNULL(ratings, 0)
FROM audible;

UPDATE audible
SET ratings = ISNULL(ratings, 0);

-- Dejar solo el numero de ratings, sin texto.

SELECT ratings,
       SUBSTRING(ratings,PATINDEX('%[0-9]%', ratings), 1+PATINDEX('%[0-9][^0-9]%', ratings)) AS cantidad_ratings
FROM audible
GROUP BY ratings;

-- Query funciona pero hay numeros que tienen '.', reemplazarlos por ''

SELECT ratings, REPLACE(ratings,',','') 
FROM audible
GROUP BY ratings;

UPDATE audible
SET ratings = REPLACE(ratings,',','');


-- Continuacion paso anterior de mantener solo numero de ratings sin texto

UPDATE audible
SET ratings = SUBSTRING(ratings,PATINDEX('%[0-9]%', ratings), 1+PATINDEX('%[0-9][^0-9]%', ratings));


-- Mantener solamente la cantidad de estrellas 

SELECT LEFT(stars, CHARINDEX(' ', stars)-1)
FROM audible;

UPDATE audible
SET stars = LEFT(stars, CHARINDEX(' ', stars)-1)

-- Reemplazar texto restante por nulls para luego cambiarlos por 0's

UPDATE audible
SET stars = CASE
			WHEN stars LIKE 'Not' THEN null
			ELSE stars
	        END;

UPDATE audible
SET stars = ISNULL(stars,0);

-- Cambiar tipo de data de la columna a decimal para hacer calculos posteriormente

ALTER TABLE audible
ALTER COLUMN stars decimal;


-- Estandarizar columna time, dejar todo en minutos
-- Primero crear columna para contener solo las horas, int para hacer calculos posteriormente

SELECT time,
       SUBSTRING(time,PATINDEX('%[0-9]%', time), 1+PATINDEX('%[0-9][^0-9]%', time)) AS horas
FROM audible
WHERE time LIKE '%hr%'
GROUP BY time;

ALTER TABLE audible
ADD time_horas int;

UPDATE audible
SET time_horas = SUBSTRING(time,PATINDEX('%[0-9]%', time), 1+PATINDEX('%[0-9][^0-9]%', time)) WHERE time LIKE '%hr%';

UPDATE audible
SET time_horas = ISNULL(time_horas, 0)


-- Crear columna para contener los minutos

ALTER TABLE audible
ADD time_minutos nvarchar(255)

SELECT RIGHT(time, 8)
FROM audible
WHERE time LIKE '%min%'

UPDATE audible
SET time_minutos = RIGHT(time, 8) WHERE time LIKE '%min%';

-- Primera limpieza columna time_minutos

SELECT time_minutos, SUBSTRING(time_minutos,PATINDEX('%[0-9]%', time_minutos),PATINDEX('%[0-9][^0-9]%', time_minutos)) AS minutos 
FROM audible
GROUP BY time_minutos;

UPDATE audible
SET time_minutos = SUBSTRING(time_minutos,PATINDEX('%[0-9]%', time_minutos),PATINDEX('%[0-9][^0-9]%', time_minutos));

-- Segunda limpieza columna time_minutos, para dejar solo numero

SELECT time, time_minutos, SUBSTRING(time_minutos,PATINDEX('%[0-9]%', time_minutos),2)
FROM audible
ORDER BY 3 DESC;

UPDATE audible
SET time_minutos = SUBSTRING(time_minutos,PATINDEX('%[0-9]%', time_minutos),2);

ALTER TABLE audible
ALTER COLUMN time_minutos int;

-- Crear columna para total de minutos

ALTER TABLE audible
ADD total_minutos int;

SELECT time_horas, time_minutos, (time_horas*60) as minutos_por_horas ,((time_horas*60)+(time_minutos)) AS minutos
FROM audible;

UPDATE audible
SET total_minutos = ((time_horas*60)+(time_minutos));

-- Termino limpieza de set de datos audible

