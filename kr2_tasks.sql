drop table if exists tasks, workers, task_to_worker cascade;

create table tasks (
    id uuid primary key default uuid_generate_v4(),
    name text,
    descr text,
    status text
);

create table workers (
    id uuid primary key default uuid_generate_v4(),
    first_name text,
    last_name text,
    job_title text
);

create table task_to_worker (
    task_id uuid references tasks,
    worker_id uuid references workers
);

insert into tasks (name, descr, status)
values
('homework', 'math', 'planing'),
('personal project', 'neofetch replacer', 'deprecated');

insert into workers (first_name, last_name, job_title)
values
('Matvey', 'Ozornin', 'student'),
('Fedya', 'Eremin', 'student'),
('Marko', 'Arsenovich', 'junior');

insert into task_to_worker (task_id, worker_id)
values (
    (select t.id from tasks as t where t.name = 'homework'),
    (select w.id from workers as w where w.last_name = 'Ozornin')
),
(
    (select t.id from tasks as t where t.name = 'personal project'),
    (select w.id from workers as w where w.last_name = 'Eremin')
);

select
    w.id,
    w.first_name,
    w.last_name,
    w.job_title,
    coalesce(json_agg(json_build_object(
        'id', t.id, 'description', t.descr,
        'status', t.status
    ))
    filter (where t.id is not null), '[]') as tasks
from workers as w
left join task_to_worker as tw on tw.worker_id = w.id
left join tasks as t on tw.task_id = t.id
group by w.id;
