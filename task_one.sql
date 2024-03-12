create extension if not exists "uuid-ossp";

create table agregators(
 id uuid primary key default uuid_generate_v4(),
 title text,
 telephone text
);

create table cabdrivers(
id uuid primary key default uuid_generate_v4(),
first_name text,
last_name text,
telephone text, 
auto text
);

create table agregators_to_cabdrivers(
agregator_id uuid references agregators,
cabdriver_id uuid references cabdrivers,
primary key (agregator_id, cabdriver_id)
); 

insert into agregators(title, telephone)
values ('Yandex Go', '88005553535'),
('Maxim', '88003535555'),
('Uber', '8800454545');

insert into cabdrivers(first_name, last_name, telephone, auto)
values('Rayan', 'Gosling', '78003534564', 'Haval Naval Uber X'),
('Kamberbek', 'Huseinovich', '35004562139', 'Toyota Camry'),
('leon', 'Gde', '79003634564', 'Haval Naval Uber X'),
('Dima', 'Vasilenko', '79453634564', 'Haval X');

insert into agregators_to_cabdrivers(agregator_id, cabdriver_id)
values ((select id from agregators where title = 'Yandex Go'),
     (select id from cabdrivers where last_name = 'Gosling')),
     ((select id from agregators where title = 'Maxim'),
     (select id from cabdrivers where last_name = 'Gosling')),
     ((select id from agregators where title = 'Uber'),
     (select id from cabdrivers where last_name = 'Gosling')),
     ((select id from agregators where title = 'Yandex Go'),
     (select id from cabdrivers where last_name = 'Gde')),
     ((select id from agregators where title = 'Uber'),
     (select id from cabdrivers where first_name = 'Dima'));

select
  cb.id,
  cb.first_name,
  cb.last_name,
  cb.auto,
  cb.telephone,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', a.id, 'title', a.title, 'telephone', a.telephone))
      filter (where cb.id is not null), '[]') as cabdrivers
from agregators a
left join agregators_to_cabdrivers acb on a.id = acb.agregator_id
left join cabdrivers cb on cb.id = acb.cabdriver_id
group by cb.id;

