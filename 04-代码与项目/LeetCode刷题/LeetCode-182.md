# 题目

[182. 查找重复的电子邮箱](https://leetcode.cn/problems/duplicate-emails/)

表: `Person`

```mysql
+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| email       | varchar |
+-------------+---------+
id 是该表的主键（具有唯一值的列）。
此表的每一行都包含一封电子邮件。电子邮件不包含大写字母。
```

编写解决方案来报告所有重复的电子邮件。 请注意，可以保证电子邮件字段不为 NULL。

以 **任意顺序** 返回结果表。

结果格式如下例。

**示例 1:**

```
输入: 
Person 表:
+----+---------+
| id | email   |
+----+---------+
| 1  | a@b.com |
| 2  | c@d.com |
| 3  | a@b.com |
+----+---------+
输出: 
+---------+
| Email   |
+---------+
| a@b.com |
+---------+
解释: a@b.com 出现了两次。
```

# 思路

本题中，仅有一张Person表，表中含有员工ID及其员工email，需要查询重复的Email（员工ID可能不重复）

本题可以从分组入手，即按照Email 字段分组，统计每组的数量，如果数量大于1，则表明该表中这个email有重复。

1、按照email分组，统计每个分组的数量
2、对于数量大于1 的组，输出其email值，则为重复的Email了

```mysql
-- 解法一：group by 分组 + having过滤 
select email as Email
from Person p1
group by email
having count(1)>1;

-- 解法二：自连接方式
SELECT DISTINCT p1.Email
FROM Person p1, Person p2
WHERE p1.Id != p2.Id and p1.Email = p2.Email
```
