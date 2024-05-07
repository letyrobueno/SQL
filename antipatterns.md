# Notes on SQL Antipatterns
## Avoiding the Pitfalls of Database Programming
## By Bill Karwin

### 1. Jaywalking

**Antipattern:** Making a field to be a format comma-separated list instead of using an intersection table. 

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
