-- 1. Рецепты и ингредиенты
-- ингридиент может быть использован в нескольких рецептах
-- рецепт может использовать несколько ингредиентов
-- ингридиент - название, категория, цена
-- рецепт - название, описание, категория
create extension if not exists "uuid-ossp";

drop table if exists ingredients, recipes, ingredient_to_recipe;

create table if not exists ingredients
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    category text,
    price float
);

create table if not exists recipes
(
    id uuid primary key default uuid_generate_v4(),
    title text,
    description text,
    category text
);

create table if not exists ingredient_to_recipe
(
    ingredient_id uuid references ingredients,
    recipe_id uuid references recipes,
    primary key (ingredient_id, recipe_id)
);

insert into ingredients (title, category, price) values
('Молоко', 'Жидкость', 89.50),
('Яйца', 'Фермерские', 144.44),
('Колбаса', 'Мясное', 179.00),
('Конфеты', 'Сладости', 300.00);

insert into recipes (title, description, category) values
('Блины', 'Вкусные простые блины от бабушки', 'Масленица'),
('Яичница', 'Лучший питательный завтрак', 'Завтрак');

insert into ingredient_to_recipe (ingredient_id, recipe_id) values
((select id from ingredients where title = 'Молоко'),
 (select id from recipes where title = 'Блины')),
((select id from ingredients where title = 'Яйца'),
 (select id from recipes where title = 'Блины')),
((select id from ingredients where title = 'Яйца'),
 (select id from recipes where title = 'Яичница')),
((select id from ingredients where title = 'Колбаса'),
 (select id from recipes where title = 'Яичница'));

select
    i.title,
    i.category,
    i.price,
    coalesce(jsonb_agg(jsonb_build_object(
        'title', r.title, 'description', r.description, 'category', r.category
        )) filter (where r.id is not null), '[]'
    ) as used_in
from ingredients i
left join ingredient_to_recipe ir on i.id = ir.ingredient_id
left join recipes r on r.id = ir.recipe_id
group by i.id;

select
    r.title,
    r.description,
    r.category,
    coalesce(jsonb_agg(jsonb_build_object(
        'title', i.title, 'category', i.category, 'price', i.price
        )) filter (where i.id is not null), '[]'
    ) as ingredients
from recipes r
left join ingredient_to_recipe ir on r.id = ir.recipe_id
left join ingredients i on i.id = ir.ingredient_id
group by r.id;
