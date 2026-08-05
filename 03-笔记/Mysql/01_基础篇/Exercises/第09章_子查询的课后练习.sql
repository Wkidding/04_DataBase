
# 第09章_子查询的课后练习



#1.查询和Zlotkey相同部门的员工姓名和工资

SELECT last_name,salary
FROM employees
WHERE department_id IN (
			SELECT department_id
			FROM employees
			WHERE last_name = 'Zlotkey'
			);

[root 3306][DB: atguigudb] mysql >select last_name,salary from employees where department_id = (select department_id from employees where last_name = 'Zlotkey');



#2.查询工资比公司平均工资高的员工的员工号，姓名和工资。

SELECT employee_id,last_name,salary
FROM employees
WHERE salary > (
		SELECT AVG(salary)
		FROM employees
		);
        
[root 3306][DB: atguigudb] mysql >select employee_id,last_name,salary from employees where salary > (select avg(salary) from employees);


#3.选择工资大于所有JOB_ID = 'SA_MAN'的员工的工资的员工的last_name, job_id, salary

SELECT last_name,job_id,salary
FROM employees
WHERE salary > ALL(
		SELECT salary
		FROM employees
		WHERE job_id = 'SA_MAN'
		);

[root 3306][DB: atguigudb] mysql >SELECT last_name,job_id,salary FROM employees WHERE salary > ALL( SELECT salary FROM employees WHERE job_id = 'SA_MAN' );


#4.查询和姓名中包含字母u的员工在相同部门的员工的员工号和姓名

[root 3306][DB: atguigudb] mysql >SELECT employee_id,last_name from employees where department_id in (select department_id from employees where last_name like '%u%');

## 注意：需要加上distinct,因为不确定部门id是否会重复

SELECT employee_id,last_name
FROM employees 
WHERE department_id IN (
			SELECT DISTINCT department_id
			FROM employees
			WHERE last_name LIKE '%u%'
			);

#5.查询在部门的location_id为1700的部门工作的员工的员工号

[root 3306][DB: atguigudb] mysql >select employee_id from employees where department_id in (select department_id from departments where location_id=1700);

SELECT employee_id
FROM employees
WHERE department_id IN (
			SELECT department_id
			FROM departments
			WHERE location_id = 1700
			);


#6.查询管理者是King的员工姓名和工资


[root 3306][DB: atguigudb] mysql >SELECT last_name,salary,manager_id from employees where manager_id in (select employee_id from employees where last_name='King');


SELECT last_name,salary,manager_id
FROM employees
WHERE manager_id IN (
			SELECT employee_id
			FROM employees
			WHERE last_name = 'King'
			);



#7.查询工资最低的员工信息: last_name, salary

[root 3306][DB: atguigudb] mysql >select last_name,salary from employees where salary=(select min(salary) from employees);

SELECT last_name,salary
FROM employees
WHERE salary = (
		SELECT MIN(salary)
		FROM employees
		);


#8.查询平均工资最低的部门信息
[root 3306][DB: atguigudb] mysql >select * from departments where department_id = (
    select department_id from employees
    group by department_id
    having avg(salary) = (
        select min(avg_sal)
        from (
            select avg(salary) avg_sal
            from employees
            group by department_id) t_tmp)
    );
+---------------+-----------------+------------+-------------+
| department_id | department_name | manager_id | location_id |
+---------------+-----------------+------------+-------------+
|            50 | Shipping        |        121 |        1500 |
+---------------+-----------------+------------+-------------+
1 row in set (0.01 sec)


#方式1：
SELECT *
FROM departments
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) = (
						SELECT MIN(avg_sal)
						FROM (
							SELECT AVG(salary) avg_sal
							FROM employees
							GROUP BY department_id
							) t_dept_avg_sal
						)
			);
#方式2：
# 使用ALL关键字
SELECT *
FROM departments
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) <= ALL(
						SELECT AVG(salary)
						FROM employees
						GROUP BY department_id
						)
			);

#方式3： 使用LIMIT方式进行筛选

SELECT *
FROM departments
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) =(
						SELECT AVG(salary) avg_sal
						FROM employees
						GROUP BY department_id
						ORDER BY avg_sal ASC
						LIMIT 1		
						)
			);

