using Bolav.ForeignHelpers;
using Uno.Compiler.ExportTargetInterop;
// http://www.appcoda.com/sqlite-database-ios-app-tutorial/

[TargetSpecificImplementation]
public extern(Uno) static class SQLiteImpl {

	public static int OpenImpl(string filename) {
		return 0;
	}
	public static void CloseImpl(int db) {

	}

	public static void ExecImpl(int db, string statement, string[] param)
	{

	}

	public static void QueryImpl(ForeignList result, int db, string statement, string[] param)
	{}
}
