--1) Crea el esquema de la BBDD.
--2) Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ
select title as "Titulo_pelicula", rating as "categoria_R" 
from film f ;

--3) Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30 y 40.
select concat(first_name,' ',last_name) as "Actor_Nombre_completo", actor_id 
from actor a
where actor_id between 30 and 40;

--4) Obtén las películas cuyo idioma coincide con el idioma original.
select language_id , original_language_id 
from film f 
where language_id =original_language_id ;
--nota: La columna de original_language_id son todos nulos. Ademas el language_id solamente presenta valores "1". Por lo que no hay resultados.

--5) Ordena las películas por duración de forma ascendente.
select title as "Titulo_pelicula", length as "duracion_pelicula"
from film f
order by length asc ;

--6) Encuentra el nombre y apellido de los actores que tengan ‘Allenʼ en su apellido.
select concat(first_name,' ',last_name) as "Actor_nombre_completo"
from actor a 
where last_name = 'ALLEN';

--7)  Encuentra la cantidad total de películas en cada clasificación de la tabla “filmˮ y muestra la clasificación junto con el recuento.
select c."name" as "Clasificacion", count(fc."film_id")as "Total_peliculas"
from film_category fc 
inner join category c 
on fc.category_id = c.category_id
group by c."name";

--8) Encuentra el título de todas las películas que son ‘PG-13ʼ o tienen una duración mayor a 3 horas en la tabla film.
select title , length as "Duracion", rating as "Categoria_R"
from film f 
where rating = 'PG-13'
or length >180;

--9)Encuentra la variabilidad de lo que costaría reemplazar las películas. 
select variance(replacement_cost) as "variabilidad_reemplazo"
from film f;

--10) Encuentra la mayor y menor duración de una película de nuestra BBDD.
select max(length) as "maxima_duracion", min(length) as "minima_duracion"
from film f ;

--11)  Encuentra lo que costó el antepenúltimo alquiler ordenado por día.  
select r.rental_date as "Fecha_alquiler", p.amount as "Cuantia"
from payment p 
inner join rental r on p.rental_id =r.rental_id
order by r.rental_date desc
limit 1
offset 1;

--12)  Encuentra el título de las películas en la tabla “filmˮ que no sean ni ‘NC-17ʼ ni ‘Gʼ en cuanto a su clasificación.
select title as "Titulo", rating as "Categoria_R" 
from film f 
where rating not in ('NC-17' , 'G');

--13) Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
select rating as "Clasificacion", avg(length) as "Promedio_duracion" 
from film f 
group by rating ;

--14)  Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.
select title as "Titulo"
from film f 
where length >180;

--15)  ¿Cuánto dinero ha generado en total la empresa?
select sum(amount) as "Total_ingresos"
from payment p ;

--16) Muestra los 10 clientes con mayor valor de id.
select customer_id as "10_cliestes_mayor_valorID"
from customer c
order by customer_id desc
limit 10;

--17) Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igbyʼ.
select a.first_name as "Nombre", a.last_name as "Apellido"
from film f
inner join film_actor fa on f.film_id = fa.film_id
inner join actor a on fa.actor_id = a.actor_id
where f.title = 'EGG IGBY';

--18)  Selecciona todos los nombres de las películas únicos.
select distinct title as "Titulos_unicos"
from film f ;

--19) Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “filmˮ.
select f.title as "Titulo" 
from film f 
inner join film_category fc on f.film_id = fc.film_id
inner join category c on fc.category_id =c.category_id 
where c."name" = 'Comedy'
and f.length >180;

--20) Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.
select c."name" as "Categoria", avg( f.length ) as "Promedio_duracion"
from film f 
inner join film_category fc on f.film_id =fc.film_id 
inner join category c on fc.category_id = c.category_id
group by c."name"
having avg(f.length)>110; 

--21)  ¿Cuál es la media de duración del alquiler de las películas?
select avg(rental_duration) as "Media_duracion_alquiler" 
from film f;

--22) Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(first_name, ' ' , last_name) as "Nombre_completo_actores" 
from actor a;

--23) Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select rental_date:: date AS "Dia_alquiler", count(r.rental_id) as "Numero_alquileres"
from rental r
inner join payment p ON r.rental_id =p.rental_id
group by rental_date:: date
order by sum(amount) desc; 

--24) Encuentra las películas con una duración superior al promedio.
select film_id
from film f 
where length > (
      select avg(length) 
      from film f
      );

--25) Averigua el número de alquileres registrados por mes. 
select date_trunc('month', rental_date ) as Meses_año, count(rental_id) as "Numero_alquileres"
from rental r
group by date_trunc('month', rental_date );

--26)  Encuentra el promedio, la desviación estándar y varianza del total pagado.
select avg(amount) as "Promedio_pagado", stddev(amount) as "Desviacion_Estandar_pagado", variance(amount) as "Varianza_pagado"
from payment p ;

--27)  ¿Qué películas se alquilan por encima del precio medio?
select f.film_id
from film f 
inner join inventory i on f.film_id = i.film_id 
inner join rental r on i.inventory_id =r.inventory_id 
inner join payment p on r.rental_id = p.rental_id
where p.amount >(
      select avg(amount)
      from payment
      );

