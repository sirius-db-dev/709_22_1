---1

create extension if not exists "uuid-ossp";

drop table if exists parties, members, party_to_member cascade;

create table members
(
    id         uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name  text,
    birth_date date
);

create table parties
(
    id          uuid primary key default uuid_generate_v4(),
    title       text,
    party_date 	date,
    place       text
);

create table party_to_member
(
    member_id   uuid references members,
    party_id    uuid references parties,
    primary key (member_id, party_id)
);

insert into members(first_name, last_name, birth_date)
values ('Marko', 'Arsenovich', '2005-12-16'),
	   ('Michael', 'Noskov', '2006-02-14'),
	   ('Matvey', 'Ozornin', '2006-04-23');

insert into parties(title, party_date, place)
values ('Hatters', '2024-03-13', 'La Punto'),
	   ('The MAN', '2024-04-04', 'Sigma Sirius'),
	   ('What does the Fox say?', '2077-12-12', 'Park Gorkogo');

insert into party_to_member(member_id, party_id)
values
    ((select id from members where last_name = 'Arsenovich'),
     (select id from parties where title = 'Hatters')),
    ((select id from members where last_name = 'Arsenovich'),
     (select id from parties where title = 'The MAN')),
    ((select id from members where last_name = 'Noskov'),
     (select id from parties where title = 'Hatters'));

select
  m.id,
  m.first_name,
  m.last_name,
  m.birth_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', p.id, 'title', p.title,
    'date', p.party_date, 'place', p.place))
      filter (where p.id is not null), '[]') as parties
from members m
left join party_to_member pm on m.id = pm.member_id
left join parties p on p.id = pm.party_id
group by m.id;

select
  p.id,
  p.title,
  p.party_date,
  p.place,
  coalesce(json_agg(json_build_object(
    'id', m.id, 'first_name', m.first_name,
    'last_name', m.last_name, 'birth_date', m.birth_date))
      filter (where m.id is not null), '[]') as members
from parties p
left join party_to_member pm on p.id = pm.party_id
left join members m on m.id = pm.member_id
group by p.id;


---2

drop table if exists shops, providers, shop_to_provider cascade;

create table providers
(
    id            uuid primary key default uuid_generate_v4(),
    provider_name text,
    phone_number  text
);

create table shops
(
    id           uuid primary key default uuid_generate_v4(),
    shop_name    text,
    shop_address text
);

create table shop_to_provider
(
    provider_id uuid references providers,
    shop_id     uuid references shops,
    primary key (provider_id, shop_id)
);

insert into providers(provider_name, phone_number)
values ('Uncle Ashot', '+79184060796'),
	   ('Fast&Taste', '89883026477'),
	   ('Samokat', '+79999999999');

insert into shops(shop_name, shop_address)
values ('Okey', 'Международная, 13'),
	   ('Kolobok', 'Воскресенская, 12'),
	   ('Magnit', 'Горького, 87');

insert into shop_to_provider(provider_id, shop_id)
values
    ((select id from providers where provider_name = 'Uncle Ashot'),
     (select id from shops where shop_name = 'Okey')),
    ((select id from providers where provider_name = 'Uncle Ashot'),
     (select id from shops where shop_name = 'Kolobok')),
    ((select id from providers where provider_name = 'Fast&Taste'),
     (select id from shops where shop_name = 'Okey'));

select
  p.id,
  p.provider_name,
  p.phone_number,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', s.id, 'name', s.shop_name, 'address', s.shop_address))
      filter (where s.id is not null), '[]') as shops
from providers p
left join shop_to_provider sp on p.id = sp.provider_id
left join shops s on s.id = sp.shop_id
group by p.id;

select
  s.id,
  s.shop_name,
  s.shop_address,
  coalesce(json_agg(json_build_object(
    'id', p.id, 'name', p.provider_name, 'phone', p.phone_number))
      filter (where p.id is not null), '[]') as providers
from shops s
left join shop_to_provider sp on s.id = sp.shop_id
left join providers p on p.id = sp.provider_id
group by s.id;

--3

drop table if exists appeals, clients, appeal_to_provider cascade;

create table clients
(
    id            uuid primary key default uuid_generate_v4(),
    first_name    text,
    last_name     text,
    phone_number  text
);

create table appeals
(
    id            uuid primary key default uuid_generate_v4(),
    appeal_number int,
    appeal_date   date,
    appeal_status text
);

create table appeal_to_provider
(
    client_id     uuid references clients,
    appeal_id     uuid references appeals,
    primary key   (client_id, appeal_id)
);

insert into clients(first_name, last_name, phone_number)
values ('Marko', 'Arsenovich', '+79184060795'),
	   ('Michael', 'Noskov', '89883026478'),
	   ('Matvey', 'Ozornin', '+78888888888');

insert into appeals(appeal_number, appeal_date, appeal_status)
values (123, '2022-12-16', 'Одобрено'),
	   (777, '2023-10-23', 'На рассмотрении'),
	   (1337, '2024-02-20', 'Отклонено');

insert into appeal_to_provider(client_id, appeal_id)
values
    ((select id from clients where last_name = 'Arsenovich'),
     (select id from appeals where appeal_number = 123)),
    ((select id from clients where last_name = 'Arsenovich'),
     (select id from appeals where appeal_number = 777)),
    ((select id from clients where last_name = 'Noskov'),
     (select id from appeals where appeal_number = 123));

select
  c.id,
  c.first_name,
  c.last_name,
  c.phone_number,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', a.id, 'number', a.appeal_number, 'date', a.appeal_date,
    'status', a.appeal_status))
      filter (where a.id is not null), '[]') as appeals
from clients c
left join appeal_to_provider ap on c.id = ap.client_id
left join appeals a on a.id = ap.appeal_id
group by c.id;

select
  a.id,
  a.appeal_number,
  a.appeal_date,
  a.appeal_status,
  coalesce(json_agg(json_build_object(
    'id', c.id, 'first_name', c.first_name, 'last_name', c.last_name,
    'phone', c.phone_number))
      filter (where c.id is not null), '[]') as clients
from appeals a
left join appeal_to_provider ap on a.id = ap.appeal_id
left join clients c on c.id = ap.client_id
group by a.id;
