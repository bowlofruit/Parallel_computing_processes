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
   is_stop_array : canStop_array := (others => False);
   pragma Atomic(is_stop_array);

   task type break_thread is
      entry SetDelay(delayTime : Duration);
      entry ChangeState(number : Integer);
   end break_thread;

   task type main_thread (step : Long_Long_Integer) is
      entry SetNumber (number: Integer);
      end main_thread;

   task body break_thread is
   begin
      accept SetDelay (delayTime : in Duration) do
         delay (delayTime);
      end SetDelay;
      accept ChangeState (number : in Integer) do
         is_stop_array(number) := true;
      end ChangeState;

   end break_thread;

   task body main_thread is
      i : Integer;
      sum : Long_Long_Integer := 0;
   begin
      accept SetNumber (number : in Integer) do
         i := number;
      end SetNumber;
         loop
         sum := sum + step;
         exit when is_stop_array(i);
      end loop;
      Put_Line(sum'Img);

   end main_thread;

begin
   Put("Enter the count of thread: ");
   Get_Line(input_num_threads, last_index_num_threads);
   value_num_threads := Integer'Value(input_num_threads(1..last_index_num_threads));

   Put("Enter step to calculate the sum: ");
   Get_Line(input_step, last_index_step);
   value_step := Long_Long_Integer'Value(input_step(1..last_index_step));

   Put("Enter delay for thread: ");
   Get_Line(input_break_time, last_index_break_time);
   value_break_time := Duration'Value(input_break_time(1..last_index_break_time));

   declare
      type main_thread_array is array(1.. value_num_threads) of main_thread(value_step);
      type break_thread_array is array (1.. value_num_threads) of break_thread;
   begin

      declare
         breaker: break_thread_array;
         thread_array: main_thread_array;
      begin
         for i in breaker'Range loop
            breaker(i).SetDelay(value_break_time);
            end loop;

            for i in thread_array'Range loop
               thread_array(i).SetNumber(i);
               end loop;
         null;
      end;
      null;
   end;
   null;
end Main;
