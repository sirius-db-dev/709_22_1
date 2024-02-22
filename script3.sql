create extension if not exists "uuid-ossp";


drop table if exists courses, rates;

create table courses
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    title text,
    description text
);

create table rates
(
    id uuid primary key DEFAULT uuid_generate_v4(),
    course_id uuid REFERENCES courses(id),
    text text,
    rate NUMERIC
);

insert into courses (title, description)
values
    ('Python for beginners', 'careless childhood'),
    ('DBs for intermediates', 'throw down your fears'),
    ('Rewrite everything in Rust', 'fantastic story'),
    ('Lisp for PhD', 'truth of our lives');

insert into rates (course_id, text, rate)
values
    ((select id from courses where title='Python for beginners'), 'rate1WOW', 7),
    ((select id from courses where title='DBs for intermediates'), 'rate2OMG', 6),
    ((select id from courses where title='Rewrite everything in Rust'), 'rate3LMAO', 5),
    ((select id from courses where title='Rewrite everything in Rust'), 'rate3?!@#', 4);

select 
    c.id,
    c.title,
    c.description,
    coalesce(json_agg(json_build_object('id', r.id, 'text', r.text, 'rate', r.rate))
    filter(where r.id is not null), '[]') as rates
from courses c
left join rates r on c.id=r.course_id
group by c.id;
