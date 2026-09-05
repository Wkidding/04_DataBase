# 题目

[183. 从不订购的客户](https://leetcode.cn/problems/customers-who-never-order/)

`Customers` 表：

```
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| name        | varchar |
+-------------+---------+
在 SQL 中，id 是该表的主键。
该表的每一行都表示客户的 ID 和名称。
```

`Orders` 表：

```
+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| customerId  | int  |
+-------------+------+
在 SQL 中，id 是该表的主键。
customerId 是 Customers 表中 ID 的外键( Pandas 中的连接键)。
该表的每一行都表示订单的 ID 和订购该订单的客户的 ID。
```

找出所有从不点任何东西的顾客。

以 **任意顺序** 返回结果表。

结果格式如下所示。

**示例 1：**

```
输入：
Customers table:
+----+-------+
| id | name  |
+----+-------+
| 1  | Joe   |
| 2  | Henry |
| 3  | Sam   |
| 4  | Max   |
+----+-------+
Orders table:
+----+------------+
| id | customerId |
+----+------------+
| 1  | 3          |
| 2  | 1          |
+----+------------+
输出：
+-----------+
| Customers |
+-----------+
| Henry     |
| Max       |
+-----------+
```

# 思路

本题中，两张表之间的联系为顾客ID（customerId），可以从Orders表中查询到已经购物的顾客ID，此时可采用Customers表左连接Orders表方式查询，连接条件为顾客ID。

1、Customers表左连接Orders表，left join是左连接，意思是左边的全保留，如果左边的和右边的不符合on的条件，那么左边对应右边的列自动为null
2、对于不在左表中的顾客，其customerId为null值，此时筛选出该部分顾客输出，则为未购物顾客

```mysql
-- 解法一：左连接 
select name as Customers 
from customers c
left join orders o
on c.id = o.customerId
where o.customerId is null;

-- 解法二：子查询
select name from customers where id not in (
	select customerId from orders
);

-- 解法二：子查询，使用not exists 代替 not in 
select name from customers where not exists (
	select customerId from orders where customerId = customers.id
);
```