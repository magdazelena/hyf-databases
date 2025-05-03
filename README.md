
 
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


# Security

## 31. SQL Injection

* A way "hackers" trick SQL into running bad commands.
* Happens when you put user input directly into SQL queries.

### 1. How a "hacker" can input a bad command

Imagine a login form in HTML:

```html
<input type="text" name="username">
```

And a JavaScript backend that builds a query like this:

```javascript
const sql = "SELECT * FROM users WHERE username = '" + input + "'";
```

If someone types this into the form:

```
x' OR '1'='1
```

The SQL becomes:

```sql
SELECT * FROM users WHERE username = 'x' OR '1'='1';
```

### 2. Example of actual nasty behavior

```sql
SELECT * FROM users WHERE username = 'admin' --' AND password = 'wrong';
```

The `--` turns the rest into a comment. This bypasses the password check entirely.

Or worse:

```sql
'; DROP TABLE users; --
```

This deletes your entire user table if not protected.

### 3. Why '1=1' is dangerous

* `'1=1'` is always true.
* So the WHERE clause selects **every row**.
* The "hacker" gains access to **all data**, not just their own.

### Bad (Vulnerable) Example:

```sql
SELECT * FROM users WHERE name = '" + userInput + "';
```

### Fix:

* Use **prepared statements** or parameterized queries.

### What is a parameterized query?

* It means you **don’t build the SQL string by mixing in user input**.
* Instead, you use a **placeholder** (like `?` or named variables), and give the values separately.
* This way, the SQL engine knows what’s part of the query and what’s just a value.
* It completely separates data from code.

### Why it's safer:

* User input can never change the structure of the SQL.
* Even if a user types something dangerous, it’s just treated as plain text.

### Example in MySQL (using CLI or stored procedures):

```sql
PREPARE stmt FROM 'SELECT * FROM users WHERE name = ?';
SET @name = 'Alice';
EXECUTE stmt USING @name;
```

### Example in Node.js (mysql2):

```javascript
const mysql = require('mysql2');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'testdb'
});

const name = userInput;
connection.execute(
  'SELECT * FROM users WHERE name = ?',
  [name],
  (err, results) => {
    if (err) throw err;
    console.log(results);
  }
);
```

### Example in Node.js (mysql2):

```javascript
connection.execute("SELECT * FROM users WHERE name = ?", [userInput]);
```


## 32. User GRANTS

* Control what users can and cannot do.
* Use `GRANT` and `REVOKE`.

Example:

```sql
GRANT SELECT, INSERT ON mydb.* TO 'readonly'@'localhost';
REVOKE DELETE ON mydb.* FROM 'readonly'@'localhost';
```

---


# NoSQL Basics


# 33. What is a Non-Relational Database?

* Also called **NoSQL** databases.
* Don’t use tables, rows, or JOINs.
* Use **documents**, **key-value pairs**, **graphs**, or **columns**.

## Differences from Relational Databases

| Feature        | Relational (SQL)      | Non-Relational (NoSQL)                     |
| -------------- | --------------------- | ------------------------------------------ |
| Data Structure | Tables (rows/columns) | Documents (JSON-like), key-values, etc.    |
| Schema         | Fixed structure       | Flexible and dynamic                       |
| Relationships  | JOINs, foreign keys   | Embedded or referenced manually            |
| Transactions   | Strong ACID           | Often eventual consistency or per-document |
| Query Language | SQL                   | Custom (Mongo uses BSON/JavaScript style)  |
| Scaling        | Vertical (scale up)   | Horizontal (scale out)                     |

### What does scaling mean?

**Scaling** means making your system handle more users or more data without breaking.

#### Vertical Scaling (Scale Up)

* Add more power to one machine.
* Example: upgrade your server from 8GB RAM to 32GB RAM.
* Pros: Simple, no code changes.
* Cons: Expensive, limited by hardware.

#### Horizontal Scaling (Scale Out)

* Add more machines to share the load.
* Example: instead of one big server, use 5 smaller servers.
* Pros: Handles huge loads, scalable.
* Cons: Needs more setup and sometimes changes in code.

## When to Use NoSQL Instead of SQL

Use a non-relational database when:

* You don’t know the data structure in advance.
* You need to store flexible, evolving data.
* You have lots of small updates to one object.
* You want fast reads/writes without JOINs.
* You need to scale across many servers.

### Example Use Cases

