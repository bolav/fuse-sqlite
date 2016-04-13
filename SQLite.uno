using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Uno.IO;
using Bolav.ForeignHelpers;

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

		var db = new SQLiteDb(filepath);
		return db.EvaluateExports(c, null);
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

