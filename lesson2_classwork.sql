select * from task;

-- 1
-- Add a task with these attributes: title, description, created, updated, due_date, status_id, user_id
insert into task (title, description, created, updated, due_date, status_id, user_id) 
values ("Vaccuum", "Now", now(), now(), null, 1, 1)

-- Change the title of a task
update task set title = 'Whatever your title' where id = 37;

-- remember that subqueries run from the most nested first and "out"

-- this one will be last ---------- where x = ( this one will run second --- from ( this one will run first) --- )
update task t1 set t1.title = 'my last task' where t1.id = (select t2.id from (select * from task) t2 order by t2.id desc limit 1);
select id from task order by id desc limit 1 

-- Change a task due date
update task set due_date = '2025-04-28' where id = 36

-- Change a task status
update task set status_id = 2 where id = 36;

select id from status where name = 'Done';

-- Mark a task as complete 
update task set status_id = (select id from status where name = 'Done') where id = 36;

-- Delete a task

delete from task where id = 1225;

-- because the id is autogen, the last autogen value is stored in memory and next index is going to incremented from that value
-- you can override this value manually:
insert into task (id, title, description, created, updated, due_date, status_id, user_id) 
values (1225, "Vaccuum", "Now", now(), now(), null, 1, 1)

-- because the id is NOT NULL, but it also autogen, the value is going to be created and no error for ID
-- this will throw error on CREATED, because for NOT NULL constraint and no default value defined:
insert into task (title, description, created, updated, due_date, status_id, user_id) 
values ("Vaccuum", "Now", null, now(), null, 1, 1)

