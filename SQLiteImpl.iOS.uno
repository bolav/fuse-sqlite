using Fuse;
using Fuse.Controls;
using Fuse.Scripting;
using Fuse.Reactive;
using ObjC;

using Uno;
using Uno.Collections;

using Uno.Compiler.ExportTargetInterop;
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

	public static void QueryImpl(string handler, string statement) {
		var db = dbs[handler];
		var r = QueryImplNative(db, statement);
	}
}