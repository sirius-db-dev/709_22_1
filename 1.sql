--zorina

drop table if exists video, comment;
create table video
(
	id  int primary key
   		 generated  by default as identity,
	title text,
	opisanie text,
	date_public date
);

create table comment
(
	id  int primary key
   		 generated  by default as identity,
   	video_id int references video(id),
	text_comment text,
	likes int
);

insert into video(title, opisanie, date_public)
values ('экстрасенсы реванш', 'топи топа', '2024-02-13'),
		('выжить в саморканде', 'тоже топи топа', '2023-06-08');
		
insert into comment(video_id, text_comment, likes)
values (1, 'шепс конечно раздражает чуть-чуть', 150),
		(2, 'у ляйсан красивые наряды', 50);

select
	v.id,
	v.title,
	v.opisanie,
	v.date_public,
	coalesce (json_agg(jsonb_build_object(
	'id', c.id, 'text_comment', c.text_comment, 'likes', c.likes))
	filter (where c.id is not null), '[]')
from video v
left join comment c
	on v.id = c.video_id
group by v.id;