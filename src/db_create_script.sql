-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema selection_committee
-- -----------------------------------------------------
-- Абитуриент регистрируется на один из Факультетов с фиксированным планом набора, вводит баллы по соответствующим Предметам и аттестату.
--  Результаты Администратором регистрируются в Ведомости. Система подсчитывает сумму баллов и определяет Абитуриентов, зачисленных в учебное заведение.

-- -----------------------------------------------------
-- Schema selection_committee
--
-- Абитуриент регистрируется на один из Факультетов с фиксированным планом набора, вводит баллы по соответствующим Предметам и аттестату.
--  Результаты Администратором регистрируются в Ведомости. Система подсчитывает сумму баллов и определяет Абитуриентов, зачисленных в учебное заведение.
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `selection_committee` DEFAULT CHARACTER SET utf8 ;
USE `selection_committee` ;

-- -----------------------------------------------------
-- Table `selection_committee`.`university`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`university` (
  `u_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор каждого университета.',
  `u_name` VARCHAR(100) NOT NULL COMMENT 'Данное поле хранит название учебного заведения (университета)',
  PRIMARY KEY (`u_id`),
  UNIQUE INDEX `u_name_UNIQUE` (`u_name` ASC))
ENGINE = InnoDB
COMMENT = 'Таблица university хранит информацию о высших учебных заведениях (университетах).';


-- -----------------------------------------------------
-- Table `selection_committee`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`faculty` (
  `f_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор для каждого факультета.',
  `u_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор учебного заведения (университета), к которому относится факультет.',
  `f_name` VARCHAR(100) NOT NULL COMMENT 'Данное поле хранит название факультета',
  PRIMARY KEY (`f_id`),
  INDEX `u_id_idx` (`u_id` ASC),
  CONSTRAINT `u_id`
    FOREIGN KEY (`u_id`)
    REFERENCES `selection_committee`.`university` (`u_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица faculty хранит информацию о факультетах, относящихся к тому или иному высшему учебному заведению (университету).';


-- -----------------------------------------------------
-- Table `selection_committee`.`speciality`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`speciality` (
  `s_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор каждой специальности.',
  `f_id` INT UNSIGNED NOT NULL COMMENT 'Идентификатор факультета, к которому относится специальность.',
  `s_name` VARCHAR(100) NOT NULL COMMENT 'Данное поле хранит название специальности.',
  `number_of_seats` SMALLINT UNSIGNED NOT NULL COMMENT 'Данное поле хранит число - количество абитуриентов, которые могут быть зачислены на специальность.',
  PRIMARY KEY (`s_id`),
  INDEX `f_id_idx` (`f_id` ASC),
  CONSTRAINT `f_id`
    FOREIGN KEY (`f_id`)
    REFERENCES `selection_committee`.`faculty` (`f_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица speciality хранит информацию о специальностях, отсносящихся к тому или иному факультету на который будет подавать документы абитуриент.';


-- -----------------------------------------------------
-- Table `selection_committee`.`enrollee`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`enrollee` (
  `e_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор абитуриента.',
  `s_id` INT UNSIGNED NOT NULL COMMENT 'Данное поле хранит внешний ключ на специальность, на которую абитуриент подал документы',
  `passport_id` VARCHAR(10) NOT NULL COMMENT 'Номер паспорта каждого абитуриента.',
  `country_domen` CHAR(2) NOT NULL COMMENT 'Домен страны, гражданином которой является абитуриент.',
  `surname` VARCHAR(50) NOT NULL COMMENT 'Данное поле хранит фамилию абитуриента.',
  `name` VARCHAR(50) NOT NULL COMMENT 'Данное поле хранит имя абитуриента.',
  `second_name` VARCHAR(50) NULL DEFAULT NULL COMMENT 'Данное поле хранит второе имя абитуриента, если оно имеется',
  `statement` ENUM('Зачислен', 'Не зачислен', 'В процессе') NOT NULL DEFAULT 'В процессе' COMMENT 'Данное поле хранит ведомость, показывающая был ли зачислен абитуриент в учебное заведение',
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
COMMENT = 'Таблица enrollee хранит информацию об абитуриентах, подавших документы в то или иное высшее учебное заведение (университет).';


-- -----------------------------------------------------
-- Table `selection_committee`.`subject`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`subject` (
  `subject_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор каждого предмета.',
  `e_id` INT UNSIGNED NOT NULL COMMENT 'Внешний ключ на абитуриента, который сдавал данный предмет.',
  `russian_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету Русский язык.',
  `belorussian_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оцентку за ЦТ по предмету Белорусский язык.',
  `physics` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету Физика.',
  `math` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит информацию за ЦТ по предмету Математика.',
  `chemistry` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету Химия.',
  `biology` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету Биология.',
  `foreign_lang` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по Иностранному языку.',
  `history_of_belarus` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету История Беларуси.',
  `social_studies` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету Обществоведение.',
  `geography` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле хранит оценку за ЦТ по предмету География',
  `history` TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Данное поле содержит оценку за ЦТ по предмету Всемирная история.',
  PRIMARY KEY (`subject_id`),
  INDEX `e_id_idx` (`e_id` ASC),
  UNIQUE INDEX `e_id_UNIQUE` (`e_id` ASC),
  CONSTRAINT `e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `selection_committee`.`enrollee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица subject хранит информацию о предметах и их баллах, которые указывались абитуриентом.';


-- -----------------------------------------------------
-- Table `selection_committee`.`certificate`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`certificate` (
  `c_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Уникальный идентификатор каждого аттестата.',
  `e_id` INT UNSIGNED NOT NULL COMMENT 'Внешний ключ на идентификатор абитуриента, которому принадлежит данный аттестат.',
  `mark` TINYINT UNSIGNED NOT NULL COMMENT 'Данное поле хранит средней балл аттестата абитуриента, полученный после окончания среднего образования.',
  PRIMARY KEY (`c_id`),
  INDEX `e_id_idx` (`e_id` ASC),
  UNIQUE INDEX `e_id_UNIQUE` (`e_id` ASC),
  CONSTRAINT `c_e_id`
    FOREIGN KEY (`e_id`)
    REFERENCES `selection_committee`.`enrollee` (`e_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB
COMMENT = 'Таблица certificate хранит информацию о среднем балле аттестата, который был указан абитуриентом при подаче документов.';


-- -----------------------------------------------------
-- Table `selection_committee`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `selection_committee`.`user` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Данное поле хранит уникальный идентификатор для каждого пользователя системы.',
  `login` VARCHAR(16) NOT NULL COMMENT 'Данное поле хранит логин пользователя.',
  `password` CHAR(32) NOT NULL COMMENT 'Данное поле хранит пароль пользователя в зашифрованном \nвиде (Через генерацию MD5).',
  `type` ENUM('user', 'admin') NOT NULL DEFAULT 'user' COMMENT 'Данный столбец хранит тип, к которому принадлежит пользователь (user/admin).',
  `e_id` INT UNSIGNED NULL COMMENT 'Данный столбец хранит FK на абитуриента, если пользователь является user.',
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
COMMENT = 'Данная таблица хранит информацию пользователей для доступа в систему.';


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
