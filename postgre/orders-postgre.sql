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

--mise à jour de la case total_price_cache(à corriger)
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



select extract(month from co.purchase_date)  
from customer_order co 








