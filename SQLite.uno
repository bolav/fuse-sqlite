using Fuse;
using Fuse.Controls;
using Fuse.Scripting;
using Fuse.Reactive;

using Uno;
using Uno.Compiler.ExportTargetInterop;

public class SQLite {

	static SQLite()
	{
		debug_log "static ctor";
		Register("FuseJSX/SQLite", CreateModule());

	}

	public static IModule CreateModule()
	{
	  return new NativeModule(
	  	new NativeFunction("open", (NativeCallback)Open),
	  );
	}

	static object Open(Context c, object[] args)
	{
		var filename = args[0] as string;
		return SQLiteImpl.OpenImpl(filename);
		// var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
	}

	static void Register(string moduleId, IModule module)
	{
		Uno.UX.Resource.SetGlobalKey(module, moduleId);
	}


}