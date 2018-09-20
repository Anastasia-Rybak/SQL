SET FOREIGN_KEY_CHECKS=0;

DROP DATABASE IF EXISTS `library`;

CREATE DATABASE IF NOT EXISTS `library` CHARACTER SET utf8 COLLATE utf8_general_ci;

USE `library`;

CREATE TABLE `authors`
(
	`a_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT ,
	`a_name` VARCHAR(150),
	CONSTRAINT `PK_authors` PRIMARY KEY (`a_id`)
)
;

CREATE TABLE `books`
(
	`b_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT ,
	`b_name` VARCHAR(150),
	`b_year` SMALLINT UNSIGNED,
	`b_quantity` SMALLINT UNSIGNED,
	CONSTRAINT `PK_books` PRIMARY KEY (`b_id`)
)
;

CREATE TABLE `genres`
(
	`g_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT ,
	`g_name` VARCHAR(150),
	CONSTRAINT `PK_genres` PRIMARY KEY (`g_id`)
)
;

CREATE TABLE `m2m_books_authors`
(
	`b_id` INTEGER UNSIGNED NOT NULL,
	`a_id` INTEGER UNSIGNED NOT NULL,
	CONSTRAINT `PK_m2m_books_authors` PRIMARY KEY (`b_id`,`a_id`)
)
;

CREATE TABLE `m2m_books_genres`
(
	`b_id` INTEGER UNSIGNED NOT NULL,
	`g_id` INTEGER UNSIGNED NOT NULL,
	CONSTRAINT `PK_m2m_books_genres` PRIMARY KEY (`b_id`,`g_id`)
)
;

CREATE TABLE `subscribers`
(
	`s_id` INTEGER UNSIGNED NOT NULL AUTO_INCREMENT ,
	`s_name` VARCHAR(150),
	`s_last_visit` DATE,
	CONSTRAINT `PK_subscribers` PRIMARY KEY (`s_id`)
)
;

CREATE TABLE `subscriptions`
(
	`sb_id` INTEGER UNSIGNED NOT NULL,
	`s_id` INTEGER UNSIGNED,
	`b_id` INTEGER UNSIGNED,
	`sb_start` DATE,
	`sb_finish` DATE,
	`sb_is_active` ENUM ('Y', 'N'),
	CONSTRAINT `PK_subscriptions` PRIMARY KEY (`sb_id`)
)
;

CREATE TABLE `cities`
(
	`ct_id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`ct_name` VARCHAR(50),
	CONSTRAINT `PK_cities` PRIMARY KEY (`ct_id`)
)
;

CREATE TABLE `connections`
(
	`cn_from` INT UNSIGNED NOT NULL,
	`cn_to` INT UNSIGNED NOT NULL,
	`cn_cost` DOUBLE,
	`cn_bidir` ENUM ('N', 'Y'),
	CONSTRAINT `PK_connections` PRIMARY KEY (`cn_from`,`cn_to`)
)
;

CREATE TABLE `site_pages`
(
	`sp_id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`sp_parent` INT UNSIGNED,
	`sp_name` VARCHAR(200),
	CONSTRAINT `PK_site_pages` PRIMARY KEY (`sp_id`)
)
;

CREATE TABLE `computers`
(
	`c_id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`c_room` INT UNSIGNED,
	`c_name` VARCHAR(50),
	CONSTRAINT `PK_computers` PRIMARY KEY (`c_id`)
)
;

CREATE TABLE `rooms`
(
	`r_id` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	`r_name` VARCHAR(50),
	`r_space` TINYINT,
	CONSTRAINT `PK_rooms` PRIMARY KEY (`r_id`)
)
;

ALTER TABLE `computers` 
 ADD CONSTRAINT `FK_computers_rooms`
	FOREIGN KEY (`c_room`) REFERENCES `rooms` (`r_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `connections` 
 ADD CONSTRAINT `FK_connections_cities`
	FOREIGN KEY (`cn_from`) REFERENCES `cities` (`ct_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `connections` 
 ADD CONSTRAINT `FK_connections_cities_02`
	FOREIGN KEY (`cn_to`) REFERENCES `cities` (`ct_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `site_pages` 
 ADD CONSTRAINT `FK_site_pages_site_pages`
	FOREIGN KEY (`sp_parent`) REFERENCES `site_pages` (`sp_id`) ON DELETE Set Null ON UPDATE Set Null
;

ALTER TABLE `genres` 
 ADD CONSTRAINT `UQ_genres_g_name` UNIQUE (`g_name`)
;

ALTER TABLE `m2m_books_authors` 
 ADD CONSTRAINT `FK_m2m_books_authors_authors`
	FOREIGN KEY (`a_id`) REFERENCES `authors` (`a_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `m2m_books_authors` 
 ADD CONSTRAINT `FK_m2m_books_authors_books`
	FOREIGN KEY (`b_id`) REFERENCES `books` (`b_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `m2m_books_genres` 
 ADD CONSTRAINT `FK_m2m_books_genres_books`
	FOREIGN KEY (`b_id`) REFERENCES `books` (`b_id`) ON DELETE Cascade ON UPDATE Cascade
;

ALTER TABLE `m2m_books_genres` 
 ADD CONSTRAINT `FK_m2m_books_genres_genres`
	FOREIGN KEY (`g_id`) REFERENCES `genres` (`g_id`) ON DELETE Cascade ON UPDATE Cascade
;

SET FOREIGN_KEY_CHECKS=1
