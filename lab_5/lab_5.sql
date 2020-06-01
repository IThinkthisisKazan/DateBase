-- 1. Добавить внешние ключи.
ALTER TABLE dealer ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE production ADD FOREIGN KEY (id_company) REFERENCES company (id_company);
ALTER TABLE [order] ADD FOREIGN KEY (id_dealer) REFERENCES dealer (id_dealer);
ALTER TABLE production ADD FOREIGN KEY (id_medicine) REFERENCES medicine (id_medicine);
ALTER TABLE [order] ADD FOREIGN KEY (id_production) REFERENCES production (id_production);
ALTER TABLE [order] ADD FOREIGN KEY (id_pharmacy) REFERENCES pharmacy (id_pharmacy);

-- 2. Выдать информацию по всем заказам лекарства "Кордерон" компании "Аргус" с указанием названий аптек, дат, объема заказов.
SELECT pharmacy.name,[order].date,[order].quantity FROM [order] 
LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
LEFT JOIN production ON production.id_production = [order].id_production
LEFT JOIN company ON production.id_company = company.id_company
LEFT JOIN medicine ON production.id_medicine = medicine.id_medicine
WHERE medicine.name = 'Кордерон' AND company.name = 'Аргус'

-- 3. Дать список лекарств компании "Фарма", на которые не были сделаны заказы до 25 января.
SELECT medicine.id_medicine, medicine.name 
FROM medicine
LEFT JOIN production ON medicine.id_medicine = production.id_medicine
LEFT JOIN company ON production.id_company = company.id_company
LEFT JOIN [order] ON production.id_production = [order].id_production
WHERE 
company.name = 'Фарма' AND production.id_production NOT IN (SELECT [order].id_production FROM [order] WHERE [order].date < '2019-01-25')
GROUP BY medicine.id_medicine, medicine.name;

-- 4. Дать минимальный и максимальный баллы лекарств каждой фирмы, которая оформила не менее 120 заказов.
SELECT company.name, MIN(production.rating) AS min_rating , MAX(production.rating) AS min_rating 
FROM production
LEFT JOIN company ON company.id_company = production.id_company
LEFT JOIN [order] ON [order].id_production = production.id_production
GROUP BY company.name
HAVING COUNT([order].id_order) >= 120 

-- 5. Дать списки сделавших заказы аптек по всем дилерам компании "AstraZeneca".Если у дилера нет заказов, в названии аптеки проставить NULL.
SELECT dealer.id_dealer, dealer.name, pharmacy.name 
FROM dealer
LEFT JOIN company ON dealer.id_company = company.id_company
LEFT JOIN [order] ON [order].id_dealer = dealer.id_dealer
LEFT JOIN pharmacy ON pharmacy.id_pharmacy = [order].id_pharmacy
WHERE	company.name = 'AstraZeneca'
ORDER BY dealer.id_dealer
 
 -- 6. Уменьшить на 20% стоимость всех лекарств, если она превышает 3000, а длительность лечения не более 7 дней.
 UPDATE production SET production.price = production.price * 0.8
 WHERE production.id_production 
 IN (SELECT production.id_production 
     FROM production 
     LEFT JOIN medicine ON medicine.id_medicine = production.id_medicine
	 WHERE production.price >3000 AND medicine.cure_duration <= 7)

--Проверка 
SELECT * FROM production
SELECT * FROM medicine

-- 7. Добавить необходимые индексы.
CREATE INDEX Index_order_id_production
ON "order"(id_production ASC);

CREATE INDEX Index_order_id_pharmacy
ON "order"(id_pharmacy ASC);

CREATE INDEX Index_dealer_id_company
ON dealer(id_company ASC);

CREATE INDEX Index_production_id_company
ON production(id_company ASC);

CREATE INDEX Index_production_id_medicine
ON production(id_medicine ASC);

CREATE INDEX Index_production_rating 
ON production(rating ASC);

CREATE INDEX Index_medicine_name 
ON medicine(name);