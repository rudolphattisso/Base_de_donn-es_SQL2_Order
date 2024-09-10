--1 Récupérer l’utilisateur ayant le prénom “Muriel” et le mot de passe “test11”, sachant 
select * from client 
where first_name like 'Muriel' and password = encode(digest('test11', 'sha1'),'hex');

--2. Récupérer la liste de tous les produits qui sont présents sur plusieurs commandes.
select last_name , count(*) as nb_occurence
from order_line 
group by last_name 
having count(* )>1 ;

--3 Enregistrer le prix total à l’intérieur de chaque ligne des commandes, en fonction du 
--prix unitaire et de la quantité (il vous faudra utiliser une requête de mise à jour d’une 
--table : « UPDATE TABLE »

update order_line 
set total_price = (unit_price * quantity);
--après le résultat cliquer sur regénerer pour actualiser le tableau.

--4-Récupérer le montant total pour chaque commande et afficher la date de commande ainsi que
-- le nom et le prénom du client

select ol.order_id, sum(ol.total_price),
co.purchase_date, c.last_name, c.first_name 
from order_line ol 
join customer_order co on ol.order_id = co.id 
join client c on c.id = co.id 
group by ol.order_id, co.purchase_date , c.last_name ,c.first_name ;

--5. mise à jour de la case total_price_cache(à corriger)
update
	customer_order co
set
	total_price_cache = (
	select
		sum(ol.total_price)
	from
		order_line ol
	join customer_order co2 on
		ol.order_id = co2.id
	join client c on
		c.id = co2.client_id
	where
		co.id = ol.order_id
	group by
		ol.order_id);

-- 5. Récupérer le montant global de toutes les commandes, pour chaque mois.
select extract(month  from co.purchase_date) as "month", sum(co.total_price_cache)
from customer_order co 
group by "month";

--6. Récupérer la liste des 10 clients qui ont effectué le plus grand montant 
--de commandes, et obtenir ce montant total pour chaque client.

select co.client_id, sum(co.total_price_cache) as total_per_client
from customer_order co 
group by co.client_id 
order by co.client_id asc
limit 10;

--7. Récupérer le montant total des commandes pour chaque jour.
select extract(day  from co.purchase_date) as "day", sum(co.total_price_cache) as total_per_client
from customer_order co 
group by "day"
order by "day" asc ;

--8. Ajouter une colonne intitulée “category” à la table contenant les commandes. 
--Cette colonne contiendra une valeur numérique (il faudra utiliser « ALTER TABLE », 
--https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-add-column/)
alter table customer_order 
add column category INT default 0;

--9. Enregistrer la valeur de la catégorie, en suivant les règles suivantes :
--“1” pour les commandes de moins de 200€
--“2” pour les commandes entre 200€ et 500€
--“3” pour les commandes entre 500€ et 1.000€
--“4” pour les commandes supérieures à 1.000€

update 
customer_order 
set
category = case  
when  total_price_cache<200 then 1
when  total_price_cache<500 then 2
when  total_price_cache<1000 then 3
when  total_price_cache>1000 then 4
end
; 

--cas avec le total par commande et client
with totals as (select o.order_id, sum(o.total_price) as order_sum
from order_line o
group by o.order_id)
update customer_order co
set category = case
when totals.order_sum <200 then 1
end 
from totals
where co.id = totals.order_id