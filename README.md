<h1>Intercars-DB</h1>

<h2>Intercars background</h2>

<p>
Intercars Leicester is an ambitious car dealership based in Leicester.<br>
They are very active in auctions in the east and west midlands.<br>
They have basic data collection techniques which could be significantly<br>
improved to enable them to gain greater insight from the data they collect<br>
which would in turn drive profitable decisions.
</p>

<h2>The project</h2>

<p>
Intercars Leicester were approached with the concept of migrating all their<br>
data which at the time was kept in paper form into an on premises MySQL database<br>
with a dedicated server laptop which could be connected to from any other laptops<br>
via ssh or via a GUI. Note, the GUI is the second part of this discontinued project.
</p>

<h2>Data modelling</h2>

<h3>Conceptual Data Model</h3>
<p>
To kick start the project, a few weeks were spent understanding how the<br>
business operates and what data they collect. From this a general picture emerged<br>
of organising the data into 4 distinct types of tables: <br>

<ul>
<li> <b>Info:</b> These types of tables store information<br>about the stakeholders of the business</li>
<li> <b>Operations:</b> These types of tables are for<br>the day to day business activities/operations</li>
<li> <b>Vehicle Finance:</b> These types of tables are for vehicle transactions and vehicle receipts</li>
<li> <b>Vehicle History:</b> These types of tables hold historical records for the vehicle.</li>
</ul>

</p>

<h3>Logical Data Model</h3>

<p>
For each table all of it's variables and variable characteristics were considered<br>
After this period, the database structure/architecture was drawn using the EER diagram<br>
i.e. the tables, table types, variables, variable types and characteristics;<br>
primary keys, foreign keys etc see <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/1.%20Documents">1. Documents</a> <b>Intercars DB Concept_Sep2021.xlsx</b><br>
under Documents and or the EER diagram  <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/2.%20EER">2. EER</a>

A <strong>Data Dictionary</strong> for the database consisting of 6 columns was then created:<br>

<ul>

<li> <strong>Type:</strong> The table type/group as described above</li>
<li> <strong>Table:</strong> The table name</li>
<li> <strong>Variable:</strong> The variable name</li>
<li> <strong>Type:</strong> The variable type e.g. Varchar, INT or BIGINT</li>
<li> <strong>Miscellaneous:</strong> The variable characteristics e.g. Primary key,<br>Foreign key, not null, unique, auto-increment etc</li>
<li> <strong>Description:</strong> A short explanation of what the variable is<br>giving context to the variable</li>

</ul>

This can also be found under <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/1.%20Documents">1. Documents</a>.<br>

At this point it was decided not to index the database, as that can be done later.

</p>

<h3>Physical Data Model</h3>

<p>
Various tasks were undertaken to ensure that the eventual database was a summarised reflection of the business.<br>
Once the database setup was created, <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/3. DB setup">3. DB setup</a>
the combination of procedures <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/4.%20Procedures">4. Procedures</a><br>
 and triggers <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/5.%20Triggers">5. Triggers</a>
were used for trafficking data to it's final destination.
</p>


<h2>Testing</h2>

<p>
Manual testing of data entry into the various tables was carried out to ensure the data transportation<br>
to its final destination was accurate and successful. You can find the testing at <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/6.%20Testing">6. Testing</a>
</p>

<h2>Database Backup</h2>

<p>
<b>Note:</b> The db backup files here are for testing only. There is no live db backups in this repo.<br>
However, the backup script, that would have been used for backing up the database is included.<br>
You can find the backup folder in <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/8.%20DB%20Backup">8. DB Backup</a>
</p>

<h2>Additional remarks</h2>
<p>
Since the project was discontinued and Intercars did not object to the publishing of<br>
this body of work to illustrate my capabilities, in additions to me owning this project,<br>
I have decided to publish it publicly.

<b>Note:</b> This project is part 1 of the discontinued project.<br>
You can find the second part, The Graphical User Interface (GUI) built with python and kivy here <a href="https://github.com/ManunEbo/Intercars-DB-GUI">Intercars-DB-GUI</a>
<br><br>
The whole project was certainly an enjoyable experience: I learned a great deal, in a very short period of time.

</p>
