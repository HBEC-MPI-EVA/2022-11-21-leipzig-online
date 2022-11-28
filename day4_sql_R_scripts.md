
First some practice using SQLite, by typing `sqlite3` in the terminal

```sql

-- create a table called 'Researchers'
-- the primary key for Researchers will be personID

create table Researchers(
  personID integer,
  first_name text,
  last_name text,
  primary key(personID)
  -- conditions:
  -- number of characters inside personID is exactly 3
  check(length(personID) = 3)
  check(length(first_name) < 50)
);

.tables
.schema

insert into Researchers values(121, 'Brett', 'Beheim');
insert into Researchers values(342, 'Bobby', 'Tables');

select personID from Researchers;
select last_name, personID from Researchers;
select * from Researchers;

update Researchers set first_name = 'Bret';
update Researchers set first_name = 'Bobby' where personID = 342;

insert into Researchers values(343, 'Bobby', 'Tables');
delete from Researchers where personID = 343;
-- duplicate row for Bobby

insert into Researchers values(4432, 'Cody', 'Ross');
insert into Researchers values(234, 'Codyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy', 'Ross');
insert into Researchers values(432, 'Cody', 'Ross');

-- drop table Researchers;

```

Our goal is to migrate `pointNemoReadingsFlat.csv` into a relational database by separating it into relational tables in normal form,  which we first do in R:

```R

library(dplyr)

dat <- read.csv("pointNemoReadingsFlat.csv")

# people - one row per person!

dat |>
  filter(personID != "") |>
  group_by(personID) |>
  summarize(
    family = first(family),
    personal = first(personal),
  ) -> people

# trips - one row per trip!
# properties: tripID (pk), date, siteID

dat |>
  filter(tripID != "" & !is.na(tripID)) |>
  group_by(tripID) |>
  summarize(
    date = first(date),
    siteID = first(siteID),
    num_researchers = length(unique(personID)),
    num_dates = length(unique(date)),
  )

dat |>
  filter(tripID != "" & !is.na(tripID)) |>
  group_by(tripID) |>
  summarize(
    date = first(date),
    siteID = first(siteID)
  ) -> trips


# sites - one row per sites!

dat |>
  filter(siteID != "" & !is.na(siteID)) |>
  group_by(siteID) |>
  summarize(
    lat = first(lat),
    lon = first(lon)
  ) -> sites

# readings - one row per reading!

dat |>
  mutate(readingID = 1:nrow(dat)) |>
  select(-lat, -lon, -date, -family, -personal) -> readings

write.table(people, "people.csv", row.names = FALSE, sep = ",", col.names = FALSE)
write.table(readings, "readings.csv", row.names = FALSE, sep = ",", col.names = FALSE)
write.table(trips, "trips.csv", row.names = FALSE, sep = ",", col.names = FALSE)
write.table(sites, "sites.csv", row.names = FALSE, sep = ",", col.names = FALSE)

```

With the data ready to be imported, we will initialize a new database called `pointNemoReadings.db` using the terminal command `sqlite3 pointNemoReadings.db`.

```sql

pragma foreign_keys = ON;

create table People(
  personID text,
  family text,
  personal text,
  primary key(personID)
);

-- get ready for a csv!
.mode csv

-- .import PATH+FILENAME TABLENAME
.import people.csv People

create table Sites(
  siteID text,
  lat real,
  lon real,
  primary key(siteID)
);

.import sites.csv Sites

create table Trips(
  tripID integer,
  date date,
  siteID text,
  primary key(tripID),
  foreign key(siteID) references Sites(siteID)
);

.import trips.csv Trips

create table Readings(
  tripID integer,
  personID text,
  quant text,
  reading real,
  siteID text,
  readingID integer,
  primary key(readingID),
  foreign key(tripID) references Trips(tripID),
-- foreign key(personID) references People(personID),
-- figure out who these missing entries are!
  foreign key(siteID) references Sites(siteID)
);

.import readings.csv Readings

create table VariableKey(
  variable text,
  description text
);

.import pointNemoVariableKey.csv VariableKey

.mode column
.header on
select * from People;
select * from Sites;
select * from Trips;
select * from Readings;

```

Now we will connect to `pointNemoReadings.db` using R

```R


install.packages("RSQLite")

library(RSQLite)

myCon <- dbConnect(SQLite(), "pointNemoReadings.db")
dbListTables(myCon)
dbListFields(myCon, "Readings")
dat <- dbGetQuery(myCon, "select * from Sites;")

add_site <- data.frame(
  siteID = "DX-1",
  lat = 0,
  lon = 0
)

dat <- bind_rows(dat, add_site)

dbWriteTable(myCon, "Sites", add_site, append = TRUE)

dbGetQuery(myCon, "select * from Sites;")

add_site2 <- data.frame(
  siteID = NA,
  lat = 0,
  lon = 0
)

dbWriteTable(myCon, "Sites", add_site2, append = TRUE)

```