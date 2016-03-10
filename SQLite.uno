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
		AddMember(new NativeFunction("openFromBundle", (NativeCallback)OpenFromBundle));
	}


	object Open (Context c, object[] args)
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

	object OpenFromBundle (Context c, object[] args)
	{
		var filename = args[0] as string;
		var filepath = Path.Combine(Directory.GetUserDirectory(UserDirectory.Data), filename);
		if (File.Exists(filepath)) {
			return Open(c,args);
		}
		BundleFile found = null;
		foreach (var f in Uno.IO.Bundle.AllFiles) {
			if (f.SourcePath == filename) {
				found = f;
				break;
			}
		}
		if (found != null) {
			// http://stackoverflow.com/questions/230128/how-do-i-copy-the-contents-of-one-stream-to-another
			var input = found.OpenRead();
			var output = File.OpenWrite(filepath);
			byte[] buffer = new byte[1024];
			int read;
			while ((read = input.Read(buffer, 0, buffer.Length)) > 0)
			{
			    output.Write (buffer, 0, read);
			}
			input.Close();
			output.Close();
		}
		else {
			debug_log filename + " not found in bundle";
		}
		return Open(c,args);
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
