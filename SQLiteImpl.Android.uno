using Fuse;
using Fuse.Controls;

using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Android.android.database.sqlite;

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
}
