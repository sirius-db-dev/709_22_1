DROP TABLE repositories CASCADE;
DROP TABLE tickets;
DROP TABLE courses CASCADE;
DROP TABLE reviews;
DROP TABLE suppliers CASCADE;
DROP TABLE vehicles;

CREATE TABLE IF NOT EXISTS repositories (
  id serial PRIMARY KEY,
  name text,
  description text,
  number_of_stars int DEFAULT 0
);

CREATE TABLE IF NOT EXISTS tickets (
  id serial PRIMARY KEY,
  name text,
  description text,
  status  text,
  repository_id int NOT NULL,
  FOREIGN KEY(repository_id) REFERENCES repositories(id)
);

INSERT INTO repositories (id, name, description, number_of_stars) VALUES (1, 'repo1', 'bla bla bla', 23);
INSERT INTO tickets (name, description, status, repository_id) VALUES 
	('ticket1', 'bla bla bla', 'active', 1),
    ('ticket2', 'bla bla bla', 'passive', 1);

SELECT 
	r.id, 
    r.name, 
    r.description,
    coalesce (jsonb_agg(jsonb_build_object('id', ti.id, 'name', ti.name, 'status', ti.status)) filter(where ti.id is not null), '[]') AS tickets
FROM repositories r
LEFT JOIN tickets ti ON r.id = ti.repository_id
GROUP by r.id;


CREATE TABLE IF NOT EXISTS courses (
  id serial PRIMARY KEY,
  name text,
  description text 
);

CREATE TABLE IF NOT EXISTS reviews (
  id serial PRIMARY KEY,
  text TEXT,
  course_id int NOT NULL,
  FOREIGN KEY(course_id) REFERENCES courses(id)
);

INSERT INTO courses (id, name, description) VALUES (1, 'course1', 'bla bla bla');
INSERT INTO reviews (text, course_id) VALUES 
	('very good', 1),
    ('very bad', 1);

SELECT 
	co.id, 
    co.name, 
    co.description,
    coalesce (jsonb_agg(jsonb_build_object('id', r.id, 'text', r.text)) filter(where r.id is not null), '[]') AS reviews
FROM courses co
LEFT JOIN reviews r ON co.id = r.course_id
GROUP by co.id;



CREATE TABLE IF NOT EXISTS suppliers (
  id serial PRIMARY KEY,
  name text,
  phone text
);

CREATE TABLE IF NOT EXISTS vehicles (
  id serial PRIMARY KEY,
  mark text,
  model text,
  weight_limit int,
  supplier_id int NOT NULL,
  FOREIGN KEY(supplier_id) REFERENCES suppliers(id)
);


INSERT INTO suppliers (id, name, phone) VALUES (1, 'Sanya', '+79183450845');
INSERT INTO vehicles (mark, model, weight_limit, supplier_id) VALUES 
	('BMW', 'X6', 12333, 1),
    ('HAVAL', 'idk', 20000, 1);

SELECT 
	s.id, 
    s.name, 
    s.phone,
    coalesce (
      jsonb_agg(
        jsonb_build_object(
          'id', v.id, 
          'mark', v.mark, 
		  'model', v.model,
          'weight_limit', v.weight_limit
        )
      ) 
      filter(where v.id is not null), '[]'
    ) AS vehicles
FROM suppliers s
LEFT JOIN vehicles v ON s.id = v.supplier_id
GROUP by s.id;

