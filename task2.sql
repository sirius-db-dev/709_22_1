create table if not exists repositories
(
	id int primary key generated always as identity,
	name_ text,
	description text,
	stars int
);


create table if not exists tickets
(
	id int primary key generated always as identity,
	repository_id int references repositories,
	name_ text,
	description text,
	status text
);


insert into repositories (name_, description, stars)
values 
('My first Python script', 'Мой первый скрипт на питоне - выводит Hello, world!', 5),
('My first Java program', 'Моя первая программа на java - отрисовывает Hello, world! на экране', 0),
('Контрольная работа по бд', 'Первая кр по базам данных', 3);


insert into tickets (repository_id, name_, description, status)
values 
(1, 'Сделай текст цветным', 'Надпись должна выводиться разными цветами', 'in progress'),
(1, 'Сделай эхо бот', 'Повторяет текст, введённый пользователем, добавляя Hello,', 'completed'),
(3, 'Выполни 3-е задание', 'Не забудь выполнить третье задание', 'in progress');


select
	c.id,
	c.name_,
	c.description,
	c.stars,
	coalesce(jsonb_agg(json_build_object(
		'ID', t.id, 'Title', t.name_, 'Description', t.description, 'Status', t.status)) 
		filter (where t.id is not null), '[]')
from repositories c
left join tickets t
	on c.id = t.repository_id 
group by c.id