create EXTENSION if not EXISTS "uuid-ossp"; 

drop table if exists tasks, students, student_assignments CASCADE;

create table tasks
(
    id uuid primary key default uuid_generate_v4(),
    name_t text,
    description text,
    complexity text
);

create table students
(
    id uuid primary key default uuid_generate_v4(),
    name_s text,
    data_s text,
    rating text
);

create table student_assignments
(
    id_t uuid REFERENCES tasks,
    id_s uuid references students,
    primary key (id_t, id_s)
);

insert into tasks(name_t, description, complexity)
values('задача 1', 'функция', 'сложно'),
('задача 2', 'сумма и разность', 'легко'),
('задача 3', 'умножение и деление', 'нормально');

INSERT into students(name_s, data_s, rating)
values ('вася', '2005-04-24', 'высокий'),
('петя', '2007-08-09', 'средний'),
('женя', '2000-01-15', 'маленький'),
('антон', '2006-02-09', 'минимальный');

insert into student_assignments(id_t, id_s)
values 
((select id from tasks WHERE name_t = 'задача 3'), (select id from students where name_s = 'вася')),
((select id from tasks WHERE name_t = 'задача 3'), (select id from students where name_s = 'антон')),
((select id from tasks WHERE name_t = 'задача 2'), (select id from students where name_s = 'антон'));


select  tasks.id, tasks.name_t, tasks.description, tasks.complexity, COALESCE(json_agg(json_build_object(
    'id', students.id, 'name_s', students.name_s, 'data_s', students.data_s, 'rating', students.rating))
    filter(where students.id is not NULL), '[]') as students
    from tasks
    left join student_assignments on tasks.id = student_assignments.id_t
    left join students on students.id = student_assignments.id_s
    group by tasks.id

select  students.id, students.name_s, students.data_s, students.rating, COALESCE(json_agg(json_build_object(
    'id', tasks.id, 'name_t', tasks.name_t, 'description', tasks.description, 'сложность', tasks.complexity))
    filter(where tasks.id is not NULL), '[]') as tasks
    from students
    left join student_assignments on students.id = student_assignments.id_s
    left join tasks on tasks.id = student_assignments.id_t
    group by students.id
