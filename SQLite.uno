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
		var param_len = args.Length - 2;

		string[] param = new string[param_len];
		for (var i=0; i < param_len; i++) {
			param[i] = args[i+2].ToString();
		}
		SQLiteImpl.ExecImpl(handler, statement, param);
		return null;
	}

	object Query(Context context, object[] args) {
		var handler = args[0] as string;
		var statement = args[1] as string;
		var param_len = args.Length - 2;

		string[] param = new string[param_len];
		for (var j=0; j < param_len; j++) {
			param[j] = args[j+2] as string;
		}
		var result =  SQLiteImpl.QueryImpl(handler, statement, param);

		int i = 0;
		var array = (Fuse.Scripting.Array)context.Evaluate("(no file)", "new Array()");
		foreach (var row in result) {
			var r_obj = context.NewObject();
			foreach (var pair in row) {
				string key = pair.Key as string;
				string val = pair.Value as string;
				r_obj[key] = val;
			}
			array[i] = r_obj;
			i++;
		}
		return array;
	}

}