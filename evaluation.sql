DESCRIBE `biblio`.`oeuvres`;

SELECT COLUMN_NAME AS PRIMARY_KEY
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = 'biblio'
AND TABLE_NAME = '<livres>' -- Nom de la tables
AND COLUMN_KEY = 'PRI';


SELECT * FROM biblio.adherents , biblio.emprunter WHERE emprunter.NA=adherents.NA;


SELECT * FROM biblio.livres, biblio.oeuvres, biblio.adherents, biblio.emprunter WHERE nom='Lecoeur' and prenom='Jeanette';
SELECT * FROM biblio.livres, biblio.oeuvres, biblio.adherents, biblio.emprunter WHERE prenom='Lecoeur' and nom='Jeanette';

select nom from biblio.emprunter, biblio.adherents 
	where emprunter.NA=adherents.NA and adherents.nom='Lecoeur'
    and adherents.nom = 'Jeannette';


SELECT * FROM biblio.emprunter, biblio.livres where dateRet IS NULL AND emprunter.NL=livres.NL; 

/* question 2 */
SELECT editeur FROM biblio.livres WHERE livres.NL IN
        (SELECT NL FROM biblio.emprunter WHERE NA =
            (SELECT NA FROM biblio.adherents WHERE prenom='Jeannette') );
 
 /*question 3 */
 SELECT editeur FROM biblio.emprunter, biblio.livres where dateEmp like '2009-06-%' AND emprunter.NL=livres.NL;
 
 /*question 12 */
SELECT nom from biblio.adherents where NA IN
	( SELECT NA from biblio.emprunter where NL IN 
		(SELECT NL FROM biblio.livres where id_o IN
			( SELECT id_o FROM biblio.oeuvres  where auteur ='Fedor DOSTOIEVSKI')));
            
/* question 13 */
INSERT INTO `biblio`.`adherents` (`NA`, `nom`, `prenom`, `adr`, `tel`)
 VALUES ('31', 'Olivier', 'Dupond', '76 quai de la Loire,75019 Paris', '0102030405');
 
 /* question 14 */
 
INSERT INTO `biblio`.`emprunter` (`NL`, `dateEmp`, `dureeMax`, `NA`) VALUES ('23', '2022-06-28', '14', '7');
INSERT INTO `biblio`.`emprunter` (`NL`, `dateEmp`, `dureeMax`, `NA`) VALUES ('31', '2022-06-28', '14', '7');

/*question 15 */
UPDATE `biblio`.`emprunter` SET `dateRet` = '2022-06-28' WHERE (`NL` = '9') and (`dateEmp` = '2022-06-17');

/*question 16*/
INSERT INTO `biblio`.`emprunter` (`NL`, `dateEmp`, `dureeMax`, `NA`) VALUES ('23', '2022-06-26', '14', '28'); /* la requête se passe sans problem */

/*question 17 */

INSERT INTO `biblio`.`emprunter` (`NL`, `dateEmp`, `dureeMax`, `NA`) VALUES ('29', '2022-06-26', '21', '28'); /* la requête se passe sans problem */

/*question 18 */
select auteur from biblio.oeuvres where titre ='Voyage au bout de la nuit';

/*question 19 */

select editeur from  biblio.livres where NL IN
(select id_o from biblio.oeuvres where titre ='Narcisse et Goldmund');

SELECT editeur from biblio.livres, biblio.oeuvres where livres.NL = oeuvres.id_o and titre ='Narcisse et Goldmund';

/* question 20 */

select nom from biblio.adherents, biblio.emprunter where adherents.NA =emprunter.NA and dateRet is null;

/* question 21 */

select titre from biblio.titre, biblio.emprunter where adherents.NA =emprunter.NA and dateRet is null;

select titre from biblio.oeuvres where id_o IN 
	( select id_o from biblio.livres where NL in
		(select NL from biblio.emprunter where dateRet is null ));

/* question 22 */
SELECT adherents.NA , prenom, nom ,count(emprunter.NL) as 'nombre de livres  
en retard', AVG((to_days(current_date())-to_days(date_add(dateEmp,INTERVAL + dureeMax DAY ))))AS 'Moyenne du nombre de hour de reatrd'
FROM biblio.adherents,biblio.livres, biblio.emprunter   WHERE dateRet IS NULL AND emprunter.NA = adherents.NA AND datediff(NOW(), DATE_ADD(dateEmp, INTERVAL dureeMax day)) > dureeMax
GROUP BY NA;

/* question 23 */
 SELECT auteur, count(livres.NL) AS 'Nb de livres empruntés' FROM biblio.livres, biblio.oeuvres, biblio.emprunter
WHERE livres.id_o = oeuvres.id_o AND livres.NL = emprunter.NL group by auteur;

/* question 24 */
select editeur, count(dateEmp) as 'nombre_editeur'  FROM 
biblio.livres, biblio.emprunter where livres.NL = emprunter.NL group by editeur order by count(dateEmp) desc;

/* 25*/

SELECT dateEmp,dateRet,dateRet-dateEmp AS Duree,NL
From biblio.emprunter
WHERE dateRet IS NOT NULL ORDER BY Duree;

/*26 */

SELECT ROUND(AVG(CASE
WHEN dateRet IS NULL THEN
CURRENT_DATE() - dateEmp
ELSE dateRet - dateEmp
END)) AS Duree_retard
FROM biblio.emprunter
WHERE ((CASE
WHEN dateRet IS NULL THEN CURRENT_DATE() - dateEmp
ELSE dateRet - dateEmp
END) > dureeMax
OR (dateRet - dateEmp) <= dureeMax) and (dateRet - dateEmp)>=0;

/*27*/
SELECT ROUND(AVG(CASE
WHEN dateRet IS NULL THEN
CURRENT_DATE() - dateEmp
ELSE dateRet - dateEmp
END)) AS Duree_retard
FROM emprunter
WHERE (CASE
WHEN dateRet IS NULL THEN CURRENT_DATE() - dateEmp
ELSE dateRet - dateEmp
END) > dureeMax and (dateRet - dateEmp)>=0;

