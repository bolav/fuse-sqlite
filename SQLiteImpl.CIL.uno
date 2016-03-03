using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
public extern(CIL) static class SQLiteImpl {

	[TargetSpecificImplementation]
	public static extern object OpenImpl(string filename);

	[TargetSpecificImplementation]
	public static extern void ExecImpl(string handler, string statement, string[] param);

	[TargetSpecificImplementation]
	public static extern void CloseImpl(string handler);

	[TargetSpecificImplementation]
	public static extern List<Dictionary<string,string>> QueryImpl(string handler, string statement, string[] param);


}
