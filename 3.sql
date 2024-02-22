drop table if exists chat, messege cascade;

create table if not exists chat(
	id serial primary key,
	name_chat text,
	created_date text
);

insert into chat(name_chat, created_date)
values ('chat1','2024-02-22'),
		('chat2','2024-02-22'),
		('chat2','2024-02-22')
;

create table if not exists messege(
	id serial primary key,
	id_chat int references chat(id),
	messege_text text,
	send_date date
);


insert into messege(id_chat, messege_text, send_date)
values (2, 'enjoy)', '2024-02-22'),
		(2, 'enjoy(', '2024-02-22'),
		(1, 'hehe', '2024-02-22'),
		(1, 'not hehe', '2024-02-22')

;

select 
	chat.id, 
	chat.name_chat,
	chat.created_date,
	coalesce (json_agg(json_build_object(
	'id', mes.id, 'messege_text', mes.messege_text, 'send_date', mes.send_date
	)) filter (where mes.id is not null), '[]') from chat
	left join messege mes on mes.id_chat = chat.id
	group by chat.id;
	
	
	
	