--28) Muestra el id de los actores que hayan participado en más de 40 películas.
select actor_id
from film_actor fa
group by actor_id
having count(film_id)>40; 

--29) Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible.
select f.film_id,count(i.inventory_id) as "Cantidad_disponible"
from film f
left join inventory i on f.film_id =i.film_id
group by f.film_id 
order by film_id asc ;

--30) Obtener los actores y el número de películas en las que ha actuado.
select concat(a.first_name,' ',a.last_name) as "Nombre_completo", count( fa.film_id) as "Numero_peliculas"
from film_actor fa
inner join actor a on fa.actor_id = a.actor_id
group by concat(a.first_name,' ', a.last_name) ;

--31) Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados.
select f.film_id, fa.actor_id 
from film f 
left join film_actor fa ON f.film_id =fa.film_id 
order by film_id asc;

--32) Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película.
select a.actor_id , fa.film_id
from actor a
left join film_actor fa on a.actor_id = fa.actor_id;

--33) Obtener todas las películas que tenemos y todos los registros de alquiler.
select f.film_id , r.rental_id
from film f
left join inventory i on f.film_id = i.film_id 
left join rental r on i.inventory_id =r.inventory_id
order by f.film_id; 

--34)  Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select c.customer_id
from customer c 
left join payment p on c.customer_id =p.customer_id 
group by c.customer_id 
order by sum(p.amount) desc
limit 5;

--35)  Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select actor_id
from actor a 
where first_name = 'JOHNNY';

--36) Renombra la columna “first_nameˮ como Nombre y “last_nameˮ como Apellido.
select first_name as "Nombre", last_name as "Apellido"
from actor a ;

--37)  Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min( a.actor_id) as "Minimo_actorId", max(a.actor_id) as "Maximo_atorId"
from actor a;

--38) Cuenta cuántos actores hay en la tabla “actorˮ.
select count(a.actor_id) as "Num_total_actores" 
from actor a;

--39) Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select a.actor_id , last_name as "Apellido"
from actor a
order by "Apellido" ;

--40) elecciona las primeras 5 películas de la tabla “filmˮ.
select film_id , title as "Titulo"
from film f
order by film_id asc 
limit 5;

--41) Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?	
select first_name , count(actor_id) as Numero_actores 
from actor a 
group by first_name
order by Numero_actores desc ;

--42)  Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r.rental_id , concat(c.first_name,' ', c.last_name) as "nombres_completos_clientes"
from rental r
left join customer c on r.customer_id =c.customer_id;

--43) Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres.
select c.customer_id , r.rental_id
from customer c 
left join rental r on c.customer_id =r.customer_id
order by c.customer_id ;

--44)   Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor   esta consulta? ¿Por qué? Deja después de la consulta la contestación.
select *
from film f 
cross join category c; 

/**Nota: No aporta valor ya que introduce combinaciones que no tienen relevancia o sentido. 
Como por ejemplo un mismo titulo tendra asociadas distintas categorias "Accion", "Animacion","Comedia",.. lo cual no tiene ninguna logica. 
Un mismo titulo solo puede corresponderse a una categoria.**/

--45)  Encuentra los actores que han participado en películas de la categoría 'Action'.
select fa.actor_id , c."name" 
from film_actor fa 
left join film f on fa.film_id =f.film_id
left join film_category fc on f.film_id =fc.film_id
left join category c on fc.category_id =c.category_id
where c."name" ='Action';

--46) Encuentra todos los actores que no han participado en películas.         
select a.actor_id , fa.film_id 
from actor a
left join film_actor fa on a.actor_id =fa.actor_id
where fa.film_id is null;
--nota: no hay actores que no participaran en peliculas.

--47) Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select concat(a.first_name,' ',a.last_name) as Actor_nombre_completo , count(fa.film_id) as Numero_peliculas
from actor a 
left join film_actor fa on a.actor_id =fa.actor_id
group by concat(a.first_name,' ',a.last_name) ;

--48) Crea una vista llamada “actor_num_peliculasˮ que muestre los nombres de los actores y el número de películas en las que han participado.
create view actor_num_peliculas as
select concat(a.first_name,' ',a.last_name) as "Actor_nombnre_completo" , count(fa.film_id) as numero_peliculas
from actor a
left join film_actor fa on a.actor_id=fa.actor_id
group by concat(a.first_name,' ',a.last_name) ;

--49) Calcula el número total de alquileres realizados por cada cliente.
select customer_id, count(rental_id) as "Num_alquileres"
from rental r 
group by customer_id;

--50) Calcula la duración total de las películas en la categoría 'Action'

--Si se refiere a la duracion total de las peliculas globalmente:
select sum(f.length) as "Duracion_Total"
from film f 
inner join film_category fc on f.film_id =fc.film_id 
inner join category c on fc.category_id =c.category_id 
group by c."name"
having c."name" = 'Action';

