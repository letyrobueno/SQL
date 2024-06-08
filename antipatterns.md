# Notes on SQL Antipatterns
## Avoiding the Pitfalls of Database Programming
## By Bill Karwin

### 1. Jaywalking

**Antipattern:** Make a field to be a format comma-separated list instead of using an intersection table. 

**Example:** ``Products`` table with an ``account_id`` column to indicate the employee(s) responsable for a product. 

**Problems:** 

* Querying is difficult and not vendor-neutral.
* Joins are awkward and costly.
* Aggregations require using tricks that may not work for some queries.
* Like for static lists, insertion is cheap, but updating and removal get complicated.
* Validation of invalid entries doesn't come without a complicated workaround.
* Choosing a separator character is difficult as it's not possible to guarantee that the separator will never appear in an entry.
* List length limitations: how long is long enough to that column? ``varchar(30)``? ``varchar(255)``? That depends on how many entries we need. Difficult to estimate.

**Solution:** create a ``Contacts`` table to act as an intersection table between ``Products`` and ``Accounts`` tables.

### 2. Naive Trees

**Antipattern:** Always depending on one's parent, i.e. building hierarchy using a ``parent_id`` column to act as an adjacency list.

**Example:** A post with many comments.

**Problems:**

* It fails to be a solution for one of the most common tasks we need to do with a tree: query all descendants.

* Adding a new leaf and relocating are easy tasks. However, deleting is more complex, especially for nodes in the middle of a subtree. A lot of code to write for tasks that a database should make simpler and more efficient.

**Solutions:** path enumeration, nested sets, or closure table. 


### 3. Rounding errors

**Antipattern:** Programmers naturally use the SQL `float` data type everywhere they need fractional numeric data because they are accustomed to programming with the float data type.

**Problems:**
* Rounding problems as float is not the appropriate data type for this, it just shares the same name as the data type usually used in most programming languages.

**Solution:** Use NUMERIC or DECIMAL data type for fixed-precision fractional numbers.

### 4. Use NULL as an ordinary value

**Antipattern:** The behavior of null in SQL is different from most programming languages. SQL treats null as a special value, different from zero, false, or an empty string.

**Solution:** Be careful when using columns with null in expressions like concatenations, multiplications, etc. Null is not zero and it's not an empty string.

### 5. Spaghetti Query

**Antipattern:** Solve a complex problem in one step.

**Example:** trying to get many complex metrics in one SQL query.

**Problems:**
* Difficult to troubleshoot.
* It may cause a cartesian product.

**Solution:** Divide and conquer. The **law of parsimony (by William of Ockham)**: when you have two competing theories that make exactly the same predictions, the simpler one is the better. Do one step at each time and then you can combine the results of several queries into one result set with the union operation, if really needed.

### 6. Implicit Columns

**Antipattern:** using wildcards and unnamed columns to satisfy less typing.

**Example:** `select * from table1` or `insert into table1 values (123, 'bla', 'bla')`.

**Problems:**

* **Breaking during refactoring**: adding or removing a column will break an insert statement.
* **Insert statement using implicit columns:** You must give values for all columns in the same order that columns are defined in the table.
* **Hidden costs:** Using wildcards can harm performance and scalability. Just grab what you need!

**Legitimate use of the antipattern:** ad hoc SQL scripts to explore data or test a solution.

**Solution:** Name columns explicitly. **Fail early principle**: If a column has been dropped from the table, the query will raise an error but it's a good error because it leads directly to the code that needs fixing.
