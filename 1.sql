--Krivenko Artem

drop table if exists fectival, vistuplenie cascade;

create table fectival (
	id int primary key,
	name_fectival text,
	data_fectival date,
	mesto text
);

create table vistuplenie (
	id int primary key,
	neme_vistuplenie text,
	data_vistuplenie date,
	genre text,
	fectival_id int references fectival(id)
);

insert into fectival(id, name_fectival, data_fectival, mesto)
values (1, 'VFM', '2024-03-19', 'Sirius'),
	   (2, 'Asia-E', '2023-04-03', 'Sochi'),
	   (3, 'Klass', '2022-05-12', 'Adler');
	   
insert into vistuplenie(id, neme_vistuplenie, data_vistuplenie, genre, fectival_id)
values (1, 'Rus', '2024-03-19', 'r', 1),
	   (2, 'Eng', '2023-04-03', 'e', 1),
	   (3, 'USA', '2022-05-12', 'u', 2),
	   (4, 'Ind', '2024-03-19', 'i', 2),
	   (5, 'Ase', '2023-04-03', 'a', 3),
	   (6, 'Eur', '2022-05-12', 'e', 3);
	   
select fectival.name_fectival, fectival.data_fectival, fectival.mesto,
coalesce(json_agg(json_build_object('name_v', vistuplenie.neme_vistuplenie, 'data_v', vistuplenie.data_vistuplenie, 'genre', vistuplenie.genre))
filter(where vistuplenie.fectival_id notnull), '[]')
from fectival
left join vistuplenie on vistuplenie.fectival_id = fectival.id
group by fectival.id;
