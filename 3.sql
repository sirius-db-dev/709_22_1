-- 3. Рецепты и комментарии:
-- рецепт может иметь несколько комментариев
-- комментарий может принадлежать только одному рецепту
-- рецепт - название, описание, категория
-- комментарий - текст, дата публикации
create extension if not exists "uuid-ossp";

drop table if exists recipes, comments;

create table if not exists recipes
(
    recipe_id uuid primary key default uuid_generate_v4(),
    title text,
    description text,
    category text
);

create table if not exists comments
(
    comment_id uuid primary key default uuid_generate_v4(),
    recipe_id uuid references recipes(recipe_id),
    comment_text text,
    publication_date date
);

insert into recipes (title, description, category) values
('Лазанья', 'Вкусная мясная запеканка всего за 1 час', 'Мясное'),
('Овощи', 'Самая вкусная и диетическая еда для веганов', 'Веганское'),
('Кисель', 'Лучший напиток к столу', 'Напитки');

insert into comments (recipe_id, comment_text, publication_date) values
((select recipe_id from recipes where title = 'Лазанья'),
 'Реально вкусно, но у меня заболел кот, поэтому 3 звезды', '2024-01-01'),
((select recipe_id from recipes where title = 'Лазанья'),
 'Впервые получилась вкусная лазанья, спасибо за рецепт :)', '2023-01-01'),
((select recipe_id from recipes where title = 'Овощи'),
 'Да кто такие ваши веганы!! Осуждаю их, только мясо надо есть, белки!!', '2023-02-24');

select
    rec.recipe_id,
    rec.title,
    rec.description,
    rec.category,
    coalesce(json_agg(json_build_object(
            'id', com.comment_id, 'text', com.comment_text, 'publication_date', com.publication_date))
            filter (where com.comment_id is not null), '[]'
    ) as comments
from recipes rec
left join comments com on rec.recipe_id = com.recipe_id
group by rec.recipe_id;
