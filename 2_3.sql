create extension if not exists "uuid-ossp";
drop table if exists ingredients, recipe, ingredients_to_recipe cascade;

create table ingredients
(
	id uuid primary key default uuid_generate_v4(),
	title_ingr text,
	category text,
	price int
);

create table recipe
(
	id uuid primary key default uuid_generate_v4(),
	title_recipe text,
	opisanie text,
	category text
);

create table ingredients_to_recipe
(
	ingredients_id uuid references ingredients,
	recipe_id uuid references recipe,
	primary key(ingredients_id, recipe_id)
);


insert into ingredients(title_ingr, category, price)
values ('moloko', 'sour milk', 89),
		('banan', 'fruit', 30),
		('kakao', 'groceries', 120),
		('хлеб', 'bakery products', 50);
	
insert into recipe(title_recipe, opisanie, category)
values ('молочный коктейл', 'берешь молоко и банан и доне', 'быстрое приготовдлние'),
		('какао', 'молоко и какао пророшек', 'быстрое приготовление'), 
		('кекс', 'эх', 'тут подождать надо');
	
insert into ingredients_to_recipe(ingredients_id, recipe_id)
values ((select id from ingredients where title_ingr = 'moloko'),
    (select id from recipe where title_recipe = 'молочный коктейл')),
  ((select id from ingredients where title_ingr = 'moloko'),
    (select id from recipe where title_recipe = 'какао')),
  ((select id from ingredients where title_ingr = 'banan'),
    (select id from recipe where title_recipe = 'молочный коктейл')),
  ((select id from ingredients where title_ingr = 'banan'),
    (select id from recipe where title_recipe = 'какао')),
  ((select id from ingredients where title_ingr = 'kakao'),
    (select id from recipe where title_recipe = 'какао'));

select
  i.id,
  i.title_ingr,
  i.category,
  i.price,
  coalesce(jsonb_agg(jsonb_build_object(
  'id', r.id, 'title_recipe', r.title_recipe, 'opisanie', r.opisanie,
  'category', r.category))
  filter (where r.id is not null), '[]') as recipe
  
from ingredients i
left join ingredients_to_recipe ir on i.id = ir.ingredients_id
left join recipe r on r.id = ir.recipe_id
group by i.id;
