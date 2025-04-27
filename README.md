
 
 ---
 
 # Basics of Databases
 
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
 - Foreign key = student assigned to a specific teacher (linked to a teacher table)
 
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
 - It includes:
   - Tables
   - Columns for each table and their data types (e.g., INTEGER, VARCHAR, DATE)
   - Primary keys and foreign keys
   - Indexes (for faster querying)
   - Constraints:
     - `NOT NULL`: Column must have a value
     - `UNIQUE`: No duplicates allowed
     - `CHECK`: Validate values against a rule (e.g., age >= 18)
     - `DEFAULT`: Default value if none provided
   - Views (virtual tables based on SELECT queries)
   - Stored procedures and functions
   - Triggers (automated actions on data changes)
 
 **Example:**
 ```text
 Schema: ecommerce
 Tables:
   - users (id PK, email UNIQUE NOT NULL, created_at DEFAULT CURRENT_TIMESTAMP)
   - orders (id PK, user_id FK → users.id, total CHECK(total >= 0))
   - products (id PK, name NOT NULL, price DECIMAL)
 Indexes:
   - idx_user_email ON users(email)
 Views:
   - active_users AS SELECT * FROM users WHERE active = true;
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
 
 **Common entity data types:**
 
 | Type           | Description                             | SQL Type Examples         | Use Case Examples         |
 |----------------|-----------------------------------------|---------------------------|---------------------------|
 | Identifier     | Uniquely identifies the row             | `INT`, `UUID`, `BIGINT`  | Primary/foreign keys      |
 | Text           | Characters and strings                  | `VARCHAR`, `TEXT`         | Names, emails, addresses  |
 | Numeric        | Integer or decimal numbers              | `INT`, `DECIMAL`, `FLOAT`| Quantities, prices, age   |
 | Date/Time      | Time-related data                       | `DATE`, `TIMESTAMP`       | Creation date, birthdays  |
 | Boolean        | True/False                              | `BOOLEAN`                 | Is active?, Is deleted?   |
 | Binary         | Raw binary data                        | `BLOB`, `BYTEA`           | Files, images, hashes     |
 | Enum/Set       | Limited set of predefined values        | `ENUM`, `SET` (MySQL)     | Status, roles, flags      |
 
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
 

 # SQL Basics
 
 ## 6. A Basic SELECT Statement
 ```sql
 SELECT * FROM users;
 SELECT name, email FROM users;
 SELECT * FROM students;
 ```
 - Gets all columns (`*`) from "students" table.
 
 ## 7. More Complex SELECT Statements
 ```sql
 SELECT name FROM users WHERE age > 21;
 SELECT * FROM posts WHERE published = TRUE AND created_at > '2024-01-01';
 SELECT name, birthdate FROM students WHERE age > 18 ORDER BY birthdate DESC;
 ```
 - Selects specific columns.
 - Filters with `WHERE`.
 - Orders results.
 
 ## 8. Pattern Matching with LIKE
 ```sql
 SELECT * FROM users WHERE name LIKE 'J%';   -- Names starting with J
 SELECT * FROM users WHERE email LIKE '%@gmail.com'; -- Gmail users
 SELECT name FROM students WHERE name LIKE 'A%';
 ```
 - Finds names starting with 'A'.
 
 ## 9. Limiting and Ordering Results
 ```sql
 SELECT * FROM posts ORDER BY created_at DESC LIMIT 10;
 SELECT * FROM students ORDER BY age DESC LIMIT 5;
 ```
 - `ORDER BY` sorts.
 - `LIMIT` restricts how many rows you get.
 
 ## 10. GROUP BY
 - `GROUP BY` is used to **group rows that have the same values in specified columns**.
 - Usually used with **aggregate functions** to calculate values for each group.
 

 ```sql
 SELECT user_id, COUNT(*) FROM posts GROUP BY user_id;
 SELECT course_id, COUNT(*) FROM enrollments GROUP BY course_id;
 ```
 - This returns the number of posts **per user**.
 - Each group (user_id) has its own count.
 - Groups rows with same course_id.
 - Useful when you want summaries.
 
 Use cases:
 - Count orders per customer
 - Average score per student
 - Total sales per product
 **GROUP BY is needed when:**
 - You want one row per group (like "count of students per course").
 
 ## 11. Aggregate Functions
 - `AVG(column)` - Average
 - `COUNT(column)` - Count non-null
 - `SUM(column)` - Total sum
 - `MIN(column)` - Minimum
 - `MAX(column)` - Maximum
 - **AVG**: Average value
 - **COUNT**: How many rows
 - **SUM**: Total
 - **MIN**/**MAX**: Smallest/largest value
 
 Example:
 ```sql
 SELECT AVG(age) FROM users;
 SELECT COUNT(*) FROM posts WHERE published = TRUE;
 SELECT course_id, AVG(grade) FROM enrollments GROUP BY course_id;
 ```
 
 ## HAVING vs WHERE
 - `WHERE` filters rows **before** grouping.
 - `HAVING` filters groups **after** the `GROUP BY`.

  -- Group and filter groups
 SELECT customer_id, SUM(total) AS total_spent
 FROM orders
 GROUP BY customer_id
 HAVING SUM(total) > 1000;
 
 ## 12. JOIN
 - Combines data from multiple tables.
 
 **Example:**
 Example:
 ```sql
 -- Filter rows first
 SELECT * FROM orders WHERE total > 100;
 SELECT students.name, enrollments.grade
 FROM students
 JOIN enrollments ON students.student_id = enrollments.student_id;
 ```
 
 ## 13. Selecting Composite Data from Multiple Tables
 - JOIN lets you fetch combined info from several tables in one query.
 
 ## 14. Compare JOIN WHERE vs Cartesian Product
 - Without JOIN, `SELECT * FROM A, B` creates a giant mess (every row paired with every other row — Cartesian product).
 - JOIN links only matching rows based on a condition.
 
 ---
 
 # Good Practices
 
 ## 15. Naming Conventions
 - **UpperCamelCase**: StudentGrade
 - **lowerCamelCase**: studentGrade
 - **snake_case**: student_grade
 - **hnHungarianNotation**: intStudentGrade
 
 Use snake_case for SQL usually.
 
 ## 16. Character Sets in Databases
 - Always use **UTF-8** encoding.
 - In MySQL, use `utf8mb4` (supports emojis and special characters properly).
 

---

# Good Practices

## 15. Naming Conventions
- **UpperCamelCase**: StudentGrade
- **lowerCamelCase**: studentGrade
- **snake_case**: student_grade
- **hnHungarianNotation**: intStudentGrade

Use snake_case for SQL usually.

## 16. Character Sets in Databases
- Always use **UTF-8** encoding.
- In MySQL, use `utf8mb4` (supports emojis and special characters properly).

---

# Data Definition and Manipulation

## 17. Data Definition Language (DDL)
- Commands that define or change structure.
- Examples: CREATE, ALTER, DROP.

## 18. Creating Tables
```sql
CREATE TABLE students (
  student_id INT PRIMARY KEY,
  name VARCHAR(100),
  birthdate DATE
);
```

## 19. Altering Tables
```sql
ALTER TABLE students ADD email VARCHAR(100);
```

## 20. Indexes
- Speeds up searching.
```sql
CREATE INDEX idx_name ON students(name);
```

## 21. Foreign Key Constraints
- Ensures a link between tables.
```sql
ALTER TABLE enrollments
ADD FOREIGN KEY (student_id) REFERENCES students(student_id);
```

## 22. INSERT INTO
```sql
INSERT INTO students (student_id, name) VALUES (1, 'Alice');
```

## 23. UPDATE
```sql
UPDATE students SET name = 'Alicia' WHERE student_id = 1;
```

## 24. DELETE
```sql
DELETE FROM students WHERE student_id = 1;
```

---

# Deeper into Relationships

## 25. More Complex Entity Relationship Diagrams
- Many-to-Many relations need a third table (associative table).

## 26. Associative Entities
- A table that connects two entities.
Example: Enrollment connects Students and Courses.

---

## 27. Introduction to Normalisation

- Normalisation is like organizing your toy boxes so every toy is in the right place and not repeated.
- It breaks down big, messy tables into smaller, cleaner ones.

### Main Goals:

- Avoid storing the same information multiple times.
- Make sure everything is where it belongs.
- Make updates safer and faster.

### Forms (Levels of Normalisation):

#### First Normal Form (1NF)

- Rule: One value per box (no lists or sets in a cell).
- Example:
  - ❌ "Colors: Red, Blue, Green" in one cell
  - ✅ One row for each color or move colors to a related table

#### Second Normal Form (2NF)

- Applies only if your table has a **composite primary key** (more than one column).
- Rule: Every column must describe **the whole key**, not just one part.
- Think of this like:
  > If your key is (student\_id, course\_id), then columns should describe this pair — not just the student, or just the course.
- ❌ Bad table:
  | student\_id                                                    | course\_id | student\_name |
  | -------------------------------------------------------------- | ---------- | ------------- |
  | 1                                                              | 101        | Alice         |
  | 1                                                              | 102        | Alice         |
  | `student_name` depends only on `student_id`, not the full key. |            |               |
- ✅ Fix:
  - Make a separate table just for students:
    | student\_id | student\_name |
    | ----------- | ------------- |
    | 1           | Alice         |

#### Third Normal Form (3NF)

- Rule: Columns must depend **only on the key, and nothing else**.

- That means: no indirect info that could live elsewhere.

- Think of it like:

  > Don’t put “country” and “currency” in the same table if currency depends on the country.

- ❌ Bad table:

  | employee\_id | country | currency |
  | ------------ | ------- | -------- |
  | 1            | USA     | USD      |
  | 2            | Japan   | JPY      |

  Here, currency depends on country — not on employee.

- ✅ Fix:

  - Separate the data:
    - **Employees**: employee\_id, country
    - **Countries**: country, currency

### Visual Analogy:

- **1NF**: Every drawer in your toolbox has just one tool (not a pile of junk).
- **2NF**: No tool belongs in the wrong drawer because someone mislabeled it.
- **3NF**: No labels stuck on top of other labels — everything is direct and obvious.

---

## 28. Complicated Values to Store in MySQL

### Are Booleans Possible in MySQL?

- MySQL doesn’t have a special BOOLEAN type under the hood.
- But `BOOLEAN` or `BOOL` is just an alias for `TINYINT(1)`:
  ```sql
  is_active BOOLEAN  -- works fine
  ```
- Use 0 for `false`, 1 for `true`. Your code or ORM (like Sequelize) can treat this as a boolean.

---

## 29. Storing Prices (Floating Point Errors)

- **Computers use binary**, which can’t exactly store all decimal numbers like 0.1 or 10.99.
- Why? Because just like you can’t write 1/3 as a full decimal (it’s 0.3333...), computers can’t represent many decimals perfectly.
- Using `FLOAT` or `DOUBLE` might cause rounding issues. Example:
  ```sql
  SELECT 0.1 + 0.2; -- might return 0.30000000000000004
  ```
- For money, use **DECIMAL(10, 2)**:
  ```sql
  price DECIMAL(10, 2);  -- precise to two decimal places
  ```
- This avoids losing cents in calculations — very important in billing systems.

---

## 30. Storing Date and Time

### Common Data Types:

- `DATE` — only stores year/month/day (e.g., `2025-04-25`)
- `TIME` — only stores time (e.g., `14:30:00`)
- `DATETIME` — stores both date and time, without timezone
- `TIMESTAMP` — stores in UTC, converts automatically to your system’s timezone if needed

### Use Cases:

- `created_at DATETIME` — if you want exact date/time as entered
- `updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP` — if you want auto-tracked time that adjusts with timezone

### Example:

```sql
CREATE TABLE events (
  name VARCHAR(100),
  event_date DATE,
  start_time TIME,
  created_at DATETIME,
  updated_at TIMESTAMP
);

-- Insert values
INSERT INTO events 
VALUES (
  'Launch Webinar', 
  '2025-07-15', 
  '17:00:00', 
  '2025-07-10 09:30:00', 
  CURRENT_TIMESTAMP
);
```

- `created_at = '2025-07-10 09:30:00'` → fixed value, never changes
- `updated_at = CURRENT_TIMESTAMP` → current UTC time (e.g., `2025-07-10 07:30:00` if your timezone is UTC+2)


