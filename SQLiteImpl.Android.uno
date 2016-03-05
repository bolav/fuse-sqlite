using Fuse;
using Fuse.Controls;

using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Android.android.database.sqlite;

// http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html
[TargetSpecificImplementation]
public extern(Android) static class SQLiteImpl {

	[Foreign(Language.Java)]
	public static extern Java.Object OpenImpl(string filename)
	@{
		return android.database.sqlite.SQLiteDatabase.openOrCreateDatabase(filename, null);
	@}

	[Foreign(Language.Java)]
	public static extern void ExecImpl(Java.Object db, string statement, string[] param)
	@{
		((android.database.sqlite.SQLiteDatabase)db).execSQL(statement, param.copyArray());
	@}

	[Foreign(Language.Java)]
	public static extern void CloseImpl(Java.Object db)
	@{
		((android.database.sqlite.SQLiteDatabase)db).close();
	@}

	[Foreign(Language.Java)]
	public static extern void QueryImpl(FuseX.SQLite.JSListDict ld, Java.Object db, string statement, string[] param)
	@{
		android.database.Cursor curs = ((android.database.sqlite.SQLiteDatabase)db).rawQuery(statement, param.copyArray());
		curs.moveToFirst();
		while (!curs.isAfterLast()) {
			@{FuseX.SQLite.JSListDict:Of(ld).NewRowSetActive():Call()};
			for (int i=0; i<curs.getColumnCount(); i++) {
				@{FuseX.SQLite.JSListDict:Of(ld).SetRow_Column(string,string):Call(curs.getColumnName(i), curs.getString(i))};
			}
		    curs.moveToNext();
		}
	@}
}
