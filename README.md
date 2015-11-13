Library to use [SQLite](https://www.sqlite.org/) in [Fuse](http://www.fusetools.com/).

Status: pre-alpha (proof of concept)

Currently supports iOS, Android and CIL (Fuse Preview)

Support for JavaScript and CMake is not planned.

Usage:
```
var db = require('FuseJSX/SQLite');
var h = db.open("file.sqlite");
db.execute(h, "create table if not exists ids (id integer primary key)");
db.execute(h, "insert into ids values (2)");
var r = db.query(h, "select * from ids");
debug_log(JSON.stringify(r));
```

It returns a hash of hashes.

```
{
	"0":{"field":"value"},
	"1":{"field":"value"}
}
```

= Known Issues =

* No support for binding arguments
* No support for cursor
* No support for CMake
* Not able to use from `Project` in unoproj
* Constructor not being loaded in Fuse Preview. (Can be solved with `<SQLite ux:Global="Workaround" />` in the UX)
* No support for bundled pre-made databases

= TODO =

* Return array if given an array
* Return count as a hash element