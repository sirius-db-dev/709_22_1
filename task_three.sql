create extension if not exists "uuid-ossp";

create table recipes(
 id uuid primary key default uuid_generate_v4(),
 title text,
 category text,
 price int
);

create table ingredients(
id uuid primary key default uuid_generate_v4(),
title text,
bio text,
category text
);

create table recipes_to_ingredients(
recipe_id uuid references recipes,
ingredient_id uuid references ingredients,
primary key (recipe_id, ingredient_id)
); 

insert into recipes(title, category, price)
values ('Soup', 'High', 80000),
('Meat', 'Low', 23),
('Cucumber with salad', 'Medium', 35),
('Salad', 'High', 9876);

insert into ingredients(title, bio, category)
values('Cucumber', 'This is prosto cucumber', 'Low'),
('Kapusta in Pekin', 'Ny i chto', 'Low'),
('Milk', 'Muuu', 'High'),
('Cows meat', 'Delishes', 'High'),
('Buluon', 'For soup', 'Low');

insert into recipes_to_ingredients(recipe_id, ingredient_id)
values ((select id from recipes where title = 'Soup'), 
(select id from ingredients where title = 'Buluon')),
((select id from recipes where title = 'Soup'), 
(select id from ingredients where title = 'Cows meat')),
((select id from recipes where title = 'Meat'), 
(select id from ingredients where title = 'Cows meat')),
((select id from recipes where title = 'Salad'), 
(select id from ingredients where title = 'Milk')),
((select id from recipes where title = 'Cucumber with salad'), 
(select id from ingredients where title = 'Kapusta in Pekin'));

select 
r.id,
r.title,
r.category,
r.price,
coalesce (jsonb_agg(json_build_object('id', i.id, 'title', i.title, 'bio', i.bio, 'category', i.category))
	filter (where i.id is not null), '[]') as ingredients
from recipes r
left join recipes_to_ingredients rti on r.id = rti.recipe_id
left join ingredients i on i.id = rti.ingredient_id
group by r.id;
