create extension if not exists "uuid-ossp";


drop table if exists articles, comments;

create table articles
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    title text,
    text text,
    pub_date date
);

create table comments
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    article_id uuid REFERENCES articles(id),
    text text,
    amount_likes BIGINT
);

insert into articles (title, text, pub_date)
values
    ('title1', 'text1', '2022/09/01'),
    ('title2', 'text2', '2023/03/23'),
    ('title3', 'text3', '2013/01/11'),
    ('title4', 'text4', '2014/09/09');

insert into comments (article_id, text, amount_likes)
values
    ((select id from articles where title='title1'), 'comment1WOW', 100),
    ((select id from articles where title='title2'), 'comment2OMG', 2024),
    ((select id from articles where title='title3'), 'comment3LMAO', 2),
    ((select id from articles where title='title3'), 'comment3?!@#', 1);

select 
    a.id,
    a.title,
    a.text,
    a.pub_date,
    coalesce(json_agg(json_build_object('id', c.id, 'text', c.text, 'amount_likes', c.amount_likes))
    filter(where c.id is not null), '[]') as comments
from articles a
left join comments c on a.id=c.article_id
group by a.id;
