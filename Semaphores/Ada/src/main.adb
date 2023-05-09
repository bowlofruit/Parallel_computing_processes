with Ada.Text_IO, Ada.Containers.Indefinite_Doubly_Linked_Lists, GNAT.Semaphores;
use Ada.Text_IO, Ada.Containers, GNAT.Semaphores;

procedure Main is

   package String_Lists is new Indefinite_Doubly_Linked_Lists (String);
   use String_Lists;

   StorageSize : Integer := 4;
   WorkTarget : Integer := 10;
   ProducersCount : Integer := 4;
   ConsumersCount : Integer := 6;

   Storage : List;
   Access_Storage : Counting_Semaphore (1, Default_Ceiling);
   Full_Storage   : Counting_Semaphore (StorageSize, Default_Ceiling);
   Empty_Storage  : Counting_Semaphore (0, Default_Ceiling);

   ProducersWorkDone : Integer := 0;
   Access_ProducersWorkDone : Counting_Semaphore (1, Default_Ceiling);
   ConsumersWorkDone : Integer := 0;
   Access_ConsumersWorkDone : Counting_Semaphore (1, Default_Ceiling);

   task type ProducerTask;
   task body ProducerTask is
      ProducerName : String := "Producer";
   begin
      while ProducersWorkDone < WorkTarget loop
         Access_ProducersWorkDone.Seize;
         if ProducersWorkDone < WorkTarget then
            Full_Storage.Seize;
            delay 0.25;
            Access_Storage.Seize;

            ProducersWorkDone := ProducersWorkDone + 1;
            Storage.Append ("item " & ProducersWorkDone'Img);
            Put_Line (ProducerName & " added item " & ProducersWorkDone'Img);

            Access_Storage.Release;
            Empty_Storage.Release;
         end if;
         Access_ProducersWorkDone.Release;
      end loop;
   end ProducerTask;

   task type ConsumerTask;
   task body ConsumerTask is
      ConsumerName : String := "Consumer";
   begin
      while ConsumersWorkDone < WorkTarget loop
         Access_ConsumersWorkDone.Seize;
         if ConsumersWorkDone < WorkTarget then
            Empty_Storage.Seize;
            delay 0.25;
            Access_Storage.Seize;

            ConsumersWorkDone := ConsumersWorkDone + 1;
            declare
               item : String := First_Element (Storage);
            begin
               Put_Line (ConsumerName & " took " & item);
            end;
            Storage.Delete_First;

            Access_Storage.Release;
            Full_Storage.Release;
         end if;
         Access_ConsumersWorkDone.Release;
      end loop;
   end ConsumerTask;

   Consumers : array (1..ConsumersCount) of ConsumerTask;
   Producers : array (1..ProducersCount) of ProducerTask;

begin
   null;
end Main;
