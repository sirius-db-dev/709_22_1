create table if not exists providers
(
	id int primary key generated always as identity,
	name_ text,
	phone text
);


create table if not exists vehicles
(
	id int primary key generated always as identity,
	provider_id int references providers,
	brand text,
	model text,
	tonnage float
);


insert into providers (name_, phone)
values 
('ООО Фермер', '+7(950) 439 23 45'),
('ООО Резвый кабан', '+7(938) 765 45 67'),
('Браконьеры Сочи', '+7(777) 777 77 77');


insert into vehicles (provider_id, brand, model, tonnage)
values 
(1, 'Лада', 'Нива 2010', 501203102.12),
(1, 'Лада', 'Веста 2018', 1000000.2123),
(3, 'Металлолом', 'Ultra super duper puper 3000', 1.0);


select
	c.id,
	c.name_,
	c.phone,
	coalesce(jsonb_agg(json_build_object(
		'ID', t.id, 'Марка', t.brand, 'Модель', t.model, 'Грузоподъёмность', t.tonnage)) 
		filter (where t.id is not null), '[]')
from providers c
left join vehicles t
	on c.id = t.provider_id 
group by c.id