using Fuse;
using Fuse.Controls;

using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Android.android.database.sqlite;

// http://developer.android.com/reference/android/database/sqlite/SQLiteDatabase.html
[TargetSpecificImplementation]
public extern(Android) static class SQLiteImpl {

	static Dictionary<string,SQLiteDatabase> dbs = new Dictionary<string,SQLiteDatabase>();

	public static object OpenImpl(string filename) {
		var db = SQLiteDatabase.openOrCreateDatabase(filename, null);
		debug_log "Created " + filename;
		debug_log db;
		dbs.Add(filename, db);
		return filename;
	}

	public static void ExecImpl(string handler, string statement) {
		var db = dbs[handler];
		db.execSQL(statement);
		return;
	}

	public static List<Dictionary<string,string>> QueryImpl(string handler, string statement) {
		var db = dbs[handler];
		var cu = db.rawQuery(statement, null);
		var result = new List<Dictionary<string,string>>();
		cu.moveToFirst();
		while (!cu.isAfterLast()) {
			var row_dict = new Dictionary<string,string>();
			for (var i=0; i<cu.getColumnCount(); i++) {
				row_dict.Add(cu.getColumnName(i), cu.getString(i));
			}
			result.Add(row_dict);
			cu.moveToNext();
		}
		return result;
	}
}
