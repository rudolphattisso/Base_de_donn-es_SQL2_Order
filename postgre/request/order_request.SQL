--A correspond la table « order_line » ?  
cela correspond à un tableau  d article et leurs infos (prix, quantité ect).

-- A quoi sert la colonne « order_id » ? 
cela correspond au numero de commnande.

--1 Récupérer l’utilisateur ayant le prénom “Muriel” et le mot de passe “test11”, sachant 
que l’encodage du mot de passe est effectué avec l’algorithme Sha1.
where first_name like 'Muriel' and password = encode(digest('test11', 'sha1'),'hex')


--2. Récupérer la liste de tous les produits qui sont présents sur plusieurs commandes.
