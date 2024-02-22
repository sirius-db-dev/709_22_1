--Отрощенко Антон К0709-22/1

DROP TABLE if EXISTS cmd, workers CASCADE;

CREATE TABLE cmd
(
    id int PRIMARY KEY,
    name_cmd TEXT,
    date_create DATE
);

CREATE TABLE workers
(
    id int PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    job_title TEXT,
    cmd_id int REFERENCES workers(id)
);

INSERT INTO cmd (id, name_cmd, date_create)
VALUES (1, 'Command_1', '2024-02-22'),
       (2, 'Command_2', '2023-12-11'),
       (3, 'Command_3', '2022-06-30');

INSERT INTO workers (id, first_name, last_name, job_title, cmd_id)
VALUES (1, 'Anton', 'Otroschenko', 'Middle', 1),
       (2, 'Artem', 'Nesterov', 'Junior', 2),
       (3, 'Nikita', 'Loboda', 'Senior', 3),
       (4, 'Vasya', 'Pupkin', 'Junior', 3);


SELECT cmd.name_cmd, cmd.date_create,
COALESCE(json_agg(json_build_object('fn', workers.first_name, 'ln', workers.last_name, 'jt', workers.job_title))
FILTER(WHERE workers.cmd_id NOTNULL), '[]')
FROM cmd
LEFT JOIN workers on workers.cmd_id = cmd.id
GROUP BY cmd.id;
