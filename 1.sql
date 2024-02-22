-- 1. Товар и отзывы:
-- товар может иметь несколько отзывов
-- отзыв может принадлежать только одному товару
-- товар - название, описание, цена
-- отзыв - текст, оценка
create extension if not exists "uuid-ossp";

drop table if exists products, comments;

create table if not exists products
(
    product_id uuid primary key default uuid_generate_v4(),
    title text,
    description text,
    price float
);

create table if not exists comments
(
    comment_id uuid primary key default uuid_generate_v4(),
    product_id uuid references products(product_id),
    comment_text text,
    mark int
);

insert into products (title, description, price) values
('Привет', 'Привет мир! Я родился!', 300.0),
('Ничего', 'Буквально ничего, продаю воздух', 666.66),
('Курсы', 'Курсы по Python и PostgreSQL от профессиональных разработчиков', 1999.99);

insert into comments (product_id, comment_text, mark) values
((select product_id from products where title = 'Привет'),
 'Прикольный товар, мне понравилось!', 5),
((select product_id from products where title = 'Курсы'),
 'Лучшие курсы на свете, стал Senior разработчиком за пару дней!', 5),
((select product_id from products where title = 'Курсы'),
 'Худшие курсы на свете, никогда не берите их!', 1);

select
    prod.product_id,
    prod.title,
    prod.description,
    prod.price,
    coalesce(json_agg(json_build_object(
            'id', com.comment_id, 'text', com.comment_text, 'mark', com.mark))
            filter (where com.comment_id is not null), '[]'
    ) as comments
from products prod
left join comments com on prod.product_id = com.product_id
group by prod.product_id;
