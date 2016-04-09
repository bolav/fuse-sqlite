using System;

namespace Dela.Mono.Examples
{
   public class HelloWorld
   {
      public static void Main(string[] args)
      {
         var h = SQLiteImpl.OpenImpl("test.sqlite");
         string[] empty = new string[0];
         string[] param = {"2"};
         SQLiteImpl.ExecImpl(h, "create table if not exists ids (id integer primary key)", empty);
         SQLiteImpl.ExecImpl(h, "insert into ids values (?)", param);
         // SQLiteImpl.ExecImpl(h, "insert into ids values (?,?,?,?)", param);
	     var r = SQLiteImpl.QueryImpl(h, "select * from ids", empty);
	     Console.WriteLine(r);
      }
   } 
}