--Si se refiere a la duracion individual de las peliculas:
select f.film_id ,f.length as "Duracion"
from film f 
inner join film_category fc on f.film_id =fc.film_id 
inner join category c on fc.category_id =c.category_id 
where c."name" = 'Action';

--51) Crea una tabla temporal llamada “cliente_rentas_temporalˮ para almacenar el total de alquileres por cliente.
create temporary table cliente_rentas_temporal As
select customer_id , count(rental_id) as "Numero_alquileres "
from rental
group by customer_id;

--52) Crea una tabla temporal llamada “peliculas_alquiladasˮ que almacene las películas que han sido alquiladas al menos 10 veces.
create temporary table peliculas_alquiladas
select i.film_id , count(r.rental_id) as "Veces_alquilada"
from inventory i
inner join rental r on i.inventory_id =r.inventory_id
group by film_id
having count(r.rental_id) >=10;

/**53) Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sandersʼ y que aún no se han devuelto. 
Ordena los resultados alfabéticamente por título de película**/
select f.title as "Titulo"
from rental r 
inner join customer c on r.customer_id =c.customer_id 
inner join inventory i on r.inventory_id =i.inventory_id 
inner join film f on i.film_id =f.film_id 
where concat(c.first_name,' ',c.last_name) = 'TAMMY SANDERS'
and r.return_date is null 
order by f.title asc ;

/**54) Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fiʼ.
Ordena los resultados alfabéticamente por apellido.**/
select concat(a.last_name, ' ', a.first_name) as "Nombres_completos_actores"
from actor a 
inner join film_actor fa on a.actor_id=fa.actor_id 
inner join film f on fa.film_id =f.film_id 
inner join film_category fc on f.film_id =fc.film_id 
inner join category c on fc.category_id = c.category_id
where c."name" = 'Sci-Fi'
order by a.last_name ;                                                    

/**55) Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaperʼ se alquilara por primera vez.
Ordena los resultados alfabéticamente por apellido.**/
select concat(a.first_name, ' ' ,a.last_name) as "Nombres_completos_actores"
from rental r 
inner join inventory i2 on r.inventory_id =i2.inventory_id 
inner join film f2 on i2.film_id =f2.film_id 
inner join film_actor fa on f2.film_id =fa.film_id 
inner join actor a on fa.actor_id =a.actor_id 
where rental_date > (

                    select r.rental_date 
                    from film f 
                    inner join inventory i on f.film_id=i.film_id 
                    inner join rental r on i.inventory_id =r.inventory_id 
                    where f.title = 'SPARTACUS CHEAPER'
                    order by r.rental_date asc
                    limit 1);

--56) Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Musicʼ.
select distinct (concat(a.first_name,' ',a.last_name)) as "Actor"
from actor a 
left join film_actor fa on a.actor_id=fa.actor_id  
left join film f on fa.film_id =f.film_id 
left join film_category fc on f.film_id =fc.film_id 
left join category c on fc.category_id =c.category_id 
where c."name" <> 'Music';

--57) Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select  f.title as "Titulo"
from rental r 
inner join inventory i on r.inventory_id =i.inventory_id
inner join film f on i.film_id =f.film_id 
where extract (day from (r.return_date - r.rental_date))>8;

--58) Encuentra el título de todas las películas que son de la misma categoría que ‘Animationʼ
select title as "Titulo"
from film f 
inner join film_category fc on f.film_id=fc.film_id 
inner join category c on fc.category_id =c.category_id
where c."name" = 'Animation';

/**59)  Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Feverʼ. 
Ordena los resultados alfabéticamente por título de película.**/
select title as "Titulo"
from film f 
where length = (
     select length 
     from film f2 
     where title = 'DANCING FEVER'
     )
order by TITLE asc ;

--60) Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido.
select concat (c.last_name,' ',c.first_name) as "Nombre_cliente", count(distinct i.film_id) as "Num_pelic_distintas"
from customer c 
inner join rental r on c.customer_id =r.customer_id
inner join inventory i on r.inventory_id=i.inventory_id
group by c.customer_id
having count(distinct i.film_id)>7
order by "Nombre_cliente" asc;

--61)  Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
select c."name" as "categoria", count(r.rental_id) as "Num_alquileres" 
from category c 
inner join film_category fc on c.category_id =fc.category_id 
inner join film f on fc.film_id =f.film_id 
inner join inventory i on f.film_id =i.film_id 
inner join rental r on i.inventory_id =r.inventory_id 
group by c.name;

--62) Encuentra el número de películas por categoría estrenadas en 2006.
select c."name" as "Categoria" , count(f.film_id) as "Num_pelic_2006"
from category c 
inner join film_category fc on c.category_id=fc.category_id 
inner join film f on fc.film_id =f.film_id 
where f.release_year = '2006'
group by c."name";

--63) Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s.staff_id , s2.store_id 
from staff s 
cross join store s2;

--64)  Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c.customer_id, concat(c.first_name, ' ' ,c.last_name) as "Cliente_nombre_compl", count(r.rental_id) as "Pelic_alquil"
from customer c 
inner join rental r on c.customer_id =r.customer_id 
group by c.customer_id;








