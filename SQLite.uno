using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;

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
	  	new NativeFunction("prepare", (NativeCallback)Prepare),
	  	new NativeFunction("execute", (NativeCallback)Execute),
	  );
	}


	static object Open(Context c, object[] args)
	{
		var filename = args[0] as string;
		debug_log "Opening  " + filename;
		var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
		debug_log "Filepath " + filepath;
		return SQLiteImpl.OpenImpl(filepath);
		// return filename;
	}

	static object Prepare(Context c, object [] args) {
		return null;
	}

	static object Execute(Context c, object [] args) {
		var handler = args[0] as string;
		var statement = args[1] as string;
		debug_log "Executing " + statement + " on " + handler;
		SQLiteImpl.ExecImpl(handler, statement);
		return null;
	}


	static void Register(string moduleId, IModule module)
	{
		Uno.UX.Resource.SetGlobalKey(module, moduleId);
	}


}