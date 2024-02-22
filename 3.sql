--Отрощенко Антон К0709-22/1

DROP TABLE if EXISTS taxi, ordr CASCADE;

CREATE TABLE taxi 
(
    id int PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    numbr TEXT,
    car TEXT
);

CREATE TABLE ordr 
(
    id int PRIMARY KEY,
    name_order TEXT,
    date_order date,
    price FLOAT,
    from_point TEXT,
    to_point TEXT,
    taxi_id int REFERENCES ordr(id)
);

insert into taxi(id, first_name, last_name, numbr, car)
values (1, 'Anton', 'Otros', '89282426169', 'Porsche'),
	   (2, 'Artem', 'Nehorosh', '89123456789', 'Lada'),
       (3, 'Vlad', 'Argun', '89876543210', 'Kia');
   
insert into ordr(id, name_order, date_order, price, from_point, to_point, taxi_id)
values (1, 'Order1', '2022-02-21', 254.74, 'Buran', 'Sigma', 1),
       (2, 'Order2', '2024-02-20', 875.64, 'Sigma', 'Buran', 2),
       (3, 'Order3', '2023-02-25', 453.23, 'Sochi', 'Abxazia', 3),
       (4, 'Order4', '2023-04-12', 453.42, 'Abxazia', 'Sochi', 3);

   
select taxi.first_name, taxi.last_name, taxi.numbr, taxi.car,
coalesce(json_agg(json_build_object('nm', ordr.name_order, 'dt', ordr.date_order, 'prc', ordr.price, 'frm', ordr.from_point, 'to', ordr.to_point))
filter(where ordr.taxi_id notnull), '[]')
from taxi 
left join ordr on ordr.taxi_id = taxi.id
group by taxi.id
