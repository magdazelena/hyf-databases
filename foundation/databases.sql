--- SELECT
--- List the names and phones of all of the users.

SELECT name, phone FROM user;

-- List all of the users, ordering them by name alphabetically.
SELECT * FROM user ORDER BY name;

---- Find the name of the user of id 10.
SELECT name from user WHERE id = 10;

--- Find 3 oldest (by create date) tasks.
SELECT * from task ORDER BY created asc limit 3;


select * from task;
select count(*) from task;

INSERT INTO task (title, description, created, updated, due_date, status_id, user_id)
VALUES ('Prepare presentation', 'Create slides for the team meeting', DATETIME('now'), DATETIME('now'), null, 2, 1);

SELECT * FROM task ORDER BY id DESC LIMIT 1;

UPDATE task SET status_id = 1 WHERE title = 'Prepare presentation';

SELECT * FROM task WHERE title = 'Prepare presentation';


-------
-- Combine all the queries you learned!

-- Add yourself as a new user in the user table

INSERT into user (name, email, phone) VALUES ('Magda', 'magda@hyf.com', '001010');


INSERT into user (name, email, phone) VALUES ( 'Magda','',  null);

-- Create 2 or more tasks assigned to yourself

INSERT into task (title, description, created, updated, status_id, user_id) VALUES ('Learn SQL', 'please learn fast', datetime('now'), datetime('now'), 1, 13);

INSERT into task (title, description, created, updated, status_id, user_id) VALUES ('Drink more water', 'please', datetime('now'), datetime('now'), 1, 13);

-- Update the task you just created to change its status to "In Progress" (status_id = 2)
update task set status_id = 2 where id = 38;

select * from task ORDER BY created desc limit 1;
-- Retrieve only the title and description of all tasks assigned to you
select title, description from task where user_id = 13;
-- Delete a task that you no longer need

delete from task where id = 38;
