-- dropping tables 
drop table employee;
drop table branch;
drop table client;
drop table works_with;
drop table branch_supplier;

-- creating tables 
create table employee(
    emp_id int primary key not null,
    first_name varchar(20),
    last_name varchar(20),
    birth_date date,
    sex varchar(1),
    salary int,
    super_id int, 
    branch_id int
);

create table branch(
    branch_id int primary key,
    branch_name varchar(20),
    mgr_id int,
    mgr_start_date date
);

alter table branch 
add foreign key(mgr_id)
references employee(emp_id)
on delete set null;

alter table employee
add foreign key (branch_id)
references branch(branch_id)
on delete set null;

alter table employee
add foreign key (super_id)
references employee(emp_id)
on delete set null;

create table client(
    client_id int primary key,
    client_name varchar(30),
    branch_id int,
    foreign key(branch_id) references branch(branch_id) on delete set null
);

create table works_with(
    emp_id int,
    client_id int,
    primary key(emp_id, client_id),
    total_sales int,
    foreign key(emp_id) references employee(emp_id) on delete cascade,
    foreign key(client_id) references client(client_id) on delete cascade
);

create table branch_supplier(
    branch_id int,
    supplier_name varchar(20),
    primary key(branch_id, supplier_name),
    supply_type varchar(20),
    foreign key(branch_id) references branch(branch_id) on delete cascade
);

-- -------------------------------------------------------------------------------

-- inserting values

-- Corporate
INSERT INTO employee VALUES(100, 'David', 'Wallace', '1967-11-17', 'M', 250000, NULL, NULL);

INSERT INTO branch VALUES(1, 'Corporate', 100, '2006-02-09');
insert into branch values(5, 'Other', 104, '2001-03-10');

UPDATE employee
SET branch_id = 1
WHERE emp_id = 100;

INSERT INTO employee VALUES(101, 'Jan', 'Levinson', '1961-05-11', 'F', 110000, 100, 1);

-- Scranton
INSERT INTO employee VALUES(102, 'Michael', 'Scott', '1964-03-15', 'M', 75000, 100, NULL);

INSERT INTO branch VALUES(2, 'Scranton', 102, '1992-04-06');

UPDATE employee
SET branch_id = 2
WHERE emp_id = 102;

INSERT INTO employee VALUES(103, 'Angela', 'Martin', '1971-06-25', 'F', 63000, 102, 2);
INSERT INTO employee VALUES(104, 'Kelly', 'Kapoor', '1980-02-05', 'F', 55000, 102, 2);
INSERT INTO employee VALUES(105, 'Stanley', 'Hudson', '1958-02-19', 'M', 69000, 102, 2);

-- Stamford
INSERT INTO employee VALUES(106, 'Josh', 'Porter', '1969-09-05', 'M', 78000, 100, NULL);

INSERT INTO branch VALUES(3, 'Stamford', 106, '1998-02-13');

UPDATE employee
SET branch_id = 3
WHERE emp_id = 106;

INSERT INTO employee VALUES(107, 'Andy', 'Bernard', '1973-07-22', 'M', 65000, 106, 3);
INSERT INTO employee VALUES(108, 'Jim', 'Halpert', '1978-10-01', 'M', 71000, 106, 3);


