create extension if not exists "uuid-ossp";
drop table if exists festival, participant cascade;

create table if not exists festival(
	id uuid primary key default uuid_generate_v4(),
	name_festival text,
	date_start date,
	place text
);

create table if not exists participant(
	id uuid primary key default uuid_generate_v4(),
	name_participant text,
	surname text,
	birthday date
);

create table fest_to_part
(
    fest_id uuid references festival,
    part_id  uuid references participant,
    primary key (fest_id, part_id)
);

insert into festival(name_festival, date_start, place)
values ('fest1', '2022-02-23', 'place1'),
		('fest2', '2022-02-23', 'place2'),
		('fest3', '2022-02-23', 'place3');
		
insert into participant(name_participant, surname, birthday)
values ('name1', 'surname1', '2022-02-23'),
		('name2', 'surname2', '2022-02-23'),
		('name3', 'surname3', '2022-02-23');
		
insert into fest_to_part(fest_id, part_id)
values ((select id from festival where name_festival = 'fest1'), 
		(select id from participant where name_participant = 'name2')),
		((select id from festival where name_festival = 'fest1'), 
		(select id from participant where name_participant = 'name3')),
		((select id from festival where name_festival = 'fest2'), 
		(select id from participant where name_participant = 'name1'));
	

insert into fest_to_part(fest_id, part_id)
values ((select id from festival where name_festival = 'fest2'), 
		(select id from participant where name_participant = 'name2'));
		

select 
	fest.id,
	fest.name_festival,
	fest.date_start,
	fest.place,
	coalesce (json_agg(json_build_object(
	'id', p.id, 'name', p.name_participant, 'surname', p.surname, 'birthday', p.birthday
	)) filter(where p.id is not null), '[]') as participant
	from festival fest
	left join fest_to_part ftp on ftp.fest_id = fest.id
	left join participant p on ftp.part_id = p.id
	group by fest.id
	