* Social media user profiles (different users have different fields).
* Product catalogs where each item has custom fields.
* IoT data streams with time-series data.



# 34. Introduction to Non-Relational Data with MongoDB

* MongoDB is a NoSQL database.
* Stores data in **documents** (like JSON).
* No tables, rows — instead collections and documents.

**Example Document:**

```json
{
  "name": "Alice",
  "age": 25,
  "email": "alice@example.com"
}
```

---

## How MongoDB Stores Data (Documents and DBMS Perspective)

* In MongoDB, data is stored in **collections** of **documents**.
* A **document** is like a record, but it's flexible and JSON-like.
* Documents are stored inside a **database**, just like SQL tables live inside a database.
* MongoDB has its own DBMS, like MySQL does, but it handles documents instead of tables.
* Documents are physically saved as **BSON** (a binary version of JSON) on disk, managed by the MongoDB DBMS.

### Mapping SQL Terms to MongoDB:

| SQL         | MongoDB                           |
| ----------- | --------------------------------- |
| Table       | Collection                        |
| Row         | Document                          |
| Column      | Field (key)                       |
| Schema      | Schema-less (optional validation) |
| Primary Key | \_id                              |

**Example:**

* SQL: One row in a `users` table
* MongoDB: One document in a `users` collection

```json
{
  "_id": "1234",
  "name": "Alice",
  "email": "alice@example.com",
  "age": 25
}
```

The MongoDB server manages these documents, indexes them, and makes them searchable — similar to how a SQL DBMS like MySQL stores and retrieves rows.

## 35. Create/Drop a Database

**MongoDB:**

```js
db = connect('mongodb://localhost:27017/mydb');
use mydb;
```

Dropping:

```js
db.dropDatabase();
```

## 36. Insert/Update/Delete Data

```js
// Insert
 db.users.insertOne({ name: "Alice", age: 25 });

// Update
 db.users.updateOne({ name: "Alice" }, { $set: { age: 26 }});

// Delete
 db.users.deleteOne({ name: "Alice" });
```

## 37. Query Data

```js
db.users.find({ age: { $gt: 18 } });
```

## 38. Relationships: Embedded vs Referenced

### What does a relationship in MongoDB look like?

* In **relational databases**, relationships between tables are typically handled using **foreign keys**. For example, if you have a **users** table and an **addresses** table, each address could have a foreign key referencing the user it belongs to.
* In **MongoDB**, relationships can be either **embedded** (store related data in one document) or **referenced** (store references to another document).

### 1. **Embedded Relationship**

* This means that the related data is stored **inside** the same document. It's like putting a sub-item inside a main item.

#### Example (Embedded Document)

Let's say you have a collection of **users**, and each user has an address. In this case, we store the **address** inside the **user document**.

```json
{
  "name": "Alice",
  "age": 25,
  "email": "alice@example.com",
  "address": {
    "city": "Paris",
    "zip": "75000"
  }
}
```

* **Pros of Embedded**:

  * Good for small amounts of related data.
  * Easy to read all the data in one query.
  * No need for joins or complex relationships.

* **When to use Embedded**:

  * Use this approach if the related data is **small** and **likely to be accessed together**. For example, the address is likely always needed when displaying the user's profile.

### 2. **Referenced Relationship**

* This means storing a reference to another document, rather than embedding the actual data. In MongoDB, this is often done by storing an **ID** (a unique reference) that points to another document.

#### Example (Referenced Relationship)

Now, instead of embedding the address directly in the user document, we store a reference to an **address document**.

```json
{
  "name": "Alice",
  "age": 25,
  "email": "alice@example.com",
  "address_id": "12345abcde"
}
```

And the **address** document:

```json
{
  "_id": "12345abcde",
  "city": "Paris",
  "zip": "75000"
}
```

* **Pros of Referenced**:

  * Good for **large** and **frequently changing** data that is shared between documents.
  * Avoids duplicating large pieces of data across multiple documents.

* **When to use Referenced**:

  * Use referenced relationships when the related data is **large** or **can be shared across multiple documents**. For example, if multiple users live at the same address, it is more efficient to reference that address rather than embedding it in every user document.

### Key Differences between Embedded and Referenced:

