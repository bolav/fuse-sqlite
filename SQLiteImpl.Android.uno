using Fuse;
using Fuse.Controls;

using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Android.android.database.sqlite;

// http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html
[TargetSpecificImplementation]
public extern(Android) static class SQLiteImpl {

	static Dictionary<string,Java.Object> dbs = new Dictionary<string,Java.Object>();

    [Foreign(Language.Java)]
	public static extern Java.Object OpenImplNative(string filename)
	@{
		return android.database.sqlite.SQLiteDatabase.openOrCreateDatabase(filename, null);
	@}

	public static object OpenImpl(string filename) {
		if (dbs.ContainsKey(filename)) {
		   return filename;
		}
		var db = OpenImplNative(filename);
		debug_log "Created " + filename;
		dbs.Add(filename, db);
		return filename;
	}


    [Foreign(Language.Java)]
	public static extern void ExecImplNative(Java.Object db, string statement, string[] param)
	@{
		((android.database.sqlite.SQLiteDatabase)db).execSQL(statement, param.copyArray());
	@}

	public static void ExecImpl(string handler, string statement, string[] param) {
		var db = dbs[handler];
		ExecImplNative(db, statement, param);
		return;
	}

    [Foreign(Language.Java)]
	public static extern void CloseImplNative(Java.Object db)
	@{
		((android.database.sqlite.SQLiteDatabase)db).close();
	@}

	public static void CloseImpl(string handler) {
		var db = dbs[handler];
		CloseImplNative(db);
		return;
	}

	public static void _AddRowToResult (List<Dictionary<string,string>> reslist, Dictionary<string,string> row) {
		reslist.Add(row);
	}

	public static Dictionary<string,string> _NewRow () {
		return new Dictionary<string,string>();
	}

	public static void _SetColumn(Dictionary<string,string> row, string key, string val) {
		row.Add(key, val);
	}

    [Foreign(Language.Java)]
	public static extern void QueryImplNative(List<Dictionary<string,string>> result, Java.Object db, string statement, string[] param)
	@{
		android.database.Cursor curs = ((android.database.sqlite.SQLiteDatabase)db).rawQuery(statement, param.copyArray());
		curs.moveToFirst();
		while (!curs.isAfterLast()) {
			Object row = @{_NewRow():Call()};
			for (int i=0; i<curs.getColumnCount(); i++) {
				@{_SetColumn(Dictionary<string,string>, string, string):Call(row, curs.getColumnName(i), cu.getString(i))};
			}
		    @{_AddRowToResult(List<Dictionary<string,string>>, Dictionary<string,string>):Call(result, row)};
		    cu.moveToNext();
		}
	@}

	public static List<Dictionary<string,string>> QueryImpl(string handler, string statement, string[] param) {
		var db = dbs[handler];

		var result = new List<Dictionary<string,string>>();
		QueryImplNative(result, db, statement, param);
		/* var cu = db.rawQuery(statement, list);
		cu.moveToFirst();
		while (!cu.isAfterLast()) {
			var row_dict = new Dictionary<string,string>();
			for (var i=0; i<cu.getColumnCount(); i++) {
				row_dict.Add(cu.getColumnName(i), cu.getString(i));
			}
			result.Add(row_dict);
			cu.moveToNext();
		} */
		return result;
	}
}
