create extension if not exists "uuid-ossp";
drop table if exists video, customer;

create table customer (
	id uuid primary key default uuid_generate_v4(),
	name text,
	reg_date date
);

create table video (
	id uuid primary key default uuid_generate_v4(),
	title text,
	creating_date date,
	duration float
);


create table customer_to_video (
	customer_id uuid references customer,
	video_id uuid references video,
	primary key (customer_id, video_id)
);


insert into customer(name, reg_date) 
values
('Матвей', '2020/06/28'),
('Михаил', '2015/02/14'),
('Марко', '2009/10/01');

insert into video(title, creating_date, duration) 
values
('Обезьяна ест бургеры', '2024/12/31', 5.48),
('С новым годом', '2024/06/18', 3.0),
('НОВОСТИ МИРА', '2022/02/24', 6.59);

insert into customer_to_video(customer_id, video_id)
values
    ((select id from customer where name = 'Матвей'),
     (select id from video where title = 'Обезьяна ест бургеры')),
    ((select id from customer where name = 'Матвей'),
     (select id from video where title = 'НОВОСТИ МИРА')),
    ((select id from customer where name = 'Марко'),
     (select id from video where title = 'НОВОСТИ МИРА')),
    ((select id from customer where name = 'Михаил'),
     (select id from video where title = 'Обезьяна ест бургеры'));
     
select
  a.id,
  a.name,
  a.reg_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'title', f.title, 'creating date', f.creating_date, 'duration', f.duration))
      filter (where f.id is not null), '[]') as video
from customer a
left join customer_to_video af on a.id = af.customer_id
left join video f on f.id = af.video_id
group by a.id;

select
  a.id,
  a.title,
  a.creating_date,
  a.duration,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', f.id, 'nickname', f.name, 'registration date', f.reg_date))
      filter (where f.id is not null), '[]') as customer
from video a
left join customer_to_video af on a.id = af.video_id
left join customer f on f.id = af.customer_id
group by a.id;