-- BRANCH SUPPLIER
INSERT INTO branch_supplier VALUES(2, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Patriot Paper', 'Paper');
INSERT INTO branch_supplier VALUES(2, 'J.T. Forms & Labels', 'Custom Forms');
INSERT INTO branch_supplier VALUES(3, 'Uni-ball', 'Writing Utensils');
INSERT INTO branch_supplier VALUES(3, 'Hammer Mill', 'Paper');
INSERT INTO branch_supplier VALUES(3, 'Stamford Labels', 'Custom Forms');

delete from branch_supplier 
where supplier_name = 'Stamford Lables';

-- CLIENT
INSERT INTO client VALUES(400, 'Dunmore Highschool', 2);
INSERT INTO client VALUES(401, 'Lackawana Country', 2);
INSERT INTO client VALUES(402, 'FedEx', 3);
INSERT INTO client VALUES(403, 'John Daly Law, LLC', 3);
INSERT INTO client VALUES(404, 'Scranton Whitepages', 2);
INSERT INTO client VALUES(405, 'Times Newspaper', 3);
INSERT INTO client VALUES(406, 'FedEx', 2);

-- WORKS_WITH
INSERT INTO works_with VALUES(105, 400, 55000);
INSERT INTO works_with VALUES(102, 401, 267000);
INSERT INTO works_with VALUES(108, 402, 22500);
INSERT INTO works_with VALUES(107, 403, 5000);
INSERT INTO works_with VALUES(108, 403, 12000);
INSERT INTO works_with VALUES(105, 404, 33000);
INSERT INTO works_with VALUES(107, 405, 26000);
INSERT INTO works_with VALUES(102, 406, 15000);
INSERT INTO works_with VALUES(105, 406, 130000);

--selecting tables 
select * from employee;
select * from branch;
select * from client;
select * from works_with;
select * from branch_supplier;

-- --------------------------------------------------------------------------------

-- queries 

-- basics 
-- find all employee names and their salary order by salary

select first_name, last_name, salary from employee 
order by salary;

-- find all employees ordered by sex and then name 

select * from employee
order by sex, first_name, last_name;

-- select first 5 clients in the table

select * from client limit 5;

-- select forename and surname of all employees 

select first_name as forename, last_name as surname 
from employee;

-- find out all the different genders and branch_id

select distinct sex 
from employee;
select distinct branch_id from branch;

-- functions 
-- find the number of employees 
-- find the number of different super_id 

select count(distinct super_id) from employee;

-- find the number of female employees born after 1970

select count(emp_id) from employee
where sex = 'F' and birth_date >= '1971-01-01';

-- what is the average salary for all employees?

select avg(salary) as AvgALL from employee;

-- what is the average salary of Male employees?

select avg(salary) as MaleAvg from employee
where sex = 'M';

-- what is the average salary of Female employees?

select avg(salary) as FemaleAvg from employee
where sex = 'F';

-- find aout how many male and female are there 

select count(sex), sex from employee
group by sex;

-- find the sales for each salesman

select sum(total_sales), emp_id
from works_with
group by emp_id;

-- find the total sales by each client

select sum(total_sales) as sales, client_id
from works_with
group by client_id;

-- find any clients who are LLC

-- wildcards

select * from client
where client_name like '%LLC';

-- find any supplier who are in the label business

select * from branch_supplier
where supplier_name like '%Label%';

-- find any employee born in February

select * from employee
where birth_date like '____-02-__';

-- find any clients who are schools

select * from client
where client_name like '%school%';

-- unions 
--  find the list of all clients and branch suppliers names

select client_name as Client_and_Branch_Names, branch_id as ID
from client
UNION
select supplier_name, branch_id
from branch_supplier;

-- find a list of all money that was spent and earned by the company

select salary from employee
UNION
select total_sales from works_with;

-- total

select sum(salary) 
from employee
union
select sum(total_sales)
from works_with;

-- joins 

insert into branch
values(
    4, 'Buffalo', null, null
);
select * from branch;

-- find all branches and the name of managers 

select emp.emp_id, emp.first_name, emp.last_name,
br.branch_name from employee as emp
join branch as br on
emp.emp_id = br.mgr_id;

-- find all branches and the name of managers(left and right joins)
-- left join basically add all the rows from left table 
-- left table is the table which we mention right after the from clause in a join statement

select emp.emp_id, emp.first_name, emp.last_name,
br.branch_name from employee as emp
left join branch as br on
emp.emp_id = br.mgr_id;

-- right join basically add all the rows from the right table
-- right table is the table which we mention right after the join clause in a join statement

select emp.emp_id, emp.first_name, emp.last_name, 
br.branch_name from employee as emp
right join branch as br on
emp.emp_id = br.mgr_id; 

-- nested queries 
-- find names of all employee who have 
-- sold over 30000 to a single client

select emp.first_name, emp.last_name from employee as emp
where emp.emp_id in(
    select ww.emp_id from works_with as ww
    where ww.total_sales > 30000
);

-- find all clients who are handled by the branch that
-- Michael Scott manages 
-- assuming you know his id

select cl.client_name from 
client as cl where
cl.branch_id in (
    select emp.branch_id from employee as emp
    where emp.emp_id = 102
);

-- on delete 
-- (if we set on delete set null for a foreign key then for deleting a row in the main table 
-- the foreign key of the other table will set to NULL)
-- (if we set on delete cascade for a foreign key then for deleting a row in the main table
-- the other table will delete the whole row for that particular foreign key)

-- example of set null: (let's see what happens in the branch table if we delete emp_id values 104)
delete from employee 
where emp_id = 104;
select * from branch; -- (here we can see mgr_id was the foreign key with emp_id of employee
-- table and when we deleted the employee with the id of 104, in the branch table 
-- the row where the mgr_id was 104 is now set to NULL)

-- example of cascade: (let's see what happens in the branch_supplier table if we delete 
-- branch_id values 2 from the branch table)
delete from branch 
where branch_id = 2;
select * from branch_supplier; -- (here we can see branch_id in branch supplier was the foreign
-- key for the branch_id in branch table and when we deleted the branch_id with 2 in branch table
-- all the rows with branch id 2 were deleted from branch_supplier table)

-- trigger test
create table trigger_test(
    messsage varchar(100)
);

-- creatying triggers 
-- to create triggers use command prompt as it can not be created in a notebook 

-- simple trigger 
delimiter $$
create 
    trigger my_trigger2 before insert
    on employee
    for each row begin
        insert into trigger_test values(new.first_name);
    end$$ 
delimiter;

insert into employee values(
    109, 'Oscar', 'Martinez', '1968-02-19', 'M', 69000, 106, 3
);

select * from employee;
select * from trigger_test;

insert into employee values(
    110, 'Kevin', 'Martinesto', '1961-02-19', 'F', 79000, 106, 3
);

select * from employee;

show triggers;
drop trigger my_trigger1;

-- triggers that contains condition
delimiter $$
    create trigger my_trigger3 before insert 
    on employee 
    for each row begin 
        if NEW.sex = 'M' then
            insert into trigger_test values('added male employee');
        elseif new.sex = 'F' then
            insert into trigger_test values('added female employee');
        else 
            insert into trigger_test values('added other employee');
        end if;
    end$$
delimiter;

insert into employee values(
    111, 'Kevins', 'Martinesto', '1961-02-19', 'F', 79000, 106, 3
);