#方式4：
# 将各部门平均工资作为临时表，和employee表进行join
SELECT d.*
FROM departments d,(
		SELECT department_id,AVG(salary) avg_sal
		FROM employees
		GROUP BY department_id
		ORDER BY avg_sal ASC
		LIMIT 0,1
		) t_dept_avg_sal
WHERE d.`department_id` = t_dept_avg_sal.department_id;
		
#9.查询平均工资最低的部门信息和该部门的平均工资（相关子查询）

## 自己摸索
select d.*,(select avg(salary) from employees e group by department_id having d.department_id = e.department_id) avg_salary from departments d
where d.department_id = (
    select department_id from employees group by department_id having avg(salary) = (   select min(avg_sal) from (select avg(salary) avg_sal from employees group by department_id) t_avg_tmp )
);

#方式1：
SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.`department_id`) avg_sal
FROM departments d
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) = (
						SELECT MIN(avg_sal)
						FROM (
							SELECT AVG(salary) avg_sal
							FROM employees
							GROUP BY department_id
							) t_dept_avg_sal

						)
			);

#方式2：

SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.`department_id`) avg_sal
FROM departments d
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) <= ALL(
						SELECT AVG(salary)
						FROM employees
						GROUP BY department_id
						)
			);

#方式3： LIMIT

SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.`department_id`) avg_sal
FROM departments d
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING AVG(salary ) =(
						SELECT AVG(salary) avg_sal
						FROM employees
						GROUP BY department_id
						ORDER BY avg_sal ASC
						LIMIT 1		
						)
			);

#方式4：

SELECT d.*,(SELECT AVG(salary) FROM employees WHERE department_id = d.`department_id`) avg_sal
FROM departments d,(
		SELECT department_id,AVG(salary) avg_sal
		FROM employees
		GROUP BY department_id
		ORDER BY avg_sal ASC
		LIMIT 0,1
		) t_dept_avg_sal
WHERE d.`department_id` = t_dept_avg_sal.department_id

#10.查询平均工资最高的 job 信息
[root 3306][DB: atguigudb] mysql >
select * from jobs where job_id = (
    select job_id from employees
    group by job_id
    having avg(salary) = (
        select max(avg_sal)
        from (
            select avg(salary) avg_sal
            from employees
            group by job_id) t_tmp
            )
    );

+---------+-----------+------------+------------+
| job_id  | job_title | min_salary | max_salary |
+---------+-----------+------------+------------+
| AD_PRES | President |      20000 |      40000 |
+---------+-----------+------------+------------+
1 row in set (0.00 sec)




#方式1：
SELECT *
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) = (
					SELECT MAX(avg_sal)
					FROM (
						SELECT AVG(salary) avg_sal
						FROM employees
						GROUP BY job_id
						) t_job_avg_sal
					)
		);

#方式2：
SELECT *
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) >= ALL(
				     SELECT AVG(salary) 
				     FROM employees
				     GROUP BY job_id
				     )
		);

#方式3：
SELECT *
FROM jobs
WHERE job_id = (
		SELECT job_id
		FROM employees
		GROUP BY job_id
		HAVING AVG(salary) =(
				     SELECT AVG(salary) avg_sal
				     FROM employees
				     GROUP BY job_id
				     ORDER BY avg_sal DESC
				     LIMIT 0,1
				     )
		);

#方式4：
SELECT j.*
FROM jobs j,(
		SELECT job_id,AVG(salary) avg_sal
		FROM employees
		GROUP BY job_id
		ORDER BY avg_sal DESC
		LIMIT 0,1		
		) t_job_avg_sal
WHERE j.job_id = t_job_avg_sal.job_id
		
#11.查询平均工资高于公司平均工资的部门有哪些?

[root 3306][DB: atguigudb] mysql >select department_id from employees group by department_id having avg(salary) >(select avg(salary) from employees);
+---------------+
| department_id |
+---------------+
|          NULL |
|            20 |
|            40 |
|            70 |
|            80 |
|            90 |
|           100 |
|           110 |
+---------------+
8 rows in set (0.00 sec)

