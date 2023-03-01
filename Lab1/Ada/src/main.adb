with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   input_num_threads : String(1..100);
   last_index_num_threads : Natural := input_num_threads'Length;
   value_num_threads : Integer;

   input_break_time: String(1..100);
   last_index_break_time : Natural := input_break_time'Length;
   value_break_time : array(1.. value_num_threads) of Duration;
   count : Integer := 1;

   can_stop : boolean := false;
   pragma Atomic(can_stop);


   task type break_thread is
      entry SetDelay(delayTime : Duration);
   end break_thread;

   task type main_thread;

   task body break_thread is
   begin
      accept SetDelay (delayTime : in Duration) do
         delay (delayTime);
      end SetDelay;
      can_stop := true;
   end break_thread;

   task body main_thread is
      sum : Long_Long_Integer := 0;
   begin
      loop
         sum := sum + 1;
         exit when can_stop;
      end loop;
      delay 1.0;

      Put_Line(sum'Img);
   end main_thread;

begin
   Put("Enter an integer value: ");
   Get_Line(input_num_threads, last_index_num_threads);
   value_num_threads := Integer'Value(input_num_threads(1..last_index_num_threads));
   Get_Line(input_break_time, last_index_break_time);
   declare
      type main_thread_array is array(1.. value_num_threads) of main_thread;
   begin
      for i in value_break_time loop
         Put("Enter break time: ");
         Get_Line(input_break_time, last_index_break_time);
         value_break_time(i) := Duration'Value(input_break_time(1..last_index_break_time));
      end loop;
      declare
         breaker: break_thread;
         threads: main_thread_array;
         begin
         null;
         end;
   end;
   null;
end Main;
