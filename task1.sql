/*Задача №1
Имеется база со следующими таблицами:
Напишите запрос, возвращающий имя и число указанных телефонных номеров девушек в возрасте от 18 до 22 лет.
Оптимизируйте таблицы и запрос при необходимости.*/

CREATE TABLE `users` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(255) DEFAULT NULL,
 `gender` TINYINT(1) NOT NULL COMMENT '0 - не указан, 1 - мужчина, 2 - женщина.',
 `birth_date` INT(11) NOT NULL COMMENT 'Дата в unixtime.',
 PRIMARY KEY (`id`),
 INDEX(`id`)
);
CREATE TABLE `phone_numbers` (
 `id` INT(11) NOT NULL AUTO_INCREMENT,
 `user_id` INT(11) NOT NULL,
 `phone` VARCHAR(255) DEFAULT NULL,
 PRIMARY KEY (`id`),
 FOREIGN KEY (`user_id`)  REFERENCES users (id),
INDEX(`id`)
);

INSERT INTO `users` (`name`,`gender`,`birth_date`) VALUES ("Anastasia",2,UNIX_TIMESTAMP(STR_TO_DATE('2001-05-05', '%Y-%m-%d')));
INSERT INTO `phone_numbers` (`user_id`,`phone`) VALUES (1,"4654564");
INSERT INTO `phone_numbers` (`user_id`,`phone`) VALUES (1,"4654564");
INSERT INTO `phone_numbers` (`user_id`,`phone`) VALUES (1,"4654564");
SELECT u.name, COUNT(p.phone) AS count_phoneFROM (
    SELECT *
    FROM users
    WHERE gender = 2
    AND birth_date BETWEEN UNIX_TIMESTAMP(:start_date) AND UNIX_TIMESTAMP(:end_date)
) AS u
LEFT JOIN phone_numbers AS p ON u.id = p.user_id
GROUP BY u.id, u.name;


