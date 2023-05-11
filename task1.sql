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
WITH TEMP AS (SELECT users.id as user_id, users.name as name, phone as phone
              FROM `users`
                       INNER JOIN `phone_numbers` ON users.id = phone_numbers.user_id
              where users.birth_date >= UNIX_TIMESTAMP(STR_TO_DATE('2001-01-01', '%Y-%m-%d'))
                AND users.birth_date <= UNIX_TIMESTAMP(STR_TO_DATE('2005-12-31', '%Y-%m-%d'))
              )
SELECT name ,COUNT(phone) as count_phone FROM TEMP GROUP BY user_id;


