--Отрощенко Антон К0709-22/1

DROP TABLE if EXISTS book, review CASCADE;

CREATE TABLE book
(
    id int PRIMARY KEY,
    name_book TEXT,
    genre TEXT,
    date_create DATE
);

CREATE TABLE review
(
    id int PRIMARY KEY,
    text_review TEXT,
    rating FLOAT,
    book_id int REFERENCES review(id)
);

INSERT INTO book (id, name_book, genre, date_create)
VALUES (1, 'Metro 2033', 'Fantasy', '2003-08-23'),
       (2, 'Metro 2035', 'Fantasy', '2005-04-20'),
       (3, 'Garry Potter', 'Drama', '2000-04-12');

INSERT INTO review (id, text_review, rating, book_id)
VALUES (1, 'Good', 7.8, 1),
       (2, 'Medium', 5.4, 2),
       (3, 'Great', 9.7, 3),
       (4, 'Very good', 8.5, 3);


SELECT book.name_book, book.genre, book.date_create,
COALESCE(json_agg(json_build_object('txt', review.text_review, 'rt', review.rating))
FILTER(WHERE review.book_id NOTNULL), '[]')
FROM book
LEFT JOIN review on review.book_id = book.id
GROUP BY book.id;
