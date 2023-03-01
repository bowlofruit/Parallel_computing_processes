namespace Parallel_computing_processes
{
    public class Program
    {
        private static void Main(string[] args)
        {
            Console.Write("Enter the number of threads: ");
            int numThreads = int.Parse(Console.ReadLine());

            new Program().StartPoint(numThreads);
        }

        private void StartPoint(int numThreads)
        {
            Thread[] calculatorThreads = new Thread[numThreads];
            Thread[] delayTime = new Thread[numThreads];

            for (int i = 0; i < numThreads; i++)
            {
                Console.Write($"Enter the time (sec) of delay for thread: ");
                int timeDelay = int.Parse(Console.ReadLine());

                Breaker breaker = new(timeDelay);
                delayTime[i] = new Thread(() => breaker.SetDelay());
                calculatorThreads[i] = new Thread(() => Sum(breaker));
            }

            for (int i = 0; i < numThreads; i++)
            {
                calculatorThreads[i].Start();
                delayTime[i].Start();
            }
        }

        private void Sum(object obj)
        {
            Breaker breaker = (Breaker)obj;
            long sum = 0;
            while(!breaker.Stop) 
            {
                sum++;
            }
            Console.WriteLine($"Id: {Environment.CurrentManagedThreadId} -  result: {sum}");
        }
    }
}