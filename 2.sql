-- 2. Игры и покупатели:
-- у игры может быть много покупателей
-- у покупателя может быть много игр
-- игра - название, жанр, цена
-- покупатель - никнейм, дата регистрации
create extension if not exists "uuid-ossp";

drop table if exists games, buyers, game_to_buyer;

create table if not exists games
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    genre text,
    price float
);

create table if not exists buyers
(
    id uuid primary key default uuid_generate_v4(),
    nickname text,
    registration_date date
);

create table if not exists game_to_buyer
(
    game_id uuid references games,
    buyer_id uuid references buyers,
    primary key (game_id, buyer_id)
);

insert into games (title, genre, price) values
('Call of Duty 2', 'Шутер от 1 лица', 9.99),
('Far Cry 3', 'Шутер от 1 лица', 29.99),
('GTA The Definitive Edition', 'Шутер от 3 лица', 69.99),
('Forza Horizon 4', 'Гонки', 49.99);

insert into buyers (nickname, registration_date) values
('lifelongCat', '2020-04-13'),
('alexx', '2021-06-09');

insert into game_to_buyer (game_id, buyer_id) values
((select id from games where title = 'Call of Duty 2'),
 (select id from buyers where nickname = 'lifelongCat')),
((select id from games where title = 'Far Cry 3'),
 (select id from buyers where nickname = 'lifelongCat')),
((select id from games where title = 'Forza Horizon 4'),
 (select id from buyers where nickname = 'lifelongCat')),
((select id from games where title = 'Far Cry 3'),
 (select id from buyers where nickname = 'alexx'));

select
    g.title,
    g.genre,
    g.price,
    coalesce(jsonb_agg(jsonb_build_object(
        'nickname', b.nickname, 'registration_date', b.registration_date
        )) filter (where b.id is not null), '[]'
    ) as buyers
from games g
left join game_to_buyer gb on g.id = gb.game_id
left join buyers b on b.id = gb.buyer_id
group by g.id;

select
    b.nickname,
    b.registration_date,
    coalesce(jsonb_agg(jsonb_build_object(
        'title', g.title, 'genre', g.genre, 'price', g.price
        )) filter (where g.id is not null), '[]'
    ) as games
from buyers b
left join game_to_buyer gb on b.id = gb.buyer_id
left join games g on g.id = gb.game_id
group by b.id;
