create extension if not exists "uuid-ossp";
drop table if exists repositories, developers cascade;

create table if not exists repositories(
	id uuid primary key default uuid_generate_v4(),
	name_rep text,
	about text,
	count_stars int
);

create table if not exists developers(
	id uuid primary key default uuid_generate_v4(),
	nickname text
);

create table rep_to_dev
(
    rep_id uuid references repositories,
    dev_id  uuid references developers,
    primary key (rep_id, dev_id)
);

insert into repositories(name_rep, about, count_stars)
values ('rep1', 'about1', 1),
		('rep2', 'about2', 2),
		('rep3', 'about3', 3);
		
insert into developers(nickname)
values ('nick1'),
		('nick2'),
		('nick3')
		
insert into rep_to_dev(rep_id, dev_id)
values ((select id from repositories where count_stars = 1), 
		(select id from developers where nickname = 'nick2')),
		((select id from repositories where count_stars = 1), 
		(select id from developers where nickname = 'nick3')),
		((select id from repositories where count_stars = 2), 
		(select id from developers where nickname = 'nick1'))
insert into rep_to_dev(rep_id, dev_id)
values ((select id from repositories where count_stars = 2), 
		(select id from developers where nickname = 'nick2'))
		

select 
	rep.id, 
	rep.name_rep,
	rep.about,
	rep.count_stars,
	coalesce (json_agg(json_build_object(
		'id', dev.id, 'nickname', dev.nickname
	)) filter (where dev.id is not null), '[]') as developers
	from repositories rep
	left join rep_to_dev rtd on rtd.rep_id = rep.id
	left join developers dev on rtd.dev_id = dev.id
	group by rep.id