# 去掉department_id的null值
[root 3306][DB: atguigudb] mysql >select department_id from employees where department_id is not null group by department_id having avg(salary) >(select avg(salary) from employees);
+---------------+
| department_id |
+---------------+
|            20 |
|            40 |
|            70 |
|            80 |
|            90 |
|           100 |
|           110 |
+---------------+
7 rows in set (0.00 sec)


SELECT department_id
FROM employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > (
			SELECT AVG(salary)
			FROM employees
			);


#12.查询出公司中所有 manager 的详细信息

[root 3306][DB: atguigudb] mysql >select distinct e2.* from employees e1,employees e2 where e1.manager_id = e2.employee_id;


#方式1：自连接  xxx worked for yyy
SELECT DISTINCT mgr.employee_id,mgr.last_name,mgr.job_id,mgr.department_id
FROM employees emp JOIN employees mgr
ON emp.manager_id = mgr.employee_id;

#方式2：子查询

SELECT employee_id,last_name,job_id,department_id
FROM employees
WHERE employee_id IN (
			SELECT DISTINCT manager_id
			FROM employees
			);

#方式3：使用EXISTS
SELECT employee_id,last_name,job_id,department_id
FROM employees e1
WHERE EXISTS (
	       SELECT *
	       FROM employees e2
	       WHERE e1.`employee_id` = e2.`manager_id`
	     );

	
#13.各个部门中 最高工资中最低的那个部门的 最低工资是多少?

[root 3306][DB: atguigudb] mysql >select min(salary) from employees where department_id = (select department_id from employees group by department_id having max(salary) = (select min(max_sal) from(select max(salary) max_sal from employees group by department_id ) t_tmp));
+-------------+
| min(salary) |
+-------------+
|     4400.00 |
+-------------+
1 row in set (0.00 sec)



#方式1：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING MAX(salary) = (
						SELECT MIN(max_sal)
						FROM (
							SELECT MAX(salary) max_sal
							FROM employees
							GROUP BY department_id
							) t_dept_max_sal
						)
			);

SELECT *
FROM employees
WHERE department_id = 10;

#方式2：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING MAX(salary) <= ALL (
						SELECT MAX(salary)
						FROM employees
						GROUP BY department_id
						)
			);

#方式3：
SELECT MIN(salary)
FROM employees
WHERE department_id = (
			SELECT department_id
			FROM employees
			GROUP BY department_id
			HAVING MAX(salary) = (
						SELECT MAX(salary) max_sal
						FROM employees
						GROUP BY department_id
						ORDER BY max_sal ASC
						LIMIT 0,1
						)
			);
			
#方式4：
SELECT MIN(salary)
FROM employees e,(
		SELECT department_id,MAX(salary) max_sal
		FROM employees
		GROUP BY department_id
		ORDER BY max_sal ASC
		LIMIT 0,1
		) t_dept_max_sal
WHERE e.department_id = t_dept_max_sal.department_id


#14.查询平均工资最高的部门的 manager 的详细信息: last_name, department_id, email, salary

# 自己写
select last_name, department_id, email, salary 
from employees 
where employee_id in (
select distinct manager_id from employees e,( select department_id,avg(salary) avg_sal from employees group by department_id order by avg_sal desc limit 0,1) t_tmp
where e.department_id = t_tmp.department_id);
+-----------+---------------+-------+----------+
| last_name | department_id | email | salary   |
+-----------+---------------+-------+----------+
| King      |            90 | SKING | 24000.00 |
+-----------+---------------+-------+----------+
1 row in set (0.00 sec)


#方式1：
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id = ANY (
			SELECT DISTINCT manager_id
			FROM employees
			WHERE department_id = (
						SELECT department_id
						FROM employees
						GROUP BY department_id
						HAVING AVG(salary) = (
									SELECT MAX(avg_sal)
									FROM (
										SELECT AVG(salary) avg_sal
										FROM employees
										GROUP BY department_id
										) t_dept_avg_sal
									)
						)
			);

#方式2：
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id = ANY (
			SELECT DISTINCT manager_id
			FROM employees
			WHERE department_id = (
						SELECT department_id
						FROM employees
						GROUP BY department_id
						HAVING AVG(salary) >= ALL (
								SELECT AVG(salary) avg_sal
								FROM employees
								GROUP BY department_id
								)
						)
			);

