using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;
using FuseX.SQLite;

// Version: 0.03
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
		// TODO: return dbobject, instead of handle
		//var module = new SQLiteDb(filepath);
		//return module.Evaluate("SQLiteDb", c);
		return SQLiteImpl.OpenImpl(filepath);
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
		var jsld = new JSListDict(context);

		if defined(!CIL) {
			SQLiteImpl.QueryImpl(jsld, handler, statement, param);
		}

		if defined(CIL) {
			var result =  SQLiteImpl.QueryImpl(handler, statement, param);
			int i = 0;
			foreach (var row in result) {
				jsld.NewRowSetActive();
				foreach (var pair in row) {
					string key = pair.Key as string;
					string val = pair.Value as string;
					jsld.SetRow_Column(key,val);
				}
				i++;
			}
		}
		return jsld.GetScriptingArray();
	}

}

namespace FuseX.SQLite {
	public class JSListDict : ListDict {
		Context ctx;
		Fuse.Scripting.Array array;
		Fuse.Scripting.Object cur_row;
		int pos = 0;

		public JSListDict (Context c) {
			ctx = c;
			array = (Fuse.Scripting.Array)ctx.Evaluate("(no file)", "new Array()");
		}
		public override void NewRowSetActive () {
			cur_row = ctx.NewObject();
			array[pos] = cur_row;
			pos++;
		}
		public override void SetRow_Column (string key, string val) {
			cur_row[key] = val;
		}
		public Fuse.Scripting.Array GetScriptingArray () {
			return array;
		}
	}

	public abstract class ListDict {
		public abstract void NewRowSetActive();
		public abstract void SetRow_Column(string key, string val);
	}
}
