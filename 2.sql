create extension if not exists "uuid-ossp";
drop table if exists tasks, students cascade;

create table if not exists tasks(
	id uuid primary key default uuid_generate_v4(),
	name_task text,
	about text,
	complexity int
);

create table if not exists student(
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	date_registrated date,
	rete int
);

create table task_to_student
(
    task_id uuid references tasks,
    student_id  uuid references student,
    primary key (task_id, student_id)
);

insert into tasks(name_task, about, complexity)
values ('task1', 'about1', 1),
		('task2', 'task2', 2),
		('task3', 'task3', 3);
		
insert into student(nickname, date_registrated, rete)
values ('nick1', '2022-02-23', 1),
		('nick2', '2022-02-23', 2),
		('nick3', '2022-02-23', 3);
		
insert into task_to_student(task_id, student_id)
values ((select id from tasks where complexity = 1), 
		(select id from student where nickname = 'nick2')),
		((select id from tasks where complexity = 1), 
		(select id from student where nickname = 'nick3')),
		((select id from tasks where complexity = 2), 
		(select id from student where nickname = 'nick1'));
	

insert into task_to_student(task_id, student_id)
values ((select id from tasks where complexity = 2), 
		(select id from student where nickname = 'nick2'));
		

select 
	t.id,
	t.name_task,
	t.about,
	t.complexity,
	coalesce (json_agg(json_build_object(
	'id', st.id, 'nickname', st.nickname, 'date_registrated', st.date_registrated, 'rate', st.rete
	)) filter (where st.id is not null), '[]') as students
	from tasks t
	left join task_to_student tts on tts.task_id = t.id
	left join student st on tts.student_id = st.id
	group by t.id
