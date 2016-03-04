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
var db = require('SQLite');
var h = db.open("file.sqlite");
db.execute(h, "create table if not exists ids (id integer primary key)");
db.execute(h, "insert into ids values (?)",2);
var r = db.query(h, "select * from ids");
debug_log(JSON.stringify(r));
```

It returns an array:
```
[
	{"field1":"value1","field2":"value2"},
	{"field1":"value1","field2":"value2"}
]
```

### Known Issues

* No support for cursor
* No support for CMake
* No support for bundled pre-made databases
* Error handling is unsupported, and different between the targets
* Support for JavaScript and CMake Fuse targets is not planned.

### Windows

* The sqlite3.dll is downloaded from http://www.sqlite.org/download.html
* Mono.Data.Sqlite.dll is included from Mono.
