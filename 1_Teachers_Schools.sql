drop table if exists teachers, schools, teacher_to_school cascade;
create extension if not exists "uuid-ossp";

create table teachers (
	id uuid primary key default uuid_generate_v4(),
	name_ text,
	surname text,
	birth_date date,
	degree_ text,
	exp_ int
);

create table schools (
	id uuid primary key default uuid_generate_v4(),
	title text,
	address text
);


create table teacher_to_school (
	school_id uuid references schools,
	teacher_id uuid references teachers,
	primary key (school_id, teacher_id)
);

insert into teachers(name_, surname, birth_date, degree_, exp_)
values
('John', 'Doe', '1986-05-18', 'Teacher', 10),
('Jane', 'Doe', '1987-10-30', 'Assistant', 1),
('Ray', 'Harley', '1980-05-09', 'Doctor Nauk', 13);

insert into schools(title, address)
values
('Lyceum №11', 'Lenina st. 151'),
('School №416', 'October st. 13');

insert into teacher_to_school(school_id, teacher_id)
values ((select id from schools where title = 'Lyceum №11'),
		(select id from teachers where name_ = 'John')),
	   ((select id from schools where title = 'Lyceum №11'),
	    (select id from teachers where name_ = 'Jane')),
	   ((select id from schools where title = 'Lyceum №11'),
	    (select id from teachers where name_ = 'Ray')),
	   ((select id from schools where title = 'School №416'),
	    (select id from teachers where name_ = 'Ray'));
	  
select *
from schools s
         left join teacher_to_school ts on s.id = ts.school_id
         left join teachers t on ts.teacher_id = t.id;

select
  t.id,
  t.name_,
  t.surname,
  t.birth_date,
  t.degree_,
  t.exp_,
  coalesce(jsonb_agg(jsonb_build_object(
    'ID', s.id, 'Title', s.title, 'Address', s.address))
      filter (where s.id is not null), '[]') as teachers
from teachers t
left join teacher_to_school st on t.id = st.teacher_id
left join schools s on s.id = st.school_id
group by t.id;

select
  s.id,
  s.title,
  s.address,
  coalesce(json_agg(json_build_object(
    'ID', t.id, 'First Name', t.name_,
    'Last Name', t.surname, 'Birth Date', t.birth_date,
    'Degree', t.degree_, 'Experience', t.exp_))
      filter (where t.id is not null), '[]') as schools
from schools s
left join teacher_to_school st on s.id = st.school_id
left join teachers t on t.id = st.teacher_id
group by s.id;


