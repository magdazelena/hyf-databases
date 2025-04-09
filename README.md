# Database Fundamentals #1

## 1. The Relational Model of Data
- A **relational database** organizes data into **tables** (also called **relations**).
- Think of each table like a **spreadsheet**:
  - **Rows** (also called **records** or **tuples**) store individual data entries.
  - **Columns** (also called **fields** or **attributes**) define the type of data stored (e.g., name, age, email).
- Each table has a **primary key**, which uniquely identifies each row.
- Tables can be related using **foreign keys**, which are references to the primary key in another table.
- This model helps reduce redundancy and ensures data integrity.

**Real-world analogy:**
- Table = a class in a school (like "10th Grade")
- Row = a single student
- Column = a property like name, age, student ID
- Foreign key = student assigned to a specific desk (linked to a seat number)

## 2. Database vs DBMS
- **Database**: The actual data — stored in files, organized into tables.
- **DBMS (Database Management System)**: The software that lets you read/write/query data in the database.
- The DBMS:
  - Manages connections
  - Handles security, backups, and performance
  - Validates data integrity

**Examples of DBMS:**
- PostgreSQL
- MySQL
- SQLite
- Microsoft SQL Server
- Oracle

## 3. Schema
- A **schema** is like a **blueprint** or **map** of your database.
- It describes:
  - What tables exist
  - What columns each table has
  - Data types of each column (e.g., integer, text, date)
  - How tables relate to each other (foreign keys)
  - Rules for validation (e.g., constraints)

**Example:**
```text
Schema: ecommerce
Tables: users, orders, products
```

## 4. Entity (Row)
- An **entity** is a **single item** or **object** stored in a table.
- In relational databases, each entity is stored as a **row**.

**Example:**
A user entity might be:
```text
id: 1
name: "Alice"
email: "alice@example.com"
```
- Entities should be **unique** (often using an `id` column).
- Each entity shares the **same structure** (same columns) as others in the same table.

## 5. Basic Entity Relationship Diagram (ERD)
- An **ERD** visually shows how tables relate.
- Entities (tables) are boxes.
- Relationships (e.g. one-to-many) are lines between them.

```text
+--------+     1     *   +---------+
| Users  |-------------< | Posts   |
+--------+               +---------+
| id     |               | id      |
| name   |               | user_id |
+--------+               +---------+
```

- One user can have many posts.
- `user_id` in `Posts` is a **foreign key** pointing to `id` in `Users`.

## 6. Basic SELECT Statement
```sql
SELECT * FROM users;
SELECT name, email FROM users;
```

## 7. More Complex SELECT Statements
```sql
SELECT name FROM users WHERE age > 21;
SELECT * FROM posts WHERE published = TRUE AND created_at > '2024-01-01';
```

## 8. Pattern Matching with LIKE
```sql
SELECT * FROM users WHERE name LIKE 'J%';   -- Names starting with J
SELECT * FROM users WHERE email LIKE '%@gmail.com'; -- Gmail users
```

## 9. LIMIT and ORDER BY
```sql
SELECT * FROM posts ORDER BY created_at DESC LIMIT 10;
```

## 10. GROUP BY
- `GROUP BY` is used to **group rows that have the same values in specified columns**.
- Usually used with **aggregate functions** to calculate values for each group.

**Example:**
```sql
SELECT user_id, COUNT(*) FROM posts GROUP BY user_id;
```
- This returns the number of posts **per user**.
- Each group (user_id) has its own count.

Use cases:
- Count orders per customer
- Average score per student
- Total sales per product

## 11. Aggregate Functions
- `AVG(column)` - Average
- `COUNT(column)` - Count non-null
- `SUM(column)` - Total sum
- `MIN(column)` - Minimum
- `MAX(column)` - Maximum

```sql
SELECT AVG(age) FROM users;
SELECT COUNT(*) FROM posts WHERE published = TRUE;
```

## HAVING vs WHERE
- `WHERE` filters rows **before** grouping.
- `HAVING` filters groups **after** the `GROUP BY`.

**Example:**
```sql
-- Filter rows first
SELECT * FROM orders WHERE total > 100;

-- Group and filter groups
SELECT customer_id, SUM(total) AS total_spent
FROM orders
GROUP BY customer_id
HAVING SUM(total) > 1000;
```

Use `HAVING` when you want to filter based on aggregate functions.

## 12. JOINs
```sql
SELECT users.name, posts.title
FROM users
JOIN posts ON users.id = posts.user_id;
```
- Types:
  - `INNER JOIN` – Only matching rows
  - `LEFT JOIN` – All left + matched right rows
  - `RIGHT JOIN` – All right + matched left rows
  - `FULL JOIN` – All rows from both tables (PostgreSQL)

## 13. Composite Data from Multiple Tables
```sql
SELECT u.name, p.title, c.body
FROM users u
JOIN posts p ON u.id = p.user_id
JOIN comments c ON p.id = c.post_id;
```

## 14. JOIN vs Cartesian Product
- **Cartesian product** (no `JOIN` condition): multiplies every row of table A by every row of table B.
```sql
SELECT * FROM users, posts;  -- BAD: Returns n * m rows
```
- **JOIN with condition** filters meaningful relationships.
```sql
SELECT * FROM users JOIN posts ON users.id = posts.user_id;
```

## 15. Naming Conventions
- Use consistently within project/team.

| Style              | Example                |
|-------------------|------------------------|
| PascalCase        | `UserProfile`          |
| camelCase         | `userProfile`          |
| snake_case        | `user_profile`         |
| HungarianNotation | `strUserName`, `intId` |

- Recommended: `snake_case` for SQL/table/column names.
- Avoid Hungarian Notation in modern projects.

## 16. Character Sets
- Always use **UTF-8 encoding** to support international characters.
- In **MySQL**, use:
```sql
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci
```

## Further Reading / Resources
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [MySQL 8.0 Docs](https://dev.mysql.com/doc/)
- [SQLBolt (interactive SQL lessons)](https://sqlbolt.com/)
- [DB Fiddle (SQL online playground)](https://www.db-fiddle.com/)
- [drawSQL (ER diagram tool)](https://drawsql.app/)

