CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

--------------------------------------1------------------------------------
CREATE TABLE IF NOT EXISTS articles (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  name text,
  published_on date,
  text text
);

CREATE TABLE IF NOT EXISTS users (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  nickname text,
  registered_on date
);

CREATE TABLE views (
   article_id uuid REFERENCES articles,
   user_id uuid REFERENCES users,
   PRIMARY KEY(article_id, user_id)
);



INSERT INTO articles (ID, name, published_on, text) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'article1', '2021-01-03', 'bla bla'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'article2', '2021-02-03', 'bla bla');
  
INSERT INTO users (ID, nickname, registered_on) 
VALUES 
  ('9df244cc-4eb7-4391-bd9b-38b738f44381', 'oleg229', '2020-05-10'),
  ('cfda6742-279a-4ed4-98ed-de0ce13c552d', 'gorilla666', '2017-05-10');

INSERT INTO views (article_id, user_id) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'cfda6742-279a-4ed4-98ed-de0ce13c552d'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'cfda6742-279a-4ed4-98ed-de0ce13c552d');


SELECT 
	u.id, 
    u.nickname, 
    u.registered_on,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', a.id, 
                  'name', a.name, 
                  'published_on', a.published_on,
                  'text', A.text
                )
              ) 
      filter(where A.id is not null), '[]'
    ) AS views
FROM views v
LEFT JOIN users u ON u.id = v.user_id
LEFT JOIN articles a ON a.id = v.article_id
GROUP by u.id;

SELECT 
	a.id, 
    a.name, 
    a.published_on,
    A.text,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', u.id, 
                  'nickname', u.nickname, 
                  'registered_on', u.registered_on
                )
              ) 
      filter(where A.id is not null), '[]'
    ) AS views
FROM views v
LEFT JOIN users u ON u.id = v.user_id
LEFT JOIN articles a ON a.id = v.article_id
GROUP by a.id;

DROP TABLE articles CASCADE;
DROP TABLE users CASCADE;
DROP TABLE views CASCADE;

-------------------------------2--------------------------------
CREATE TABLE IF NOT EXISTS events (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  name text,
  date date,
  place text
);

CREATE TABLE IF NOT EXISTS participants (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  name text,
  surname text,
  birth_date date
);

CREATE TABLE applications (
   event_id uuid REFERENCES events,
   participant_id uuid REFERENCES participants,
   PRIMARY KEY(event_id, participant_id)
);



INSERT INTO events (ID, name, date, place) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'event1', '2021-01-03', 'UK, London'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'event2', '2021-02-03', 'Russia, Sochi');
  
INSERT INTO participants (ID, name, surname, birth_date) 
VALUES 
  ('9df244cc-4eb7-4391-bd9b-38b738f44381', 'Vladimir', 'Monomah', '1120-05-10'),
  ('cfda6742-279a-4ed4-98ed-de0ce13c552d', 'Oleg', 'Petrov', '2007-05-10');

INSERT INTO applications (event_id, participant_id) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'cfda6742-279a-4ed4-98ed-de0ce13c552d'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'cfda6742-279a-4ed4-98ed-de0ce13c552d');


SELECT 
	p.id, 
    p.name,
    p.surname,
    p.birth_date,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', e.id, 
                  'name', e.name, 
                  'date', e.date,
                  'place', e.place
                )
              ) 
      filter(where e.id is not null), '[]'
    ) AS applications
FROM applications a
LEFT JOIN participants p ON p.id = a.participant_id
LEFT JOIN events e ON e.id = a.event_id
GROUP by p.id
ORDER BY p.id asc;

SELECT 
	e.id, 
    e.name,
    e.date,
    e.place,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', p.id, 
                  'name', p.name, 
                  'surname', p.surname,
                  'birth_date', p.birth_date
                )
              ) 
      filter(where p.id is not null), '[]'
    ) AS applications
FROM applications a
LEFT JOIN participants p ON p.id = a.participant_id
LEFT JOIN events e ON e.id = a.event_id
GROUP by e.id
ORDER BY e.id asc;

DROP TABLE events CASCADE;
DROP TABLE participants CASCADE;
DROP TABLE applications CASCADE;

----------------------------3----------------------------
CREATE TABLE IF NOT EXISTS teachers (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  name text,
  surname text,
  birth_date date,
  academic_degree text,
  work_years int 
);

CREATE TABLE IF NOT EXISTS institutions (
  id uuid PRIMARY KEY default uuid_generate_v4(),
  name text,
  address text
);

CREATE TABLE teachers_institutions (
   teacher_id uuid REFERENCES teachers,
   institution_id uuid REFERENCES institutions,
   PRIMARY KEY(teacher_id, institution_id)
);



INSERT INTO teachers (ID, name, surname, birth_date, academic_degree, work_years) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'Alexey', 'Smirnov', '2000-01-03', 'Bakalavr', 4),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'Vladimir', 'Ivanov', '1990-08-08', 'Magistr', 10);
  
INSERT INTO institutions (ID, name, address) 
VALUES 
  ('9df244cc-4eb7-4391-bd9b-38b738f44381', 'Garvard', 'fafaflfsa'),
  ('cfda6742-279a-4ed4-98ed-de0ce13c552d', 'Oxford', 'fasfha');

INSERT INTO teachers_institutions (teacher_id, institution_id) 
VALUES 
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('ed3b975c-f288-4a79-86f0-3e954eea656f', 'cfda6742-279a-4ed4-98ed-de0ce13c552d'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', '9df244cc-4eb7-4391-bd9b-38b738f44381'),
  ('30f2a012-99c3-4c07-8bec-d6d01f2562e8', 'cfda6742-279a-4ed4-98ed-de0ce13c552d');


SELECT 
	t.id, 
    t.name,
    t.surname,
    t.birth_date,
    t.academic_degree,
    t.work_years,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', i.id, 
                  'name', i.name, 
                  'address', i.address
                )
              ) 
      filter(where i.id is not null), '[]'
    ) AS institutions
FROM teachers_institutions ti
LEFT JOIN institutions i ON i.id = ti.institution_id
LEFT JOIN teachers t ON t.id = ti.teacher_id
GROUP by t.id;

SELECT 
	i.id, 
    i.name,
    i.address,
    coalesce (
      jsonb_agg
              (
                jsonb_build_object(
                  'id', t.id, 
                  'name', t.name, 
                  'surname', t.surname,
                  'birth_date', t.birth_date,
                  'academic_degree', t.academic_degree,
                  'work_years', t.work_years
                )
              ) 
      filter(where t.id is not null), '[]'
    ) AS teachers
FROM teachers_institutions ti
LEFT JOIN institutions i ON i.id = ti.institution_id
LEFT JOIN teachers t ON t.id = ti.teacher_id
GROUP by i.id;

DROP TABLE teachers CASCADE;
DROP TABLE institutions CASCADE;
DROP TABLE teachers_institutions CASCADE;
