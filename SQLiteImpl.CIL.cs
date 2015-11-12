using System;
using System.Data;
using System.Collections.Generic;
using System.Data.SQLite;
// using Mono.Data.SqliteClient;

   public class SQLiteImpl
   {
      public static string OpenImpl(string filename)
      {
         Console.WriteLine("Hello World");
         Console.WriteLine(filename);
         SQLiteConnection.CreateFile(filename);
         // var db = new SQLiteConnection("Data Source="+ filename +";Version=3;");
         // db.Open();
         return filename;
      }

      public static void CloseImpl(string handler) {
      }

      public static void ExecImpl(string handler, string statement) {
      }

      public static List<Dictionary<string,string>> QueryImpl(string handler, string statement) {
      	List<Dictionary<string,string>> result = new List<Dictionary<string,string>>();
      	return result;
      }

   } 
