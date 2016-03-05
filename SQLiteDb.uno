using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using FuseX.SQLite;

public class SQLiteDb : NativeModule
{
	string filename;
	extern (CIL) string db;
	extern (iOS) ObjC.ID db;
	extern (Android) Java.Object db;
	public SQLiteDb(string filename) {
		this.filename = filename;
		db = SQLiteImpl.OpenImpl(filename);

		AddMember(new NativeFunction("close", (NativeCallback)Close));
		AddMember(new NativeFunction("prepare", (NativeCallback)Prepare));
		AddMember(new NativeFunction("execute", (NativeCallback)Execute));
		AddMember(new NativeFunction("query", (NativeCallback)Query));
	}

	object Close(Context c, object[] args)
	{
		SQLiteImpl.CloseImpl(db);
		return null;
	}

	object Prepare(Context c, object[] args) {
		var statement = args[0] as string;
		var module = c.NewObject();
		module["id"] = "SQLiteStatement";
		module["exports"] = c.NewObject();

		var mod = new SQLiteStatement(db, statement);
		mod.Evaluate(c, module);
		return module["exports"];
	}

	object Execute(Context c, object[] args) {
		var statement = args[0] as string;
		var param_len = args.Length - 1;

		string[] param = new string[param_len];
		for (var i=0; i < param_len; i++) {
			param[i] = args[i+1].ToString();
		}
		SQLiteImpl.ExecImpl(db, statement, param);
		return null;
	}

	// TODO: QueryCursor
	// TODO: QueryAsync

	object Query(Context context, object[] args) {
		var statement = args[0] as string;
		var param_len = args.Length - 1;

		string[] param = new string[param_len];
		for (var j=0; j < param_len; j++) {
			param[j] = args[j+1] as string;
		}
		var jsld = new JSListDict(context);

		if defined(!CIL) {
			SQLiteImpl.QueryImpl(jsld, db, statement, param);
		}

		if defined(CIL) {
			var result = SQLiteImpl.QueryImpl(db, statement, param);
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
