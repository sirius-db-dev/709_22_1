drop table if exists commentes,recept cascade;

create table if not exists recept(
	id serial primary key,
	name_recept text,
	about text,
	category text
);

insert into recept (name_recept, about, category)
values ('recept1', 'recept1', 'recept'),
		('recept2', 'recept2', 'recept'),
		('recept3', 'recept3', 'recept')
;

create table if not exists commentes(
	id serial primary key,
	id_recept int references recept(id),
	texts text,
	publication_date date
);


insert into commentes(id_recept, texts, publication_date)
values (2, 'Delicious', '2024-02-22'),
		(1, 'Not delicious', '2024-02-22')

;
insert into commentes(id_recept, texts, publication_date)
values (2, 'Not delicious', '2024-02-22')

;
select 
	rec.id,
	rec.name_recept,
	rec.about,
	rec.category,
	coalesce (json_agg(json_build_object(
	'id', com.id, 'texts', com.texts, 'publication_date', com.publication_date
	)) filter(where com.id_recept is not Null), '[]') from recept rec
	left join commentes com on com.id_recept = rec.id
	group by rec.id;
	