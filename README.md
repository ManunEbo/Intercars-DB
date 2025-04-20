<h1>Intercars-DB</h1>

<h3>Intercars background</h3>

<p>
Intercars Leicester is an ambitious car dealership based in Leicester.<br>
They are very active in auctions in the east and west midlands.<br>
They have basic data collection techniques which could be significantly<br>
improved to enable them to gain greater insight from the data they collect<br>
which would in turn drive profitable decisions.
</p>

<h3>The project</h3>

<p>
Intercars Leicester were approached with the concept of migrating all their<br>
data which at the time was kept in paper form into an on premises MySQL database<br>
with a dedicated server laptop which could be connected to from any other laptops<br>
via ssh or via a GUI. Note, the GUI is the second part of this discontinued project.
</p>

<h3>Data modelling</h3>

<h4>Conceptual Data Model</h4>
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

<h4>Logical Data Model</h4>

<p>
For each table all of it's variables and variable characteristics were considered<br>
After this period, the database structure/architecture was drawn using the EER diagram i.e. the tables, table types, variables, variable types<br>
and characteristics; primary keys, foreign keys etc see <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/Documents">1. Documents</a> <b>Intercars DB Concept_Sep2021.xlsx</b> under Documents.<br>
and or the EER diagram  <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/EER">2. EER</a>

A <strong>Data Dictionary</strong> for the database consisting of 6 columns was then created:<br>

<ul>

<li> <strong>Type:</strong> The table type/group as described above</li>
<li> <strong>Table:</strong> The table name</li>
<li> <strong>Variable:</strong> The variable name</li>
<li> <strong>Type:</strong> The variable type e.g. Varchar, INT or BIGINT</li>
<li> <strong>Miscellaneous:</strong> The variable characteristics e.g. Primary key, Foreign key, not null, unique, auto-increment etc</li>
<li> <strong>Description:</strong> A short explanation of what the variable is<br>giving context to the variable</li>

</ul>

This can also be found under <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/Documents">1. Documents</a>.<br>

At this point it was decided not to index the database, as that can be done later.

</p>

<h4>Physical Data Model</h4>

<p>
Various tasks were undertaken to ensure that the eventual database was a summarised reflection of the business.<br>
Once the database setup was created, <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/3. DB setup">3. DB setup</a>
the combination of procedures <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/Procedures">4. Procedures</a>
 and triggers <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/Triggers">5. Triggers</a> <br>
were used for trafficking data to it's final destination.
</p>


<h4>Testing</h4>

<p>
Manual testing of data entry into the various tables was carried out to ensure the data transportation<br>
to its final destination was accurate and successful. You can find the testing at: <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/Testing">6. Testing</a>
</p>

<h4>Database Backup</h4>

<p>
<b>Note:</b> The db backup files here are for testing only. There is no live db backups in this repo.<br>
However, the backup script, that would have been used for backing up the database is included.<br>
You can find the backup folder in <a href="https://github.com/ManunEbo/Intercars-DB/tree/master/DB%20Backup">8. DB Backup</a>
</p>

<p>
Since the project was discontinued and Intercars did not object to the publishing of<br>
this body of work to illustrate my capabilities, in additions to me owning this project,
I have decided to publish it publicly.

<b>Note:</b> This project is part 1 of the discontinued project.<br>
You can find the second part, The Graphical User Interface (GUI) built with python and kivy here <a href="https://github.com/ManunEbo/Intercars-DB-GUI">Intercars-DB-GUI</a>
<br><br>
The whole project was certainly an enjoyable experience: I learned a great deal, in a very short period of time.

</p>
