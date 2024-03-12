create EXTENSION if not EXISTS "uuid-ossp"; 

drop table if exists Events, participants, Event_participants CASCADE;

create table Events
(
    id uuid primary key default uuid_generate_v4(),
    name_e text,
    data_e date,
    adres text 
);

create table participants
(
    id uuid primary key default uuid_generate_v4(),
    name_p text,
    sname_p text,
    brithday date
);

create table Event_participants
(
    id_e uuid REFERENCES Events,
    id_p uuid references participants,
    primary key (id_e, id_p)
);

insert into Events(name_e, data_e, adres)
values('день рождения', '2024-03-12', 'парк науки и искусства'),
('открытие зоопарка', '1979-10-10', 'улица ленина'),
('открыте школы', '2000-11-11', 'улица бытха');

INSERT into participants(name_p, sname_p, brithday)
values ('вася', 'петренко', '2005-04-24'),
('петя', 'папкин', '2007-08-09'),
('женя', 'пупкин', '2000-01-15'),
('антон', 'отрощенко', '2006-02-09');

insert into Event_participants(id_e, id_p)
values 
((select id from Events WHERE name_e = 'день рождения'), (select id from participants where name_p = 'антон')),
((select id from Events WHERE name_e = 'день рождения'), (select id from participants where name_p = 'вася')),
((select id from Events WHERE name_e = 'открыте школы'), (select id from participants where name_p = 'антон'));


select  Events.id, Events.name_e, Events.data_e, Events.adres, COALESCE(json_agg(json_build_object(
    'id', participants.id, 'имя', participants.name_p, 'фамилия', participants.sname_p, 'день рождения', participants.brithday))
    filter(where participants.id is not NULL), '[]') as participants
    from Events
    left join Event_participants on Events.id = Event_participants.id_e
    left join participants on participants.id = Event_participants.id_p
    group by Events.id

select participants.id, participants.name_p, participants.sname_p, participants.brithday, COALESCE(json_agg(json_build_object(
    'id', Events.id, 'имя', Events.name_e, 'адрес', Events.adres))
    filter(where Events.id is not null), '[]') as Events
    from participants
    left join Event_participants on participants.id = Event_participants.id_p
    left join Events on Events.id = Event_participants.id_e
    group by participants.id
