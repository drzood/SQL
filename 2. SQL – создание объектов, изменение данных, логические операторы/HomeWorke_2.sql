/*
1. Используя операторы языка SQL, 
создайте таблицу “sales”. Заполните ее данными.
Справа располагается рисунок к первому 
заданию.

id order_date count_product
1 2022-01-01 156
2 2022-01-02 180
3 2022-01-03 21
4 2022-01-04 124
5 2022-01-05 341
*/

USE lesson_2;
CREATE TABLE sales (
	id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    count_product INT NOT NULL
);

INSERT INTO lesson_2.sales (order_date, count_product) 
VALUES 
	(20220101, 156),
	(20220102, 180),
	(20220103, 21),
	(20220104, 124),
	(20220105, 341);

/* 
2. Для данных таблицы “sales” укажите тип 
заказа в зависимости от кол-ва : 
меньше 100 - Маленький заказ
от 100 до 300 - Средний заказ
больше 300 - Большой заказ 

id заказа Тип заказа
1 Средний заказ
2 Средний заказ
3 Маленький заказ
4 Средний заказ
5 Большой заказ
*/

SELECT
	id AS 'ID Заказа',
    CASE
		WHEN count_product < 100 THEN 'Маленкий заказ'
        WHEN count_product BETWEEN 100 AND 300 THEN 'Средний заказ'
        WHEN count_product > 300 THEN 'Большой заказ'
        ELSE 'Не оределено'
	END AS 'Тип заказа'
FROM sales;

/*
3. Создайте таблицу “orders”, заполните ее значениями

id employee_id amount order_status
1 e03 15.00 OPEN
2 e01 25.50 OPEN
3 e05 100.70 CLOSED
4 e02 22.18 OPEN
5 e04 9.50 CANCELLED

Выберите все заказы. В зависимости от поля order_status выведите столбец full_order_status:
OPEN – «Order is in open state» ; CLOSED - «Order is closed»; CANCELLED - «Order is cancelled»
*/

USE lesson_2;
CREATE TABLE orders (
	id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(10) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(15) NOT NULL
);

INSERT INTO lesson_2.orders (employee_id, amount, order_status)
VALUES 
	('e03', 15.00, 'OPEN'),
	('e01', 25.50, 'OPEN'),
	('e05', 100.70, 'CLOSED'),
	('e02', 22.18, 'OPEN'),
	('e04', 9.50, 'CANCELLED');
    
SELECT
	IF (order_status = 'OPEN', 'Order is in open state',
		IF (order_status = 'CLOSED', 'Order is closed',
			IF (order_status = 'CANCELLED', 'Order is cancelled', 'Oops')
		)
	) AS 'full_order_status'
FROM orders;

/*
4. Чем 0 отличается от NULL?
Своими словами: ноль имеет вес, NULL не имеет веса.
*/