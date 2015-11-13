using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;

// Version: 0.02
// https://github.com/bolav/fuse-sqlite

public class SQLite : NativeModule {

	public SQLite()
	{
		AddMember(new NativeFunction("open", (NativeCallback)Open));
	  	AddMember(new NativeFunction("close", (NativeCallback)Close));
	  	AddMember(new NativeFunction("prepare", (NativeCallback)Prepare));
	  	AddMember(new NativeFunction("execute", (NativeCallback)Execute));
	  	AddMember(new NativeFunction("query", (NativeCallback)Query));
	}


	object Open(Context c, object[] args)
	{
		var filename = args[0] as string;
		var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
		return SQLiteImpl.OpenImpl(filepath);
		// return filename;
	}

	object Close(Context c, object[] args)
	{
		var handler = args[0] as string;
		SQLiteImpl.CloseImpl(handler);
		return null;
	}

	object Prepare(Context c, object[] args) {
		return null;
	}

	object Execute(Context c, object[] args) {
		var handler = args[0] as string;
		var statement = args[1] as string;
		SQLiteImpl.ExecImpl(handler, statement);
		return null;
	}

	object Query(Context context, object[] args) {
		var ai = 0;
		var handler = args[ai++] as string;
		var array = args[ai] as Fuse.Scripting.Array;
		if (array != null) {
			ai++;
		}
		var statement = args[ai] as string;
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
			if (array != null) {
				array[i] = r_obj;
			}
			else {
				obj[i.ToString()] = r_obj;
			}
			i++;
		}
		if (array != null) {
			return array;
		}
		obj["count"] = result.Count;
		return obj;
	}

}