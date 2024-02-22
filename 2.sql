-- 2. Книги и отзывы:
-- книга может иметь несколько отзывов
-- отзыв может принадлежать только одной книге
-- книга - название, жанр, год издания
-- отзыв - текст, оценка
create extension if not exists "uuid-ossp";

drop table if exists books, comments;

create table if not exists books
(
    book_id uuid primary key default uuid_generate_v4(),
    title text,
    genre text,
    publication_year int
);

create table if not exists comments
(
    comment_id uuid primary key default uuid_generate_v4(),
    book_id uuid references books(book_id),
    comment_text text,
    mark int
);

insert into books (title, genre, publication_year) values
('Гарри Поттер', 'Фэнтези', 1997),
('Евгений Онегин', 'Роман', 1825),
('Не существует', 'Отсутствует', 2024);

insert into comments (book_id, comment_text, mark) values
((select book_id from books where title = 'Гарри Поттер'),
 'Отличная книга, но есть пару недочётов...', 4),
((select book_id from books where title = 'Евгений Онегин'),
 'Лучший роман, так ещё и от любимого Пушкина!', 5),
((select book_id from books where title = 'Евгений Онегин'),
 'Как можно любить этого Пушкина?! Ужасные произведения у него!', 1);

select
    b.book_id,
    b.title,
    b.genre,
    b.publication_year,
    coalesce(json_agg(json_build_object(
            'id', com.comment_id, 'text', com.comment_text, 'mark', com.mark))
            filter (where com.comment_id is not null), '[]'
    ) as comments
from books b
left join comments com on b.book_id = com.book_id
group by b.book_id;
