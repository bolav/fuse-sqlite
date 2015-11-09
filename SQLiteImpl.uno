using Fuse;
using Fuse.Controls;
using Fuse.Scripting;
using Fuse.Reactive;

using Uno;
using Uno.Compiler.ExportTargetInterop;

[TargetSpecificImplementation]
public static class SQLiteImpl {

	[TargetSpecificImplementation]
	public static extern object OpenImpl(string filename);

}