namespace Parallel_computing_processes
{
    public class Program
    {
        private static void Main(string[] args)
        {
            Console.Write("Enter the number of threads: ");
            int numThreads = int.Parse(Console.ReadLine());

            Console.Write("Enter the step to calculate the amount: ");
            int step = int.Parse(Console.ReadLine());

            new Program().StartPoint(numThreads, step);
        }

        private void StartPoint(int numThreads, int step)
        {
            Thread[] calculatorThreads = new Thread[numThreads];
            Thread[] delayTime = new Thread[numThreads];

            for (int i = 0; i < numThreads; i++)
            {
                Console.Write($"Enter the time (sec) of delay for {i + 1} thread: ");
                int timeDelay = int.Parse(Console.ReadLine());

                Breaker breaker = new(timeDelay);
                Calculator calculator = new(i + 1, breaker, step);
                delayTime[i] = new Thread(() => breaker.SetDelay());
                calculatorThreads[i] = new Thread(() => calculator.Result());
            }

            for (int i = 0; i < numThreads; i++)
            {
                calculatorThreads[i].Start();
                delayTime[i].Start();
            }
        }
    }
}