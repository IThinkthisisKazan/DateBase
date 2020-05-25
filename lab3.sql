--0.	CREATE 
CREATE TABLE reader (
id_reader int IDENTITY(1,1) NOT NULL,
firstname varchar(50) NOT NULL,
lastname varchar(50) NOT NULL,
birthdate date NOT NULL,
contact_number varchar(20) NOT NULL,
PRIMARY KEY  (id_reader)
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
--1.��� �������� ������
INSERT INTO book VALUES(1,'����� ��� ����������','15' ,'1959')
INSERT INTO book VALUES(2,'���������� ���','13' ,'1991')
INSERT INTO book VALUES(2,'����� ����','19' ,'1990')
INSERT INTO book VALUES(2,'1Q84','14' ,'1994')
INSERT INTO book VALUES(2,'����� �� ����','20' ,'1982')
INSERT INTO author VALUES('�������','���','1927-08-09','M')
INSERT INTO issue VALUES(1,1,'2020-03-12','2020-04-12')
INSERT INTO reader VALUES('����','������','1876-12-12','79278701510')
INSERT INTO location_archive VALUES(1,'������-���, ��������� 20,','������','�����')
--2.� ��������� ������ ����� 
INSERT INTO book (id_author, name, price,date_relise) VALUES(2, '���������� ���','17', '1987-09-04')
INSERT INTO author (first_name, last_name, birthday, gender) VALUES ('������', '��������', '1949-12-12','�')
INSERT INTO issue(id_book,id_reader, issuing_date, dead_line) VALUES (2,2, '2020-04-12', '2020-05-12')
INSERT INTO reader(firstname, lastname, birthdate,contact_number) VALUES ('���','������','2020-01-12','79650018601') 
INSERT INTO location_archive (id_issue, address, country, name) VALUES (2, '���������, ������������� 15', '���������', '������� ������')
--3.� ������� �������� �� ������ �������

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
--1. ���� �������
DELETE archive
--2. �� �������
DELETE FROM book WHERE date_relise = '1959'
--3. �������� �������
--������� �������
INSERT INTO archive (id_author, name, price, date_relise) 
SELECT id_author, name, price, date_relise
FROM book 

TRUNCATE TABLE  archive

--3.UPDATE
--1. ���� �������
UPDATE book SET price = '19'
UPDATE book SET date_relise = '1992-10-05' 
--2. �� ������� �������� ���� �������
UPDATE location_archive SET country = '���������' WHERE name = '�����'
--3. �� ������� �������� ��������� ���������
UPDATE reader SET firstname = '����', lastname = '�������', birthdate = '2001-05-04',contact_number = '79671237634' WHERE id_reader = 2

--4.SELECT
--1. � ������������ ������� ����������� ��������� 
SELECT firstname, lastname, contact_number FROM reader
--2. �� ����� ����������
SELECT * FROM location_archive
--3. � �������� �� ��������
SELECT * FROM reader WHERE id_reader = '2'

--5.SELECT ORDER BY + TOP (LIMIT)
--1. � ����������� �� ����������� ASC + ����������� ������ ���������� �������
SELECT TOP 2 * FROM author ORDER BY birthday ASC
--2. � ����������� �� �������� DESC
SELECT TOP 2 * FROM author ORDER BY birthday DESC
--3. � ����������� �� ���� ��������� + ����������� ������ ���������� �������
SELECT TOP 2 * FROM author ORDER BY birthday, last_name DESC
--4. � ����������� �� ������� ��������, �� ������ �����������
SELECT TOP 2 * FROM issue ORDER BY issuing_date

--6 ������ � ������. ����������, ����� ���� �� ������ ��������� ������� � ����� DATETIME.
--1. WHERE �� ����
--�������� ������ ��� ��������

INSERT INTO author (first_name, last_name, birthday, gender) VALUES ('���', '������', '2000-11-16','�')
SELECT * FROM author WHERE birthday = '2000-11-16'
--������� �� ������� �� ��� ����, � ������ ���. ��������, ��� �������� ������.
--��� ����� ������������ ������� YEAR 
SELECT YEAR(birthday) FROM author

--7.SELECT GROUP BY � ��������� ���������
--MIN
SELECT MIN(birthday) FROM author 
--MAX
SELECT MAX(birthday) FROM author 
--AVG
SELECT AVG(id_author) FROM author
--SUM
SELECT SUM(id_location_archive) FROM location_archive
--COUNT
SELECT COUNT(*) FROM location_archive WHERE country = '���������'

--8.SELECT GROUP BY + HAVING
INSERT INTO book VALUES(1,'����� �� ����','25' ,'1987')
--1
SELECT id_author FROM book GROUP BY id_author HAVING MAX(price) > 20
--2
SELECT SUM(id_author) FROM author GROUP BY first_name HAVING SUM(id_author) < 2
--3
SELECT first_name FROM author GROUP BY first_name HAVING AVG(id_author) > 1

--9.SELECT JOIN
--1. LEFT JOIN ���� ������ � WHERE �� ������ �� ���������
SELECT * 
FROM author LEFT JOIN book
ON author.id_author = book.id_book WHERE gender = '�'
--2. RIGHT JOIN. �������� ����� �� �������, ��� � � 5.1
SELECT TOP 2 * 
FROM archive RIGHT JOIN author 
ON archive.name = author.first_name ORDER BY first_name ASC
--3. LEFT JOIN ���� ������ + WHERE �� �������� �� ������ �������
SELECT * 
FROM author   
-- � ���� ������� ��������� ��� ��������� �� ���� ������ �������� ����������
-- 2-� ������� �� ������ �������:
LEFT JOIN book ON (author.id_author = book.id_author) 
-- 3-� �� �������:
LEFT JOIN reader ON (reader.id_reader = author.id_author) 
WHERE  author.id_author = 1 AND gender = '�' AND book.id_author = 1  --������� ��� ���� 1-�� �������
--4. FULL OUTER JOIN ���� ������
INSERT INTO location_archive (id_issue, address, country, name) VALUES (8, '������, �������� 27', '���������', '����� ������') 
INSERT INTO location_archive (id_issue, address, country, name) VALUES (9, '������-���, ����� 45', '�����-���', '������� ��������') 
--
SELECT author.id_author, location_archive.id_location_archive 
FROM author 
FULL OUTER JOIN location_archive 
ON author.id_author = location_archive.id_issue

--10. ����������
--1. �������� ������ � WHERE IN (���������)
SELECT * FROM author WHERE first_name IN ('�������', '������')
--2. �������� ������ SELECT atr1, atr2, (���������) FROM ... 
SELECT author.id_author, author.last_name,(SELECT book.id_book FROM book WHERE book.id_book = author.id_author) AS id_book FROM author

