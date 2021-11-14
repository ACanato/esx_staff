USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES 
	('society_staff','staff',1)
;

INSERT INTO `datastore` (name, label, shared) VALUES 
	('society_staff','staff',1)
;

INSERT INTO `jobs` (name, label) VALUES 
	('staff','👑Staff')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('staff',1,'recruit','United Roleplay',4000,'{}')
;

CREATE TABLE `fine_types_staff` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  
  PRIMARY KEY (`id`)
);

INSERT INTO `fine_types_staff` (`id`, `label`, `amount`, `category`) VALUES
	(1, 'Multa Nivel 1 | Para não levar Ban', 100000, 0),
	(2, 'Multa Nivel 2 | Para não levar Ban', 250000, 0),
	(3, 'Multa Nivel 3 | Para não levar Ban', 400000, 0)
;