#方式3：
SELECT last_name, department_id, email, salary
FROM employees
WHERE employee_id IN (
			SELECT DISTINCT manager_id
			FROM employees e,(
					SELECT department_id,AVG(salary) avg_sal
					FROM employees
					GROUP BY department_id
					ORDER BY avg_sal DESC
					LIMIT 0,1
					) t_dept_avg_sal
			WHERE e.`department_id` = t_dept_avg_sal.department_id
			);


#15. 查询部门的部门号，其中不包括job_id是"ST_CLERK"的部门号

# 自己想
# 1、先查询job_id为"ST_CLERK"的department_id
# 2、将1作为筛选条件，再查询department_id不在1中的数据
select department_id from departments where department_id not in (
select distinct department_id from employees where job_id ='ST_CLERK');



#方式1：
SELECT department_id
FROM departments
WHERE department_id NOT IN (
			SELECT DISTINCT department_id
			FROM employees
			WHERE job_id = 'ST_CLERK'
			);

#方式2：
SELECT department_id
FROM departments d
WHERE NOT EXISTS (
		SELECT *
		FROM employees e
		WHERE d.`department_id` = e.`department_id`
		AND e.`job_id` = 'ST_CLERK'
		);



#16. 选择所有没有管理者的员工的last_name
# 自己想
select employee_id,last_name from employees where manager_id is null;



SELECT last_name
FROM employees emp
WHERE NOT EXISTS (
		SELECT *
		FROM employees mgr
		WHERE emp.`manager_id` = mgr.`employee_id`
		);

#17．查询员工号、姓名、雇用时间、工资，其中员工的管理者为 'De Haan'
# 自己想
select employee_id,last_name,hire_date,salary 
FROM employees 
where manager_id IN(
select e1.employee_id from employees e1,employees e2 where e1.manager_id = e2.employee_id and e1.last_name='De Haan');





#方式1：
SELECT employee_id,last_name,hire_date,salary
FROM employees
WHERE manager_id IN (
		SELECT employee_id
		FROM employees
		WHERE last_name = 'De Haan'
		);

#方式2：
SELECT employee_id,last_name,hire_date,salary
FROM employees e1
WHERE EXISTS (
		SELECT *
		FROM employees e2
		WHERE e1.`manager_id` = e2.`employee_id`
		AND e2.last_name = 'De Haan'
		); 


#18.查询各部门中工资比本部门平均工资高的员工的员工号, 姓名和工资（相关子查询）
# 自己写
select e1.last_name,e1.salary,e1.department_id from employees e1,(select department_id,avg(salary) avg_sal from employees group by department_id) t_tmp where e1.department_id = t_tmp.department_id and e1.salary > t_tmp.avg_sal;



#方式1：使用相关子查询
SELECT last_name,salary,department_id
FROM employees e1
WHERE salary > (
		SELECT AVG(salary)
		FROM employees e2
		WHERE department_id = e1.`department_id`
		);

#方式2：在FROM中声明子查询
SELECT e.last_name,e.salary,e.department_id
FROM employees e,(
		SELECT department_id,AVG(salary) avg_sal
		FROM employees
		GROUP BY department_id) t_dept_avg_sal
WHERE e.department_id = t_dept_avg_sal.department_id
AND e.salary > t_dept_avg_sal.avg_sal


#19.查询每个部门下的部门人数大于 5 的部门名称（相关子查询）

SELECT department_name
FROM departments d
WHERE 5 < (
	   SELECT COUNT(*)
	   FROM employees e
	   WHERE d.department_id = e.`department_id`
	  );


#20.查询每个国家下的部门个数大于 2 的国家编号（相关子查询）

SELECT * FROM locations;

SELECT country_id
FROM locations l
WHERE 2 < (
	   SELECT COUNT(*)
	   FROM departments d
	   WHERE l.`location_id` = d.`location_id`
	 );

/* 
子查询的编写技巧（或步骤）：① 从里往外写  ② 从外往里写

如何选择？
① 如果子查询相对较简单，建议从外往里写。一旦子查询结构较复杂，则建议从里往外写
② 如果是相关子查询的话，通常都是从外往里写。

*/