using System;
using System.Data;
using System.Collections.Generic;
using Mono.Data.Sqlite;

   // http://www.mono-project.com/docs/database-access/providers/sqlite/
   // http://zetcode.com/db/sqlitecsharp/read/
   public class SQLiteImpl
   {
      static Dictionary<string,Mono.Data.Sqlite.SqliteConnection> dbs = new Dictionary<string,Mono.Data.Sqlite.SqliteConnection>();

      public static string OpenImpl(string filename)
      {
         if (dbs.ContainsKey(filename)) {
            return filename;
         }
         string connectionString = "URI=file:" + filename;
         var dbcon = new SqliteConnection(connectionString);
         dbcon.Open();
         dbs.Add(filename, dbcon);
         return filename;
      }

      public static void CloseImpl(string handler) {
         var db = dbs[handler];
         db.Close();
      }

      static string ReplaceFirst(string text, string search, string replace) {
        int pos = text.IndexOf(search);
        if (pos < 0)
        {
          return text;
        }
        return text.Substring(0, pos) + replace + text.Substring(pos + search.Length);
      }

      // Hard and ugly hack to use '?'
      static string ConvertStatment(string text) {
         var replace = "";
         var i = 1;
         while (replace != text) {
            if (replace != "") {
               text = replace;
            }
            replace = ReplaceFirst(text, "?", "@a" + i);
            i++;
         }
         return text;
      }

      public static void ExecImpl(string handler, string statement, string[] param) {
         var db = dbs[handler];
         var dbcmd = new SqliteCommand(ConvertStatment(statement), db);

         // Hard and ugly hack to use '?'
         for (var i = 1; i <= param.Length; i++) {
            dbcmd.Parameters.AddWithValue("@a" + i, param[i-1]);
         }
         dbcmd.ExecuteNonQuery();
         dbcmd.Dispose();
      }

      public static List<Dictionary<string,string>> QueryImpl(string handler, string statement, string[] param) {
      	List<Dictionary<string,string>> result = new List<Dictionary<string,string>>();
         var db = dbs[handler];
         var dbcmd = new SqliteCommand(ConvertStatment(statement), db);

         // Hard and ugly hack to use '?'
         for (var i = 1; i <= param.Length; i++) {
            dbcmd.Parameters.AddWithValue("@a" + i, param[i-1]);
         }
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
