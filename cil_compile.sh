# mcs -lib:. -target:library SQLiteImpl.CIL.cs
# mv SQLiteImpl.CIL.exe SQLiteImpl.CIL.dll
# mcs -r:System.Data -target:library -r:System.Data.SQLite.dll SQLiteImpl.CIL.cs
mcs -r:System.Data -target:library -r:Mono.Data.Sqlite.dll SQLiteImpl.CIL.cs
# mcs -r:SQLiteImpl.CIL.dll test.cs
