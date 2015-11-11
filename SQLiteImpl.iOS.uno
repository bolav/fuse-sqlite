using Fuse;
using Fuse.Controls;
using Fuse.Scripting;
using Fuse.Reactive;
using ObjC;

using Uno;
using Uno.Collections;

using Uno.Compiler.ExportTargetInterop;
using iOS.Foundation;
// http://www.appcoda.com/sqlite-database-ios-app-tutorial/

[TargetSpecificImplementation]
public extern(iOS) static class SQLiteImpl {

	static Dictionary<string,ObjC.ID> dbs = new Dictionary<string,ObjC.ID>();

	[TargetSpecificImplementation]
	public static extern ObjC.ID OpenImplNative(string filename);

	public static object OpenImpl(string filename) {
		var db = OpenImplNative(filename);
		dbs.Add(filename, db);
		return filename;
	}

	[TargetSpecificImplementation]
	public static extern void ExecImplNative(ObjC.ID db, string statement);

	public static void ExecImpl(string handler, string statement) {
		var db = dbs[handler];
		ExecImplNative(db, statement);
	}

	[TargetSpecificImplementation]
	public static extern void CloseImplNative(ObjC.ID db);
	[TargetSpecificImplementation]
	public static extern iOS.Foundation.NSMutableArray QueryImplNative(ObjC.ID db, string statement);

	/*
	public static  object QueryImpl(Context c, string handler, string statement) {
		var db = dbs[handler];
		var r = QueryImplNative(db, statement);
		List<Dictionary<string,string>> result = new List<Dictionary<string,string>>();
		for (var i=0; i<r.count; i++) {
			var row_id = r.objectAtIndex(i);
			var row = new NSMutableDictionary(row_id);
			var keys = row.Allkeys
		}

		return result;
	}
	*/

	public static List<Dictionary<string,string>> QueryImpl(string handler, string statement) {
		var db = dbs[handler];
		var r = QueryImplNative(db, statement);
		List<Dictionary<string,string>> result = new List<Dictionary<string,string>>();
		for (var i=0; i<r.count(); i++) {
			var row_dict = new Dictionary<string,string>();
			var row_id = r.objectAtIndex(i);
			var row = new NSMutableDictionary(row_id);
			var keys = row.allKeys();
			for (var ii=0; ii<keys.count(); ii++) {
				var key = keys.objectAtIndex(ii);
				var val = row.objectForKey(key);
				row_dict.Add(new NSString(key).stringByAppendingString(""), new NSString(val).stringByAppendingString(""));
			}
			result.Add(row_dict);
		}

		return result;
	}
}
