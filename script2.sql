create extension if not exists "uuid-ossp";


drop table if exists books, rates;

create table books
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    title text,
    genre text,
    pub_date date
);

create table rates
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    book_id uuid REFERENCES books(id),
    text text,
    rate NUMERIC
);

insert into books (title, genre, pub_date)
values
    ('Book1', 'novel', '2022/09/01'),
    ('Book2', 'fantastics', '2023/03/23'),
    ('Book3', 'non-fiction', '2013/01/11'),
    ('Book4', 'fiction', '2014/09/09');

insert into rates (book_id, text, rate)
values
    ((select id from books where title='Book1'), 'rate1WOW', 7),
    ((select id from books where title='Book2'), 'rate2OMG', 6),
    ((select id from books where title='Book3'), 'rate3LMAO', 5),
    ((select id from books where title='Book3'), 'rate3?!@#', 4);

select 
    b.id,
    b.title,
    b.genre,
    b.pub_date,
    coalesce(json_agg(json_build_object('id', r.id, 'text', r.text, 'rate', r.rate))
    filter(where r.id is not null), '[]') as rates
from books b
left join rates r on b.id=r.book_id
group by b.id;
