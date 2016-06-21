Fuse SQLite bindings [![Build Status](https://travis-ci.org/bolav/fuse-sqlite.svg?branch=master)](https://travis-ci.org/bolav/fuse-sqlite) ![Fuse Version](https://fuse-version.herokuapp.com/?repo=https://github.com/bolav/fuse-sqlite)
====================

Library to use [SQLite](https://www.sqlite.org/) in [Fuse](http://www.fusetools.com/).

Status: beta

Currently supports iOS, Android and CIL (Fuse Preview)

Issues, feature request and pull request are welcomed.

## Installation

Using [fusepm](https://github.com/bolav/fusepm)

    $ fusepm install https://github.com/bolav/fuse-sqlite


## Usage:

### UX

`<SQLite ux:Global="SQLite" />`


### JS

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

API
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

### sqlite.openFromBundle

Opens a file that contains a SQLite database, possibly from the bundle

```
var db = sqlite.openFromBundle(filename);
```

And in the `unoproj`:

```
"Includes": [
  "*.uno",
  "*.uxl",
  "*.ux",
  "bundle.sqlite:Bundle"
]
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

### db.prepare

Prepares a query. Returns a prepared statement.

```
var statement = db.prepare(sql_statement);
statement.execute(var1,var2,var3);
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

### Errors:

* `Failed to load assembly . . . have caused the assembly to be sandboxed . . .`

    You need to Unblock dll's that you downloaded.

    * https://navbis.wordpress.com/2014/03/17/what-to-do-if-the-dll-assemblies-are-blocked-by-windows/
    * http://superuser.com/questions/38476/this-file-came-from-another-computer-how-can-i-unblock-all-the-files-in-a
