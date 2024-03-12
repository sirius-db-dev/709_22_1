create extension if not exists "uuid-ossp";

create table tasks (
    id uuid primary key default uuid_generate_v4(),
    name text,
    description text,
    difficulty int
);


create table students (
    id uuid primary key default uuid_generate_v4(),
    nickname text,
    registration_date date,
    rating int
);


create table task_students (
    task_id uuid references tasks(id),
    student_id uuid references students(id),
    primary key (task_id, student_id)
);


insert into tasks (name, description, difficulty)
VALUES
    ('T1', 'D1', 1),
    ('T2', 'D2', 2),
    ('T3', 'D3', 3);

INSERT INTO students (nickname, registration_date, rating)
VALUES
    ('S1', '2023-01-01', 1),
    ('S2', '2023-01-02', 2),
    ('S3', '2023-01-03', 3);

INSERT INTO task_students (task_id, student_id)
values
	((select id from tasks where name='T1'), (select id from students where nickname='S1')),
    ((select id from tasks where name='T1'), (select id from students where nickname='S2')),
    ((select id from tasks where name='T2'), (select id from students where nickname='S2')),
    ((select id from tasks where name='T2'), (select id from students where nickname='S3')),
    ((select id from tasks where name='T3'), (select id from students where nickname='S1')),
    ((select id from tasks where name='T3'), (select id from students where nickname='S3'));

SELECT s.id,
       s.nickname,
       s.registration_date,
       s.rating,
       json_agg(json_build_object(
           'id', t.id,
           'name', t.name,
           'description', t.description,
           'difficulty', t.difficulty
       )) AS tasks
FROM students s
LEFT JOIN task_students ts ON s.id = ts.student_id
LEFT JOIN tasks t ON ts.task_id = t.id
GROUP BY s.id;
