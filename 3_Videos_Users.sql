drop table if exists users, videos, user_to_video cascade;
create extension if not exists "uuid-ossp";

create table users (
	id uuid primary key default uuid_generate_v4(),
	nickname text,
	reg_date date
);

create table videos (
	id uuid primary key default uuid_generate_v4(),
	title text,
	published date,
	duration int
);


create table user_to_video (
	video_id uuid references videos,
	user_id uuid references users,
	primary key (video_id, user_id)
);

insert into users(nickname, reg_date)
values
('user1', '2006-10-03'),
('user2', '2010-08-13'),
('user3', '2021-12-01');

insert into videos(title, published, duration)
values
('Gameplay 1', '2006-10-04', 512),
('Gameplay 2', '2006-10-06', 600);

insert into user_to_video(video_id, user_id)
values ((select id from videos where title = 'Gameplay 1'),
		(select id from users where nickname = 'user1')),
	   ((select id from videos where title = 'Gameplay 1'),
	    (select id from users where nickname = 'user2')),
	   ((select id from videos where title = 'Gameplay 1'),
	    (select id from users where nickname = 'user3')),
	   ((select id from videos where title = 'Gameplay 2'),
	    (select id from users where nickname = 'user1'));
	  
select *
from videos r
         left join user_to_video dr on r.id = dr.video_id
         left join users d on dr.user_id = d.id;

select
  d.id,
  d.nickname,
  d.reg_date,
  coalesce(jsonb_agg(jsonb_build_object(
    'ID', r.id, 'Title', r.title, 'Desc', r.published, 'duration', r.duration))
      filter (where r.id is not null), '[]') as users
from users d
left join user_to_video rd on d.id = rd.user_id
left join videos r on r.id = rd.video_id
group by d.id;

select
  r.id,
  r.title,
  r.published,
  r.duration,
  coalesce(json_agg(json_build_object(
    'ID', d.id, 'Nickname', d.nickname, 'Registered', d.reg_date))
      filter (where d.id is not null), '[]') as videos
from videos r
left join user_to_video rd on r.id = rd.video_id
left join users d on d.id = rd.user_id
group by r.id;


