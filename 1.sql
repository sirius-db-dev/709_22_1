create extension if not exists "uuid-ossp";

drop table if exists authors, books, author_to_book cascade;

create table authors
(
    id uuid primary key default uuid_generate_v4(),
    at_first_name text,
    at_last_name text,
    at_date date
);

create table books
(
    id uuid primary key default uuid_generate_v4(),
    bk_name text,
    bk_genre text,
    bk_date date
);

create table author_to_book
(
    author_id uuid references authors,
    book_id  uuid references books,
    primary key (author_id, book_id)
);

insert into authors(at_first_name, at_last_name, at_date)
values ('Антон', 'Отрощенко', '1999-02-09'),
       ('Никита', 'Лобода', '1965-05-13'),
       ('Артем', 'Кривенко', '1976-04-05'),
       ('Влад', 'Аргун', '1987-01-23'),
       ('Михаил', 'Носков', '1986-11-20');


insert into books(bk_name, bk_genre, bk_date)
VALUES ('Metro 2033', 'Fantasy', '2005-08-23'),
       ('Metro 2034', 'Fantasy', '2007-04-20'),
       ('Metro 2035', 'Fantasy', '2009-04-20'),
       ('Garry Potter', 'Drama', '2001-04-12');

insert into author_to_book(author_id, book_id)
values
    ((select id from authors where at_last_name = 'Отрощенко'),
     (select id from books where bk_name = 'Metro 2033')),
    ((select id from authors where at_last_name = 'Отрощенко'),
     (select id from books where bk_name = 'Metro 2034')),
    ((select id from authors where at_last_name = 'Лобода'),
     (select id from books where bk_name = 'Metro 2033')),
    ((select id from authors where at_last_name = 'Лобода'),
     (select id from books where bk_name = 'Metro 2034')),
    ((select id from authors where at_last_name = 'Носков'),
     (select id from books where bk_name = 'Metro 2035')),
    ((select id from authors where at_last_name = 'Кривенко'),
     (select id from books where bk_name = 'Garry Potter')),
    ((select id from authors where at_last_name = 'Аргун'),
     (select id from books where bk_name = 'Metro 2035')),
    ((select id from authors where at_last_name = 'Носков'),
     (select id from books where bk_name = 'Garry Potter'));


select
  at.id,
  at.at_first_name,
  at.at_last_name,
  at.at_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'id', bk.id, 'name', bk.bk_name, 'genre', bk.bk_genre, 'date', bk.bk_date))
      filter (where bk.id is not null), '[]') as books
from authors at
left join author_to_book ba on at.id = ba.author_id
left join books bk on bk.id = ba.book_id
group by at.id;


select
  bk.id,
  bk.bk_name,
  bk.bk_genre,
  bk.bk_date,
  coalesce(json_agg(json_build_object(
    'id', at.id, 'first_name', at.at_first_name, 
    'last_name', at.at_last_name, 'date', at.at_date))
      filter (where at.id is not null), '[]') as authors
from books bk
left join author_to_book ba on bk.id = ba.book_id
left join authors at on at.id = ba.author_id
group by bk.id;

