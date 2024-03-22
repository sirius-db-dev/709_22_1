### 1. Видео и комментарии:
- видео может иметь несколько комментариев
- комментарий может принадлежать только одному видео
- видео - название, описание, дата публикации
- комментарий - текст, количество лайков

create extension if not exists "uuid-ossp";

drop table if exists videos, comments;

 create table if not exists videos
 (
     id uuid primary key default uuid_generate_v4(),
     title text,
     description text,
     data_pub date
 );

 create table if not exists comments
 (
     id uuid primary key default uuid_generate_v4(),
     video_id uuid references videos,
     comtext text,
     likes int
 );
 
insert into videos(title, description, data_pub) 
values ('Me at the Zoo', 'First video on YouTube', '1970-01-01'),
('How to cook?', 'Answer in the easy question', '2000-01-01'),
('I am master', 'Excellent prom 2024', '2024-07-01'),
('I am expelled in Sirius College', 'Yeah. I am specialist', '2026-07-05');

insert into comments(video_id, comtext, likes)
values((select id from videos where title = 'Me at the Zoo'), 'Good job!', 10),
((select id from videos where title = 'I am master'), 'Great! You go to Moscow tomorrow?', 0),
((select id from videos where title = 'How to cook?'), 'Poor video', -1)

 select
     v.id,
     v.title,
     v.description,
     v.data_pub,
     coalesce(json_agg(json_build_object(
             'id', com.id, 'text', com.comtext, 'likes', com.likes))
             filter (where com.id is not null), '[]'
     ) as comments
 from videos v
 left join comments com on v.id = com.video_id
 group by v.id;