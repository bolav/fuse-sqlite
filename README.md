Library to use SQLite in Fuse.


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


= Known Issues =

* No support for binding arguments
* No support for cursor
* No support for CMake
* Not able to use from `Project` in unoproj
* Constructor not being loaded in Fuse Preview. (Can be solved with `<SQLite ux:Global="Workaround" />` in the UX)

