create table if not exists vidios
(
	id int primary key generated always as identity,
	title text,
	description text,
	date_ date
);


create table if not exists comments
(
	id int primary key generated always as identity,
	video_id int references vidios,
	text_ text,
	likes int
);


insert into vidios (title, description, date_)
values 
('Новое видео', 'Видео обо мне', '2024/02/21'),
('Ещё одно видео', 'Видео обо всём', '2024/02/22'),
('Самое новое видео', 'Видео о новом', '2024/02/22');


insert into comments (video_id, text_, likes)
values 
(1, 'Очень круто', 25),
(1, 'Мне не понравилось', 0),
(2, 'Местами интересное', 12);


select
	c.id,
	c.title,
	c.description,
	c.date_,
	coalesce(jsonb_agg(json_build_object(
		'id', t.id, 'text', t.text_, 'likes amount', t.likes)) 
		filter (where t.id is not null), '[]')
from vidios c
left join comments t
	on c.id = t.video_id 
group by c.id