-- Active: 1708455166224@@127.0.0.1@38746

create EXTENSION if not exists "uuid-ossp";

drop table if exists provider, transports;

create table provider
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    name TEXT,
    telephone text
);


create table transports
(
    id uuid PRIMARY key DEFAULT uuid_generate_v4(),
    provider_id uuid REFERENCES provider(id),
    brand TEXT,
    model text,
    permissible_weight int 
);

insert into provider (name, telephone)
values
    ('First_prov', '89894475904'),
    ('Second_prov', '89892438493'),
    ('Third_prov', '89485038595');

insert into transports (provider_id, brand, model, permissible_weight)
VALUES
    ((select id from provider where name='First_prov'), 'Lada', '3485', 320494),
    ((select id from provider where name='First_prov'), 'Audi', '5695', 503494),
    ((select id from provider where name='Second_prov'), 'Tesla', '37594', 463404),
    ((select id from provider where name='Second_prov'), 'BMW', '1033', 40405),
    ((select id from provider where name='Third_prov'), 'Haval', '94050', 505050),
    ((select id from provider where name='Third_prov'), 'Hyundai', '333', 7979);

SELECT
    p.id,
    p.name,
    p.telephone,
    COALESCE(json_agg(json_build_object('id', t.id, 'provider_id', t.provider_id, 'brand', t.brand, 'model', t.model, 'permissible_weight', t.permissible_weight))
    filter (where t.id is not null), '[]') as transports

from provider p
left join transports t on p.id=t.provider_id
group by p.id;

