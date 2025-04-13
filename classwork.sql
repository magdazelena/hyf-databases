-- //Select the names and phones of all users;
SELECT name, phone FROM user;

-- Select the name of the user with id=10
select name from user where id=10;

select name from user where id in (1,2,3);
-- Find how many users exist in the database;
select count(*) as total_users from user ;

-- Select the names of the first 5 users in the database;
select name from user limit 5;
select id, name from user order by id asc limit 5;

-- Select the names of the last 3 users in the database;
select id, name from user order by id desc limit 3;

-- Sum all the ids in the user table;
select sum(id) from user;
-- Select all users and order them alphabetically by name;
select name from user order by name;
select name from user order by name desc;

--Find all tasks that include SQL either on the title or on the description
select * from task where title like '%sql%' or description like '%sql%';

select * from task where user_id =6

select title from task where user_id in (select id from user where name like '%Maryrose%');

select task.title, user.name from task join user on task.user_id = user.id where user.name like '%Maryrose%';

select count(*) from task join user on task.user_id = user.id

select count(*) from task where user_id is null;

select title, user.name from task left join user on task.user_id = user.id

select title, user.name from task right join user on task.user_id = user.id

select title, user.name from task right join user on task.user_id = user.id where task.user_id is null;
-- Find how many tasks each user is responsible for
select name, count(task.id) as total_tasks from user left join task on user.id = task.user_id group by user.name;

select user_id, count(*) as total_tasks from task group by user_id;

-- Find how many tasks with a status=Done each user is responsible for;
select user.name, count(task.id) as total_tasks, status.name as status_name 
from user left 
join task on user.id = task.user_id 
join status on task.status_id = status.id
where status.name = 'Done' group by user.name;