| Type         | Embedded                                                      | Referenced                                          |
| ------------ | ------------------------------------------------------------- | --------------------------------------------------- |
| Data Storage | Stores data inside the document itself                        | Stores references (IDs) to other documents          |
| Querying     | Fast to query, as everything is in one place                  | Requires an extra query to retrieve referenced data |
| Data Size    | Best for small data that's usually accessed together          | Best for large, shared, or frequently updated data  |
| Duplication  | Can cause duplication if multiple documents use the same data | Avoids data duplication by reusing references       |

---

## 39. Replication and Sharding

### What is **Replication** in MongoDB?

* **Replication** means making copies of your data across multiple servers to improve **availability** and **redundancy**.
* If one server goes down, another copy of the data is still available.

#### Example of Replication:

Imagine you have a MongoDB instance running on a server called **Server 1**. You set up **replication** so that another MongoDB server, **Server 2**, holds an exact copy of the data.

* If **Server 1** crashes, **Server 2** can continue serving data with no downtime.
* MongoDB achieves this by maintaining a **primary** server and **secondary** servers. The **primary** is where all writes happen, and the **secondaries** replicate the data from the primary.

**How Replication Works:**

1. **Primary server** handles all write operations.
2. **Secondary servers** replicate data from the primary server and become **read-only**.
3. If the primary server goes down, one of the secondary servers is promoted to primary.

**Why Replication is Important:**

* **High Availability**: If one server goes down, the database remains accessible.
* **Fault Tolerance**: Data is backed up across multiple servers, reducing the risk of losing it.

### What is **Sharding** in MongoDB?

* **Sharding** is the process of distributing data across multiple servers (called **shards**) to handle **large volumes of data** and improve **scalability**.
* Instead of having a single server handle all the data, you break the data into **chunks** and distribute them across multiple servers.

#### Example of Sharding:

Imagine you have a huge collection of **user data**. If you put all users' data on one server, it will eventually become too large to manage. With sharding, you can **split** the data into smaller parts, each stored on a different server.

* For example, you could store users from **A-M** on one server, and users from **N-Z** on another.
* MongoDB uses a **shard key** to determine how the data is distributed.

**Why Sharding is Important:**

* **Scalability**: MongoDB can handle huge datasets by distributing them across many servers.
* **Efficient Data Storage**: Each server only stores a portion of the data, which helps manage resources better.

### When to Use Replication vs. Sharding:

* **Replication** is used to ensure high availability and fault tolerance, while **sharding** is used to handle large data sets by splitting them across multiple servers.

---

## 40. Atomicity in MongoDB

### What is **Atomicity**?

* **Atomicity** ensures that a database operation is **all-or-nothing**.
* If a database operation is atomic, it either **completes entirely** or **doesn't affect the data at all**. If something goes wrong, no partial changes are made.

#### Example of Atomicity:

Imagine you're transferring money between two accounts:

* **Account 1**: \$100
* **Account 2**: \$50
* You want to transfer \$30 from **Account 1** to **Account 2**.

An atomic operation ensures that:

* The \$30 is **deducted from Account 1**.
* The \$30 is **added to Account 2**.
* If something fails in between, no money is deducted or added to either account. It’s as if the operation never happened.

### MongoDB and Atomicity

* In **MongoDB**, atomicity is guaranteed at the **document level**. This means that a single document can be updated in a way that ensures consistency.
* However, MongoDB does not provide atomicity across multiple documents unless using **transactions** (more on that later).

#### Example in MongoDB:

If you have a document representing a **user** and you want to update the user's balance, MongoDB will ensure that the update operation happens **atomically**.

```json
{
  "_id": "user1",
  "name": "Alice",
  "balance": 100
}
```

Updating the **balance**:

```js
db.users.updateOne(
  { "_id": "user1" },
  { $set: { "balance": 120 } }
);
```

This update will either succeed entirely (set the balance to 120) or fail (no changes will happen).

### What About Multi-Document Transactions?

* If you need atomicity across **multiple documents**, MongoDB now supports **transactions** (since version 4.0).
* This means you can perform several operations across different documents and ensure they all succeed or fail together.

#### Example of Multi-Document Transaction:

```js
const session = client.startSession();
session.startTransaction();

try {
  db.users.updateOne(
    { _id: "user1" },
    { $set: { balance: 120 } },
    { session }
  );

  db.users.updateOne(
    { _id: "user2" },
    { $set: { balance: 80 } },
    { session }
  );

  session.commitTransaction();
} catch (error) {
  session.abortTransaction();
  throw error;
} finally {
  session.endSession();
}
```

