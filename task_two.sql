create extension if not exists "uuid-ossp";

create table authors(
 id uuid primary key default uuid_generate_v4(),
 first_name text,
 last_name text,
 birthday date
);

create table books(
id uuid primary key default uuid_generate_v4(),
title text,
genre text,
year_f_public int
);

create table authors_to_books(
author_id uuid references authors,
book_id uuid references books,
primary key(author_id, book_id)
);

insert into authors (first_name, last_name, birthday)
values ('Alexey', 'Shtei', '2000-05-17'),
('Anastasiya', 'Podorojnaya', '1991-01-31'),
('Dan', 'Rover', '2004-05-23'),
('Anastasiya', 'Zorina', '2006-08-08');

insert into books (title, genre, year_f_public)
values ('Pavuk', 'Rome', 2000),
('Dima and Jameson', 'Humor', 2024),
('Nastya and sikvel', 'Drama', 2022);

insert into authors_to_books(author_id, book_id)
values((select id from authors where last_name = 'Shtei'),
(select id from books where title = 'Pavuk')),
((select id from authors where last_name = 'Shtei'),
(select id from books where title = 'Dima and Jameson')),
((select id from authors where last_name = 'Rover'),
(select id from books where title = 'Pavuk')),
((select id from authors where last_name = 'Podorojnaya'),
(select id from books where title = 'Nastya and sikvel')),
((select id from authors where last_name = 'Zorina'),
(select id from books where title = 'Nastya and sikvel'));

select 
a.id,
a.first_name,
a.last_name,
a.birthday,
coalesce (jsonb_agg(json_build_object('id', b.id, 'title', b.title, 'genre', b.genre, 'year of public', b.year_f_public))
	filter (where b.id is not null), '[]') as books
from authors a
left join authors_to_books atb on a.id = atb.author_id
left join books b on b.id = atb.book_id
group by a.id;