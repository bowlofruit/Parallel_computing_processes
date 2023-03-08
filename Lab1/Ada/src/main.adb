with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   value_num_threads : Integer := 5;

   input_step: String(1..100);
   last_index_step : Natural := input_step'Length;
   value_step : Long_Long_Integer;

   type canStop_array is array (1.. value_num_threads) of Boolean;
   type delaySetter_array is array (1.. value_num_threads) of Duration;
   is_stop_array : canStop_array := (others => False);
   pragma Atomic(is_stop_array);
   breaker_delay_set : delaySetter_array := (0.5, 1.0, 1.5, 2.0, 2.5);

   task type break_thread is
      entry SetDelay (delayTime : Duration; arrayPos : Integer);
   end break_thread;
   task type main_thread (step : Long_Long_Integer) is
      entry SetPos(arrayPos: Integer);
   end main_thread;

   task body break_thread is
   begin
      accept SetDelay (delayTime : in Duration; arrayPos : in Integer) do
         delay (delayTime);
         is_stop_array(arrayPos) := true;
      end SetDelay;
   end break_thread;

   task body main_thread is
      sum : Long_Long_Integer := 0;
      currentPos : Integer;
   begin
      accept SetPos (arrayPos : in Integer) do
         currentPos := arrayPos;
      end SetPos;
      loop
         sum := sum + step;
         exit when is_stop_array(currentPos) = True;
      end loop;
      Put_Line("Id:" & currentPos'Img & " Sum:" & sum'Img & " Step:" & step'Img
               & " Delay Time (sec):" & breaker_delay_set(currentPos)'Img);
   end main_thread;

begin
   Put("Enter step to calculate the sum: ");
   Get_Line(input_step, last_index_step);
   value_step := Long_Long_Integer'Value(input_step(1..last_index_step));

   declare
      type main_thread_array is array(1.. value_num_threads) of main_thread(value_step);
      type break_thread_array is array (1.. value_num_threads) of break_thread;
      breaker: break_thread_array;
      main_threads : main_thread_array;
   begin
      for i in breaker'Range loop
         main_threads(i).SetPos(i);
         breaker(i).SetDelay(breaker_delay_set(i), i);
      end loop;
   end;
   null;
end Main;
