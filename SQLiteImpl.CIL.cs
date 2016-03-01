using System;
using System.Data;
using System.Collections.Generic;
using Mono.Data.Sqlite;

   // http://www.mono-project.com/docs/database-access/providers/sqlite/
   // http://zetcode.com/db/sqlitecsharp/read/
   public class SQLiteImpl
   {
      static Dictionary<string,IDbConnection> dbs = new Dictionary<string,IDbConnection>();

      public static string OpenImpl(string filename)
      {
         Console.WriteLine(filename);
         if (dbs.ContainsKey(filename)) {
            return filename;
         }
         string connectionString = "URI=file:" + filename;
         IDbConnection dbcon = new SqliteConnection(connectionString);
         dbcon.Open();
         dbs.Add(filename, dbcon);
         return filename;
      }

      public static void CloseImpl(string handler) {
         var db = dbs[handler];
         db.Close();
      }

      public static void ExecImpl(string handler, string statement) {
         Console.WriteLine("ExecImpl " + statement);
         var db = dbs[handler];
         var dbcmd = db.CreateCommand();
         dbcmd.CommandText = statement;
         dbcmd.ExecuteNonQuery();
         dbcmd.Dispose();
      }

      public static List<Dictionary<string,string>> QueryImpl(string handler, string statement) {
      	List<Dictionary<string,string>> result = new List<Dictionary<string,string>>();
         Console.WriteLine("QueryImpl " + statement);
         var db = dbs[handler];
         IDbCommand dbcmd = db.CreateCommand();
         dbcmd.CommandText = statement;
         IDataReader reader = dbcmd.ExecuteReader();
         while(reader.Read())
         {
            Dictionary<string,string> row = new Dictionary<string,string>();
            for (var i = 0; i < reader.FieldCount; i++) {
               string val = reader.GetValue(i).ToString();
               row.Add(reader.GetName(i),val);
            }
            result.Add(row);
         }
         reader.Dispose();
         dbcmd.Dispose();

      	return result;
      }

   } 
