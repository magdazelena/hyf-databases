# Database Fundamentals for Aspiring Full Stack Developers

---

# Basics of Databases

## 1. The Relational Model of Data
- Data is organized into tables (also called relations).
- Each table is made of rows (records) and columns (fields).
- Tables can be connected using relationships.
- Think of it like spreadsheets, but smarter: tables "talk" to each other.

## 2. 'Database' vs 'DBMS' (Database Management System)
- **Database**: A collection of data.
- **DBMS**: Software that manages databases (like MySQL, PostgreSQL, SQLite).

Example:
- Database = a library’s collection of books.
- DBMS = librarians managing and organizing the books.

## 3. The Concept of a Schema
- Schema = the blueprint for the database.
- Defines tables, columns, data types, and relationships.
- Tells the DBMS "what kind of data" and "how it should be organized."

Typical Schema Features:
- Tables
- Columns (with types like INT, VARCHAR, DATE, etc.)
- Primary Keys (unique ID per row)
- Foreign Keys (references to other tables)
- Indexes (for faster searches)
- Views (virtual tables)
- Triggers (auto-actions when something changes)
- Procedures and Functions (stored operations)

## 4. Properties of an Entity (Row)
- **Entity** = a real-world object represented as a row.
- Each entity has:
  - Attributes (columns)
  - A unique identifier (Primary Key)

| Attribute Type  | Example            | Data Type  |
|-----------------|--------------------|------------|
| Name            | "Alice"             | VARCHAR    |
| Age             | 30                  | INT        |
| Birthdate       | "1994-02-11"         | DATE       |
| Profile Picture | (binary data)        | BLOB       |
| Active Status   | true / false         | BOOLEAN (tinyint) |


## 5. Basic Entity Relationship Diagrams (ERDs)
- Shows how tables relate.
- Drawn as boxes (tables) connected by lines (relationships).

Example:
- A "Student" table connected to "Course" table through "Enrollment" table.

Simple Visual:
```
Student (student_id, name)
  |
  |--< Enrollment (student_id, course_id)
          |
          v
     Course (course_id, title)
```

---

# SQL Basics

## 6. A Basic SELECT Statement
```sql
SELECT * FROM students;
```
- Gets all columns (`*`) from "students" table.

## 7. More Complex SELECT Statements
```sql
SELECT name, birthdate FROM students WHERE age > 18 ORDER BY birthdate DESC;
```
- Selects specific columns.
- Filters with `WHERE`.
- Orders results.

## 8. Pattern Matching with LIKE
```sql
SELECT name FROM students WHERE name LIKE 'A%';
```
- Finds names starting with 'A'.

## 9. Limiting and Ordering Results
```sql
SELECT * FROM students ORDER BY age DESC LIMIT 5;
```
- `ORDER BY` sorts.
- `LIMIT` restricts how many rows you get.

## 10. Grouping Results with GROUP BY
```sql
SELECT course_id, COUNT(*) FROM enrollments GROUP BY course_id;
```
- Groups rows with same course_id.
- Useful when you want summaries.

**GROUP BY is needed when:**
- You want one row per group (like "count of students per course").

## 11. Aggregate Functions
- **AVG**: Average value
- **COUNT**: How many rows
- **SUM**: Total
- **MIN**/**MAX**: Smallest/largest value

Example:
```sql
SELECT course_id, AVG(grade) FROM enrollments GROUP BY course_id;
```

## 12. JOIN
- Combines data from multiple tables.

Example:
```sql
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


