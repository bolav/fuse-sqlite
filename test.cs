using System;

namespace Dela.Mono.Examples
{
   public class HelloWorld
   {
      public static void Main(string[] args)
      {
         Console.WriteLine("Hello World");
         var h = SQLiteImpl.OpenImpl("test.sqlite");
         SQLiteImpl.ExecImpl(h, "create table if not exists ids (id integer primary key)");
         SQLiteImpl.ExecImpl(h, "insert into ids values (2)");
	     var r = SQLiteImpl.QueryImpl(h, "select * from ids");
	     Console.WriteLine(r);
      }
   } 
}
