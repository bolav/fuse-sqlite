using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using ObjC;

using Uno;
using Uno.Collections;

using Uno.Compiler.ExportTargetInterop;
using Bolav.ForeignHelpers;

// http://www.appcoda.com/sqlite-database-ios-app-tutorial/

[Require("Source.Include", "@{ForeignDict:Include}")]
[TargetSpecificImplementation]
public extern(iOS) static class SQLiteImpl {

	// TODO: Rewrite to an exception thrower, to make this modular
	public static void ThrowException (string exception) {
		throw new Fuse.Scripting.Error(exception);
	}

	[Require("Source.Include", "sqlite3.h")]
	[Require("LinkLibrary", "sqlite3")]
	[Foreign(Language.ObjC)]
	public static extern IntPtr OpenImpl(string filename)
	@{
		sqlite3 *sqlite3Database;
		BOOL openDatabaseResult = sqlite3_open([filename UTF8String], &sqlite3Database);
		return sqlite3Database;
	@}

	[Foreign(Language.ObjC)]
	public static extern void ExecImpl(IntPtr db, string statement, string[] param)
	@{
		sqlite3_stmt *compiledStatement;

        if (sqlite3_prepare_v2((sqlite3 *)db, [statement UTF8String], -1, &compiledStatement, NULL) != SQLITE_OK) {
		    NSLog(@"Prepare failure: %s", sqlite3_errmsg((sqlite3 *)db));
		    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
		}
		for (int i=0; i<param.count; i++) {
			if (sqlite3_bind_text(compiledStatement, i + 1, [param[i] UTF8String], -1, NULL) != SQLITE_OK) {
			    NSLog(@"Bind %d failure: %s", i, sqlite3_errmsg((sqlite3 *)db));
			    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
			}
		}
		if (sqlite3_step(compiledStatement) != SQLITE_DONE) {
		    NSLog(@"Step failure: %s", sqlite3_errmsg((sqlite3 *)db));
		    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
		}
		sqlite3_finalize(compiledStatement);
		return;
	@}

	[Foreign(Language.ObjC)]
	public static extern void CloseImpl(IntPtr db)
	@{
		sqlite3_close((sqlite3 *)db);
		return;
	@}

	[Foreign(Language.ObjC)]
	public static extern void QueryImpl(ForeignList result, IntPtr db, string statement, string[] param)
	@{
		sqlite3_stmt *compiledStatement;
		NSMutableArray *columnNames = [[NSMutableArray alloc] init];

		// Load all data from database to memory.
		BOOL prepareStatementResult = sqlite3_prepare_v2((sqlite3 *)db, [statement UTF8String], -1, &compiledStatement, NULL);
		if(prepareStatementResult != SQLITE_OK) {
		    NSLog(@"Prepare failure: %s", sqlite3_errmsg((sqlite3 *)db));
		    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
		}
		for (int i=0; i<param.count; i++) {
			if (sqlite3_bind_text(compiledStatement, i + 1, [param[i] UTF8String], -1, NULL) != SQLITE_OK) {
			    NSLog(@"Bind %d failure: %s", i, sqlite3_errmsg((sqlite3 *)db));
			    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
			}
		}

		int sqlite_ret;
		while((sqlite_ret = sqlite3_step(compiledStatement)) == SQLITE_ROW) {
			// Initialize the mutable array that will contain the data of a fetched row.
			id<UnoObject> row = @{ForeignList:Of(result).NewDictRow():Call()};

		    // Get the total number of columns.
		    int totalColumns = sqlite3_column_count(compiledStatement);

		    // Go through all columns and fetch each column data.
		    for (int i=0; i<totalColumns; i++){
		        // Convert the column data to text (characters).
		        char *dbDataAsChars;

		        // Keep the current column name.
		        if (columnNames.count != totalColumns) {
		            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
		            [columnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
		        }

		        dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
		        // If there are contents in the currenct column (field) then add them to the current row array.
		        if (dbDataAsChars != NULL) {
		            // Convert the characters to string.
			        @{ForeignDict:Of(row).SetKeyVal(string,string):Call([columnNames objectAtIndex:i], [NSString stringWithUTF8String:dbDataAsChars])};
		        }
		        else {
		        	@{ForeignDict:Of(row).SetKeyVal(string,string):Call([columnNames objectAtIndex:i], nil)};
		        }

		    }
		}
		if (sqlite_ret != SQLITE_DONE) {
		    NSLog(@"sqlite_ret: %d", sqlite_ret);
		    @{ThrowException(string):Call([NSString stringWithUTF8String:sqlite3_errmsg((sqlite3 *)db)])};
		}
	@}

}
