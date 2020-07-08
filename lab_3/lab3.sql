--0.CREATE
CREATE TABLE reader (
id_reader int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
birthdate date NOT NULL,
contact_number varchar(20) NOT NULL,
PRIMARY KEY (id_reader)
)
GO

CREATE TABLE book (
id_book int IDENTITY(1,1) NOT NULL,
id_author int NOT NULL,
name varchar(100) NOT NULL,
price money NOT NULL,
date_relise date NOT NULL,
PRIMARY KEY (id_book)
)
GO

CREATE TABLE author (
id_author int IDENTITY(1,1) NOT NULL,
first_name varchar(100) NOT NULL,
last_name varchar(100) NOT NULL,
birthday date NOT NULL,
gender char(1) NOT NULL,
PRIMARY KEY (id_author)
)
GO

CREATE TABLE issue(
id_issue int IDENTITY(1,1) NOT NULL,
id_book int NOT NULL,
id_reader int NOT NULL,
issuing_date date NOT NULL,
dead_line date NOT NULL
PRIMARY KEY (id_issue)
)
GO

CREATE TABLE location_archive(
id_location_archive int IDENTITY(1,1) NOT NULL,
id_issue int NOT NULL,
address varchar(100) NOT NULL,
country varchar(50) NOT NULL,
name varchar(100) NOT NULL,
PRIMARY KEY (id_location_archive)
)
GO

--1.INSERT
--1.Без указания списка
INSERT INTO book VALUES(1,'Цветы для Элджернона','15' ,'1959')
INSERT INTO book VALUES(2,'Норвежский лес','13' ,'1991')
INSERT INTO book VALUES(2,'Зомбо ящик','19' ,'1990')
INSERT INTO book VALUES(2,'1Q84','14' ,'1994')
INSERT INTO book VALUES(2,'Охота на овец','20' ,'1982')
INSERT INTO author VALUES('Дэниель','Киз','1927-08-09','M')
INSERT INTO issue VALUES(1,1,'2020-03-12','2020-04-12')
INSERT INTO reader VALUES('Джек','Лондон','1876-12-12','79278701510')
INSERT INTO location_archive VALUES(1,'Йошкар-Ола, Панфилова 20,','Россия','Книги')
--2.С указанием списка людей
INSERT INTO book (id_author, name, price,date_relise) VALUES(2, 'Норвежский лес','17', '1987-09-04')
INSERT INTO author (first_name, last_name, birthday, gender) VALUES ('Харуко', 'Муроками', '1949-12-12','М')
INSERT INTO issue(id_book,id_reader, issuing_date, dead_line) VALUES (2,2, '2020-04-12', '2020-05-12')
INSERT INTO reader(firstname, lastname, birthdate,contact_number) VALUES ('Юра','Петров','2020-01-12','79650018601')
INSERT INTO location_archive (id_issue, address, country, name) VALUES (2, 'Нурсултан, Комсомольская 15', 'Казахстан', 'Книжный уголок')
--3.С чтением значения из другой таблицы

CREATE TABLE archive(
id_author int NOT NULL,
name varchar(100) NOT NULL,
price money NOT NULL,
date_relise date NOT NULL,
)
GO

INSERT INTO archive (id_author, name, price, date_relise)
SELECT id_author, name, price, date_relise
FROM book

--2.DELETE
--1. Всех записей
DELETE archive
--2. По условию
DELETE FROM book WHERE date_relise = '1959'
--3. Очистить таблицу
--Обновим таблицу
INSERT INTO archive (id_author, name, price, date_relise)
SELECT id_author, name, price, date_relise
FROM book

TRUNCATE TABLE archive

--3.UPDATE
--1. Всех записей
UPDATE book SET price = '19'
UPDATE book SET date_relise = '1992-10-05'
--2. По условию обновляя один атрибут
UPDATE location_archive SET country = 'Казахстан' WHERE name = 'Книги'
--3. По условию обновляя несколько атрибутов
UPDATE reader SET firstname = 'Артём', lastname = 'Носиков', birthdate = '2001-05-04',contact_number = '79671237634' WHERE id_reader = 2

