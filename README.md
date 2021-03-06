# SQL-ProcBench

Procedural extensions of SQL have been in existence for many decades now. However, little is known about their magnitude of usage and their complexity in real-world workloads. Procedural code executing in a RDBMS is known to have inefficiencies and limitations; as a result there have been several efforts to address this problem. However, the lack of understanding of their use in real workloads makes it challenging to (a) motivate new work in this area, (b) identify research challenges and opportunities, and (c) demonstrate impact of novel work. To address these limitations, we introduce ***SQL-ProcBench***, an open benchmark for procedural workloads in RDBMSs. 

SQL-ProcBench has been carefully and systematically created to model real production scenarios. We have conducted an in-depth analysis of thousands of procedures from real workloads. The insights gained from our analysis has been used to create this benchmark so as to ensure that the complexity, usage patterns and scenarios reflect real workloads. More details about this benchmark can be found in the following VLDB publication:

[Procedural Extensions of SQL: Understanding their usage in the wild.](http://www.vldb.org/pvldb/vol14/p1378-ramachandra.pdf) \
Surabhi Gupta and Karthik Ramachandra. \
PVLDB, 14(8): 1378 - 1391, 2021. doi:10.14778/3457390.3457402 

This repository contains the SQL-ProcBench benchmark source code in 3 SQL dialects: T-SQL, PLPgSQL and PLSQL.

## Directory Structure	
<pre>
src/ 
  T-SQL/ 
    Scalar UDFs/
    Stored Procedures/
    Table Valued UDFs/
    Triggers/
  PLSQL/
    Scalar UDFs/
    Stored Procedures/
    Table Valued UDFs/
    Triggers/
  PLPgSQL/
    Scalar UDFs/
    Stored Procedures/
    Table Valued UDFs/
    Triggers/
  SQL-ProcBench Schema.txt
  indexes.txt
</pre>

There is a top level directory for each of the three dialects. Each top directory contains 4 sub-directories - one each for Scalar UDFs, Table UDFs, Stored Procedures and Triggers. Each of these directories contain the individual object files which follow the naming convention as described below. Each file has an object definition as a CREATE statement and some also include invocation query examples with plausible parameter values.

The file 'SQL-ProcBench Schema.txt' contains details about the augmented TPCDS schema used for procbench and includes the DML statements used to create the augmented tables. The same file also describes the process of loading data into the augmented tables. 

The file 'indexes.text' contains the information on indexes and index creation statements.

***File Naming Convention:*** Stored procedures are named as proc\_\<i\>\_\<name\>, scalar UDFs are named as sudf\_\<i\>\_\<name\>, table valued functions named as tvf\_\<i\>\_\<name\> and triggers are named as trig\_\<i\>\_\<name\>; where \<i\> is a number identifying the object and \<name\> is the name of the object as created inside the database.

## Setup
1. Create the required tables and indexes using the SQL-ProcBench Schema.txt and indexes.txt files.
2. Load tpc-ds data into the tables. Data loading instructions for augmented tables can be found in 'SQL-ProcBench Schema.txt' file.
3. Create procedures by using the create statement commands from the appropriate SQL dialect.
4. The query examples are given along with each procedure, which can be used to run it. 

### Known limitations:
1) The primary implementation of the benchmark has been done in T-SQL which is then translated to the other dialects. PLPgSQL and PLSQL do not have table variables and these have been implemented using set of records for some of the objects. Implementation for a few other objects which use table variables in these two dialects is still ongoing.
2) PLPgSQL and PLSQL do not support non-result accumulating select statements inside stored procedures. These have been implemented using REF CURSORS in both these dialects.


## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.

## Trademarks

This project may contain trademarks or logos for projects, products, or services. Authorized use of Microsoft 
trademarks or logos is subject to and must follow 
[Microsoft's Trademark & Brand Guidelines](https://www.microsoft.com/en-us/legal/intellectualproperty/trademarks/usage/general).
Use of Microsoft trademarks or logos in modified versions of this project must not cause confusion or imply Microsoft sponsorship.
Any use of third-party trademarks or logos are subject to those third-party's policies.
