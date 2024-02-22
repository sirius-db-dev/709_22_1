drop table repositories;
drop table tickets;

create table if not exists tickets (
ticket_id int primary key generated always as identity,
title text,
status text
);

create table if not exists repositories(
id int primary key generated always as identity,
title text,
bio text,
stars int,
ticket_id int references tickets
);

insert into tickets (title, status) values
('Task 1', 'in progress'),
('Task 2', 'done'),
('Task 3', 'not started'),
('Task 4', 'in progress'),
('Task 5', 'done'),
('Task 6', 'done');

insert into repositories (title, bio, stars, ticket_id) values
('ml', 'some about ml', 2, 1),
('ai', 'some about ai', 34, 2),
('ml', 'some about ml', 2, 3),
('ai', 'some about ai', 34, 6);

select *
from tickets 
		left join repositories on tickets.ticket_id = repositories.ticket_id;

select
  tick.ticket_id,
  tick.title,
  tick.status,
  coalesce(json_agg(json_build_object(
    'id', rep.id, 'ticket_id', rep.ticket_id, 'title', rep.title, 'bio', rep.bio, 'stars', rep.stars))
      filter (where rep.ticket_id is not null), '[]')
        as rep
from tickets tick
left join repositories rep on tick.ticket_id = rep.ticket_id
group by tick.ticket_id;