with Ada.Text_IO; use Ada.Text_IO;
procedure Sync is

   dim : constant Integer := 100000;
   thread_num : constant Integer := 4;
   min, min_index : Integer;

   arr : array(1..dim) of Integer;

   procedure Init_Arr is
   begin
      for i in 1..dim loop
         arr(i) := i;
      end loop;
      arr(4) := -23;
   end Init_Arr;

   procedure part_min(start_index, finish_index : in Integer;
                      min, min_index : out Integer) is
   begin
      min := arr(start_index);
      min_index := start_index;
      for i in start_index..finish_index loop
         if (min > arr(i)) then
            min := arr(i);
            min_index := i;
         end if;
      end loop;
   end part_min;

   protected part_manager is
      procedure set_part_min(min, min_index : in Integer);
      entry get_min(min, min_index : out Integer);
   private
      tasks_count : Integer := 0;
      min : Integer := arr(1);
      min_index : Integer := 1;
   end part_manager;

   protected body part_manager is
      procedure set_part_min(min, min_index : in Integer) is
      begin
         if (min < part_manager.min) then
            part_manager.min := min;
            part_manager.min_index := min_index;
         end if;
         tasks_count := tasks_count + 1;
      end set_part_min;

      entry get_min(min, min_index : out Integer) when tasks_count = thread_num is
      begin
         min := part_manager.min;
         min_index := part_manager.min_index;
      end get_min;

   end part_manager;

   task type starter_thread is
      entry start(start_index, finish_index : in Integer);
   end starter_thread;

   task body starter_thread is
      min : Integer;
      min_index : Integer;
      start_index, finish_index : Integer;
   begin
      accept start(start_index, finish_index : in Integer) do
         starter_thread.start_index := start_index;
         starter_thread.finish_index := finish_index;
      end start;

      part_min(start_index  => start_index,
               finish_index => finish_index,
               min => min,
               min_index => min_index);

      part_manager.set_part_min(min, min_index);
   end starter_thread;

   thread : array (1 .. thread_num) of starter_thread;

   procedure parallel_min(min, min_index : out Integer) is
      start_index : Integer;
      end_index : Integer;
   begin
      for i in 1..thread_num loop
         start_index := (i - 1) * dim / thread_num + 1;
         end_index := i * dim / thread_num;
         thread(i).start((i - 1) * dim / thread_num + 1, i * dim / thread_num);
         Put_Line("Thread ID:" & i'Img & " -" & start_index'Img);
      end loop;
      part_manager.get_min(min, min_index);
   end parallel_min;
begin
   Init_Arr;

   part_min(1, dim, min, min_index);
   Put_Line(min'img);

   parallel_min(min, min_index);
   Put_Line(min'img);
end Sync;
