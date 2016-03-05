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
	}


	object Open(Context c, object[] args)
	{
		var filename = args[0] as string;
		var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
		// TODO: return dbobject, instead of handle

		var module = c.NewObject();
		module["id"] = "SQLiteDb";
		module["exports"] = c.NewObject();

		var db = new SQLiteDb(filepath);
		db.Evaluate(c, module);
		return module["exports"];
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
