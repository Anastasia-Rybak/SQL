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
