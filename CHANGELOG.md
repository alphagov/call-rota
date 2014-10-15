## 0.0.2

This adds a bin script to run call_rota from the command line.

This parses people and production_access CSV files and writes to a specified output file.

## 0.0.1

This adds a PeopleCollectionFactory responsible for taking in two hashes containing available information about people -- their basic information (including job role), and whether or not they have production access.

Allow generation of the rota for one week using RotaWeekBuilder, which returns a RotaWeek collection, which conforms to the following rules:

* No more than 1 person from the same team
* At least 1 person with production access (that isn't web operations)
* Has 2 developers and 1 web operations person on it
