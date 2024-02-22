drop table products;
drop table reviews;

create table if not exists products(
id int primary key generated always as identity,
title text,
bio text,
price int
);

create table if not exists reviews (
review_id int primary key generated always as identity,
text_review text,
product_id int references products,
total float
);

INSERT INTO products (title, bio, price) VALUES
    ('Product X', 'This is chips', 99.99),
    ('Product Y', 'This is potato', 149.99),
    ('Product Z', 'This is my diner', 199.99);

insert into reviews(text_review, product_id, total) values
('Мы не знаем что это такое', 1, 9.7),
('Вкусно очень вкусно', 3, 1.1),
('Картошка - годная тема', 2, 3.1),
('Не согласен про картошку', 2, 1.0);

select *
from products 
		left join reviews on products.id = reviews.product_id;

select
  pr.id,
  pr.title,
  pr.bio,
  pr.price,
  coalesce(json_agg(json_build_object(
    'id', rev.review_id, 'product_id', rev.product_id, 'text_review', rev.text_review, 'total', rev.total))
      filter (where rev.product_id is not null), '[]')
        as rev
from products pr
left join reviews rev on pr.id = rev.product_id
group by pr.id;