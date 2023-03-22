using System;
using System.Threading;

namespace ThreadSumSharp
{
    class Program
    {
        private const int dim = 10000000;
        private const int threadNum = 10;
        private readonly int[] arr = new int[dim];
        private readonly object lockerForSum = new object();
        private long sum = 0;

        static void Main(string[] args)
        {
            var main = new Program();
            main.InitArr();
            Console.WriteLine(main.PartSum(0, dim));
            Console.WriteLine(main.ParallelSum());
            Console.ReadKey();
        }

        private long ParallelSum()
        {
            var thread = new Thread[threadNum];
            var step = dim / thread.Length;
            for (int i = 0; i < thread.Length; i++)
            {
                int startIndex = i * step;
                int finishIndex = (i + 1) * step;
                thread[i] = new Thread(() =>
                {
                    var threadSum = PartSum(startIndex, finishIndex);
                    lock (lockerForSum)
                    {
                        sum += threadSum;
                    }
                });
                Console.WriteLine($"ID: {thread[i].ManagedThreadId} - {startIndex}");
                thread[i].Start();
            }
            foreach (var t in thread) t.Join();
            return sum;
        }

        private void InitArr()
        {
            for (int i = 0; i < dim; i++)
            {
                arr[i] = i;
            }
        }

        private long PartSum(int startIndex, int finishIndex)
        {
            long threadSum = 0;
            for (int i = startIndex; i < finishIndex; i++)
            {
                threadSum += arr[i];
            }
            return threadSum;
        }
    }
}