--4.SELECT
--1. С определенным набором извлекаемых атрибутов
SELECT firstname, lastname, contact_number FROM reader
--2. Со всеми атрибутами
SELECT * FROM location_archive
--3. С условием по атрибуту
SELECT * FROM reader WHERE id_reader = '2'

--5.SELECT ORDER BY + TOP (LIMIT)
--1. С сортировкой по возрастанию ASC + ограничение вывода количества записей
SELECT TOP 2 * FROM author ORDER BY birthday ASC
--2. С сортировкой по убыванию DESC
SELECT TOP 2 * FROM author ORDER BY birthday DESC
--3. С сортировкой по двум атрибутам + ограничение вывода количества записей
SELECT TOP 2 * FROM author ORDER BY birthday, last_name DESC
--4. С сортировкой по первому атрибуту, из списка извлекаемых
SELECT TOP 2 * FROM issue ORDER BY issuing_date

--6 Работа с датами. Необходимо, чтобы одна из таблиц содержала атрибут с типом DATETIME.
--1. WHERE по дате
--Добавляю строку для проверки

INSERT INTO author (first_name, last_name, birthday, gender) VALUES ('Аяр', 'Токоев', '2000-11-16','М')
SELECT * FROM author WHERE birthday = '2000-11-16'
--Извлечь из таблицы не всю дату, а только год. Например, год рождения автора.
--Для этого используется функция YEAR
SELECT YEAR(birthday) FROM author

--7.SELECT GROUP BY с функциями агрегации
--MIN
SELECT MIN(birthday) FROM author
--MAX
SELECT MAX(birthday) FROM author
--AVG
SELECT AVG(id_author) FROM author
--SUM
SELECT SUM(id_location_archive) FROM location_archive
--COUNT
SELECT COUNT(*) FROM location_archive WHERE country = 'Казахстан'

--8.SELECT GROUP BY + HAVING
INSERT INTO book VALUES(1,'Охота на овец','25' ,'1987')
--1
SELECT id_author FROM book GROUP BY id_author HAVING MAX(price) > 20
--2
SELECT SUM(id_author) FROM author GROUP BY first_name HAVING SUM(id_author) < 2
--3
SELECT first_name FROM author GROUP BY first_name HAVING AVG(id_author) > 1

--9.SELECT JOIN
--1. LEFT JOIN двух таблиц и WHERE по одному из атрибутов
SELECT *
FROM author LEFT JOIN book
ON author.id_author = book.id_book WHERE gender = 'М'
--2. RIGHT JOIN. Получить такую же выборку, как и в 5.1
SELECT TOP 2 *
FROM archive RIGHT JOIN author
ON archive.name = author.first_name ORDER BY first_name ASC
--3. LEFT JOIN трех таблиц + WHERE по атрибуту из каждой таблицы
SELECT *
FROM author
-- к этой таблицы прикрепим две остальные по двум разным условиям совпадения
-- 2-ю таблицу по одному условию:
LEFT JOIN book ON (author.id_author = book.id_author)
-- 3-ю по другому:
LEFT JOIN reader ON (reader.id_reader = author.id_author)
WHERE author.id_author = 1 AND gender = 'М' AND book.id_author = 1 --условие для поля 1-ой таблицы
--4. FULL OUTER JOIN двух таблиц
INSERT INTO location_archive (id_issue, address, country, name) VALUES (8, 'Казань, Гагарина 27', 'Татарстан', 'Гарри Поттер')
INSERT INTO location_archive (id_issue, address, country, name) VALUES (9, 'Йошкар-ола, Южная 45', 'Марий-Эль', 'Книжная шкатулка')
--
SELECT author.id_author, location_archive.id_location_archive
FROM author
FULL OUTER JOIN location_archive
ON author.id_author = location_archive.id_issue

--10. Подзапросы
--1. Написать запрос с WHERE IN (подзапрос)
SELECT * FROM author WHERE first_name IN ('Дэниель', 'Харуко')
--2. Написать запрос SELECT atr1, atr2, (подзапрос) FROM ...
SELECT author.id_author, author.last_name,(SELECT book.id_book FROM book WHERE book.id_book = author.id_author) AS id_book FROM author