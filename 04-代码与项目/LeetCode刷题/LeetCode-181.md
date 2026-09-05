# 题目

[181. 超过经理收入的员工](https://leetcode.cn/problems/employees-earning-more-than-their-managers/)

表：`Employee` 

```sql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
| salary      | int     |
| managerId   | int     |
+-------------+---------+

/*
id 是该表的主键（具有唯一值的列）。
该表的每一行都表示雇员的ID、姓名、工资和经理的ID。
*/
```

编写解决方案，找出收入比经理高的员工。

以 **任意顺序** 返回结果表。

结果格式如下所示。

**示例 1:**

```sql
输入: 
Employee 表:
+----+-------+--------+-----------+
| id | name  | salary | managerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | Null      |
| 4  | Max   | 90000  | Null      |
+----+-------+--------+-----------+
输出: 
+----------+
| Employee |
+----------+
| Joe      |
+----------+
解释: Joe 是唯一挣得比经理多的雇员。
```

# 思路

本题中，仅有一张Employee表，表中含有员工ID及其经理ID，因此查询时可以进行自关联。
1、首先查询出每个员工的managerId，但有些员工的managerId可能为空，这些结果不需要记录
2、使用自连接，此时可能会导致产生 笛卡尔乘积 。在这种情况下，输出会产生 4*4=16 个记录。然而我们只对雇员工资高于经理的人感兴趣。因此我们应该用 WHERE 语句加 2 个判断条件。
3、连接条件设置为左表（作为经理表）e1.managerId = e2.id(右表作为员工表员工ID)，并且e1.salary > e2.salary;
4、也可以采用join on 方式处理自连接

```mysql
-- 解法一
select e1.name as "Employee"
from Employee e1, Employee e2
where e1.managerId = e2.id and e1.salary > e2.salary;

-- 解法二
select 
    a.name as Employee
from 
    Employee a
join Employee b
on a.managerId=b.id
and a.salary>b.salary
```



# 相关知识点

## 自连接

当table1和table2本质上是同一张表，只是用取别名的方式虚拟成两张表以代表不同的意义。然后两个表再进行内连接，外连接等查询。