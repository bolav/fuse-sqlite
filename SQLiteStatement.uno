using Uno;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using FuseX.SQLite;

public class SQLiteStatement : NativeModule
{
	string statement;

	public SQLiteStatement(string statement) {
		this.statement = statement;
		AddMember(new NativeFunction("execute", (NativeCallback)Execute));
	}

	extern (CIL) string db;
	extern (iOS) ObjC.ID db;
	extern (Android) Java.Object db;

	public extern(CIL) SQLiteStatement(string database, string statement) : this(statement) {
		db = database;
	}

	public extern(iOS) SQLiteStatement(ObjC.ID database, string statement) : this(statement) {
		db = database;
	}

	public extern(Android) SQLiteStatement(Java.Object database, string statement) : this(statement) {
		db = database;
	}


	// TODO: This is just a query now, and not prepared
	object Execute(Context context, object[] args) {
		var param_len = args.Length;

		string[] param = new string[param_len];
		for (var j=0; j < param_len; j++) {
			param[j] = args[j] as string;
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
