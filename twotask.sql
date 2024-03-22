### 2. Поставщики и транспортные средства:
 - поставщик может иметь несколько транспортных средств
 - транспортное средство может принадлежать только одному поставщику
 - поставщик - название, телефон
 - транспортное средство - марка, модель, грузоподъемность;

create extension if not exists "uuid-ossp";

drop table if exists providers, vehicles;

 create table if not exists providers
 (
     id uuid primary key default uuid_generate_v4(),
     name text,
     phone_number text
 );

create table if not exists vehicles
 (
     id uuid primary key default uuid_generate_v4(),
     id_provider uuid references providers,
     brand text,
     model text,
     l_capacity text
 );

insert into providers (name, phone_number)
 values
     ('Ozon', '+79833352546'),
     ('Wildberries', '+79183352546'),
     ('Yandex Market', '+34503352546');

 insert into vehicles (id_provider, brand, model, l_capacity)
 values
     ((select id from providers where name = 'Ozon'), 'ЕКХ', '777', '160 kg'),
     ((select id from providers where name = 'Wildberries'), 'AМР', '001', '35 kg'),
     ((select id from providers where name = 'Ozon'), 'TTT', '999', '4 kg');

 select
     pro.id,
     pro.name,
     pro.phone_number,
     coalesce(json_agg(json_build_object('brand', ve.brand, 'model', ve.model, 'lif_capacity', ve.l_capacity))
              filter (where ve.id is not null), '[]') as vehic

 from providers as pro
          left join vehicles ve on pro.id = ve.id_provider
 group by pro.id;

