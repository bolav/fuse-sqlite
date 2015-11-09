using Fuse;
using Fuse.Controls;

using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
public extern(Android) static class SQLiteImpl {

	public static object OpenImpl(string filename) {
		return filename;
	}

	public static void ExecImpl(string handler, string statement) {
		return;
	}
}