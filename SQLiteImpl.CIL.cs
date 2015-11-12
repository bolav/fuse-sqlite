using System;
using System.Data;
using System.Collections.Generic;
using Mono.Data.Sqlite;

   // http://www.mono-project.com/docs/database-access/providers/sqlite/
   public class SQLiteImpl
   {
      static Dictionary<string,IDbConnection> dbs = new Dictionary<string,IDbConnection>();

      public static string OpenImpl(string filename)
      {
         Console.WriteLine("Hello World");
         Console.WriteLine(filename);
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
               string val = "";
               var ftype = reader.GetFieldType(i);
               if (ftype == typeof(System.Int64)) {
                  var f = reader.GetInt64(i);
                  val = f.ToString();
               }
               else {
                  Console.WriteLine("Unknown type " + ftype);
               }
               row.Add(reader.GetName(i),val);
            }
            result.Add(row);
         }
         reader.Dispose();
         dbcmd.Dispose();

      	return result;
      }

   } 
