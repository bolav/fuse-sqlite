using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;

public class SQLiteDb : NativeModule
{
	extern (iOS) ObjC.ID db;
	extern (Android) Java.Object db;
	public SQLiteDb(string filename) {

	}
}
