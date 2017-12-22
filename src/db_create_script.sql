-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema selection_committee
-- -----------------------------------------------------
-- БД "Приемная комиссия". Абитуриент регистрируется на один из Факультетов с фиксированным планом набора, вводит баллы по соответствующим Предметам и аттестату.
-- Результаты Администратором регистрируются в Ведомости. Система подсчитывает сумму баллов и определяет Абитуриентов, зачисленных в учебное заведение.

-- -----------------------------------------------------
-- Schema selection_committee
--
-- БД "Приемная комиссия". Абитуриент регистрируется на один из Факультетов с фиксированным планом набора, вводит баллы по соответствующим Предметам и аттестату.
-- Результаты Администратором регистрируются в Ведомости. Система подсчитывает сумму баллов и определяет Абитуриентов, зачисленных в учебное заведение.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `selection_committee` DEFAULT CHARACTER SET utf8 ;
USE `selection_committee` ;

-- -----------------------------------------------------
-- Table `selection_committee`.`university`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`university` (
  `u_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID учебного заведения.',
  `u_name` VARCHAR(100) NOT NULL COMMENT 'Имя учебного заведения.',
  PRIMARY KEY (`u_id`),
  UNIQUE INDEX `u_name_UNIQUE` (`u_name` ASC))
ENGINE = InnoDB
COMMENT = 'Таблица о высших учебных заведениях.';


-- -----------------------------------------------------
-- Table `selection_committee`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`faculty` (
  `f_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID факультета.',
  `u_id` INT UNSIGNED NOT NULL COMMENT 'ID учебного заведения.',
  `f_name` VARCHAR(100) NOT NULL COMMENT 'Имя факультета.',
  PRIMARY KEY (`f_id`),
  INDEX `u_id_idx` (`u_id` ASC),
  CONSTRAINT `u_id`
    FOREIGN KEY (`u_id`)
    REFERENCES `selection_committee`.`university` (`u_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица о факультетах.';


-- -----------------------------------------------------
-- Table `selection_committee`.`speciality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`speciality` (
  `s_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID специальности.',
  `f_id` INT UNSIGNED NOT NULL COMMENT 'ID факультета.',
  `s_name` VARCHAR(100) NOT NULL COMMENT 'Имя специальности.',
  `number_of_seats` SMALLINT UNSIGNED NOT NULL COMMENT 'Количество мест.',
  PRIMARY KEY (`s_id`),
  INDEX `f_id_idx` (`f_id` ASC),
  CONSTRAINT `f_id`
    FOREIGN KEY (`f_id`)
    REFERENCES `selection_committee`.`faculty` (`f_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица о специальностях.';


-- -----------------------------------------------------
-- Table `selection_committee`.`enrollee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`enrollee` (
  `e_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID абитуриента.',
  `s_id` INT UNSIGNED NOT NULL COMMENT 'ID специальности.',
  `passport_id` VARCHAR(10) NOT NULL COMMENT 'ID пасспорта.',
  `country_domen` CHAR(2) NOT NULL COMMENT 'Домен страны.',
  `surname` VARCHAR(50) NOT NULL COMMENT 'Фамилия абитуриента.',
  `name` VARCHAR(50) NOT NULL COMMENT 'Имя абитуриента.',
  `second_name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Второе имя абитуриента.',
  `statement` ENUM('Зачислен', 'Не зачислен', 'В процессе') NOT NULL DEFAULT 'В процессе' COMMENT 'Ведомасть.',
  `russian_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по русскому языку.',
  `belorussian_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по белорусскому языку.',
  `physics` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по физике.',
  `math` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по математике.',
  `chemistry` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по химии.',
  `biology` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по биологии.',
  `foreign_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по иностранному языку.',
  `history_of_belarus` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по истории Беларуси.',
  `social_studies` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по обществоведению.',
  `geography` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по географии.',
  `history` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл по истории.',
  `certificate` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Балл аттестата.',
  PRIMARY KEY (`e_id`),
  UNIQUE INDEX `passport_id_UNIQUE` (`passport_id` ASC),
  INDEX `s_id_idx` (`s_id` ASC),
  UNIQUE INDEX `country_domen_UNIQUE` (`country_domen` ASC),
  CONSTRAINT `s_id`
    FOREIGN KEY (`s_id`)
    REFERENCES `selection_committee`.`speciality` (`s_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица об абитуриентах.';


-- -----------------------------------------------------
-- Table `selection_committee`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`user` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID пользователя.',
  `login` VARCHAR(16) NOT NULL COMMENT 'Логин.',
  `password` CHAR(32) NOT NULL COMMENT 'Пароль.',
  `type` ENUM('user', 'admin') NOT NULL DEFAULT 'user' COMMENT 'Тип пользователя.',
  `e_id` INT UNSIGNED NULL COMMENT 'ID абитуриента.',
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `login_UNIQUE` (`login` ASC),
  INDEX `e_id_idx` (`e_id` ASC),
  UNIQUE INDEX `e_id_UNIQUE` (`e_id` ASC),
  CONSTRAINT `user_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `selection_committee`.`enrollee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица о пользователях.';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
