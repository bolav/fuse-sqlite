using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;

public class SQLite {

	static SQLite()
	{
		Register("FuseJSX/SQLite", CreateModule());

	}

	public static IModule CreateModule()
	{
	  return new NativeModule(
	  	new NativeFunction("open", (NativeCallback)Open),
	  	new NativeFunction("close", (NativeCallback)Close),
	  	new NativeFunction("prepare", (NativeCallback)Prepare),
	  	new NativeFunction("execute", (NativeCallback)Execute),
	  	new NativeFunction("query", (NativeCallback)Query),
	  );
	}


	static object Open(Context c, object[] args)
	{
		var filename = args[0] as string;
		var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
		return SQLiteImpl.OpenImpl(filepath);
		// return filename;
	}

	static object Close(Context c, object[] args)
	{
		var handler = args[0] as string;
		SQLiteImpl.CloseImpl(filepath);
		return null;
	}

	static object Prepare(Context c, object[] args) {
		return null;
	}

	static object Execute(Context c, object[] args) {
		var handler = args[0] as string;
		var statement = args[1] as string;
		SQLiteImpl.ExecImpl(handler, statement);
		return null;
	}

	static object Query(Context context, object[] args) {
		var handler = args[0] as string;
		var statement = args[1] as string;
		var result = SQLiteImpl.QueryImpl(handler, statement);

		int i = 0;
		var obj = context.NewObject();
		foreach (var row in result) {
			var r_obj = context.NewObject();
			foreach (var pair in row) {
				string key = pair.Key as string;
				string val = pair.Value as string;
				r_obj[key] = val;
			}
			obj[i.ToString()] = r_obj;
			i++;
		}
		return obj;
	}


	static void Register(string moduleId, IModule module)
	{
		Uno.UX.Resource.SetGlobalKey(module, moduleId);
	}


}