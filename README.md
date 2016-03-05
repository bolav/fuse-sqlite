Fuse SQLite bindings
====================

Library to use [SQLite](https://www.sqlite.org/) in [Fuse](http://www.fusetools.com/).

Status: beta

Currently supports iOS, Android and CIL (Fuse Preview)

Issues, feature request and pull request are welcomed.

### Usage:
In UX:

`<SQLite ux:Global="SQLite" />`

In JS:
```
var sqlite = require('SQLite');
var db = sqlite.open("file.sqlite");
db.execute("create table if not exists ids (id integer primary key)");
db.execute("insert into ids values (?)",2);
var r = db.query("select * from ids");
debug_log(JSON.stringify(r));
```

It returns an array:
```
[
	{"field1":"value1","field2":"value2"},
	{"field1":"value1","field2":"value2"}
]
```

API:
----

### require

```
var sqlite = require('SQLite');
```

### sqlite.open

Opens a file that contains a SQLite database

```
var db = sqlite.open(filename);
```

### db.execute

Executes a query. Does not return anything.

```
db.execute(sql_statement);
db.execute(sql_statement, var1, var2, var3);
```

### db.query

Executes a query. Returns an array of hashes with the result.

```
var result = db.query(sql_statement);
var result = db.query(sql_statement, var1, var2, var3);
```

### db.close

Closes the database.

```
db.close();
```

### Possible future functionality

* Cursor support
* Async support
* Bundled pre-made databases

### Known Issues

* Error messages is a bit different between the targets
* Support for JavaScript and CMake Fuse targets is not planned.

### Windows

* The sqlite3.dll is downloaded from http://www.sqlite.org/download.html
* Mono.Data.Sqlite.dll is included from Mono.
