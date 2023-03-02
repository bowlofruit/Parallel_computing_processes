with Ada.Text_IO; use Ada.Text_IO;

procedure Main is

   input_num_threads : String(1..100);
   last_index_num_threads : Natural := input_num_threads'Length;
   value_num_threads : Integer := 5;

   input_break_time: String(1..100);
   last_index_break_time : Natural := input_break_time'Length;
   value_break_time : Duration;

   input_step: String(1..100);
   last_index_step : Natural := input_break_time'Length;
   value_step : Long_Long_Integer;

   type canStop_array is array (1.. value_num_threads) of Boolean;
   is_stop : Boolean;
   pragma Atomic(is_stop);

   task type break_thread is
      entry SetDelay(delayTime : Duration);
      entry changeState(state : Boolean);
   end break_thread;

   task type main_thread (step : Long_Long_Integer);

   task body break_thread is
      is_stop : Boolean := False;
   begin
      accept SetDelay (delayTime : in Duration) do
         delay (delayTime);
      end SetDelay;
      accept changeState (state : in Boolean) do
         is_stop := true;
      end changeState;
   end break_thread;

   task body main_thread is
      sum : Long_Long_Integer := 0;
   begin
      loop
         sum := sum + step;
         exit when is_stop;
      end loop;
      is_stop := false;
      Put_Line(sum'Img);
   end main_thread;

begin
   Put("Enter an integer value: ");
   Get_Line(input_num_threads, last_index_num_threads);
   value_num_threads := Integer'Value(input_num_threads(1..last_index_num_threads));

   Put("Enter step to calculate the sum: ");
   Get_Line(input_step, last_index_step);
   value_step := Long_Long_Integer'Value(input_step(1..last_index_step));

   declare
      type main_thread_array is array(1.. value_num_threads) of main_thread(value_step);
      type break_thread_array is array (1.. value_num_threads) of break_thread;
   begin
      declare
         break_thread: break_thread_array;
      begin
         for i in 1.. value_num_threads loop
            Put("Enter delay time for threads: ");
            Get_Line(input_break_time, last_index_break_time);
            break_thread(i).SetDelay(Duration'Value(input_break_time(1..last_index_break_time)));
         end loop;
         null;
      end;
      null;
   end;
   null;
end Main;
