drop table if exists devs, repos, dev_to_repo cascade;
create extension if not exists "uuid-ossp";

create table devs (
	id uuid primary key default uuid_generate_v4(),
	nickname text
);

create table repos (
	id uuid primary key default uuid_generate_v4(),
	title text,
	description text,
	stars int
);


create table dev_to_repo (
	repo_id uuid references repos,
	dev_id uuid references devs,
	primary key (repo_id, dev_id)
);

insert into devs(nickname)
values
('sirius-db-dev'),
('k0marov'),
('siriusdevs');

insert into repos(title, description, stars)
values
('709-22-1', 'Tests for 1st programmers group', 2),
('homeworks_23', 'Homeworks for students :3', 13);

insert into dev_to_repo(repo_id, dev_id)
values ((select id from repos where title = '709-22-1'),
		(select id from devs where nickname = 'sirius-db-dev')),
	   ((select id from repos where title = 'homeworks_23'),
	    (select id from devs where nickname = 'k0marov')),
	   ((select id from repos where title = '709-22-1'),
	    (select id from devs where nickname = 'siriusdevs')),
	   ((select id from repos where title = 'homeworks_23'),
	    (select id from devs where nickname = 'siriusdevs'));
	  
select *
from repos r
         left join dev_to_repo dr on r.id = dr.repo_id
         left join devs d on dr.dev_id = d.id;

select
  d.id,
  d.nickname,
  coalesce(jsonb_agg(jsonb_build_object(
    'ID', r.id, 'Title', r.title, 'Desc', r.description, 'Stars', r.stars))
      filter (where r.id is not null), '[]') as devs
from devs d
left join dev_to_repo rd on d.id = rd.dev_id
left join repos r on r.id = rd.repo_id
group by d.id;

select
  r.id,
  r.title,
  r.description,
  r.stars,
  coalesce(json_agg(json_build_object(
    'ID', d.id, 'Nickname', d.nickname))
      filter (where d.id is not null), '[]') as repos
from repos r
left join dev_to_repo rd on r.id = rd.repo_id
left join devs d on d.id = rd.dev_id
group by r.id;


