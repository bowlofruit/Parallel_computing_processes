using System.Diagnostics;

class Program
{
    private const int dim = 999999999;
    private int threadNum = 20;
    private int[] arr = new int[dim];
    private object lockerForSum = new();
    private long sum = 0;

    static void Main(string[] args)
    {
        var main = new Program();
        main.InitArr();

        Stopwatch oneThread = new();
        Stopwatch manyThreads = new();

        oneThread.Start();
        long mainResult = main.PartSum(0, dim);
        oneThread.Stop();

        manyThreads.Start();
        long threadResult = main.ParallelSum();
        manyThreads.Stop();

        Console.WriteLine($"Result: {mainResult} | Time: {oneThread.ElapsedMilliseconds} mc \nResult: {threadResult} | Time: {manyThreads.ElapsedMilliseconds} mc");
    }

    private long ParallelSum()
    {
        var thread = new Thread[threadNum];
        long step = dim / thread.Length;
        for (int i = 0; i < thread.Length; i++)
        {
            var startIndex = i * step;
            var finishIndex = (i + 1) * step;
            if(dim - finishIndex < step)
            {
                finishIndex = dim;
            }
            thread[i] = new Thread(() =>
            {
                var threadSum = PartSum(startIndex, finishIndex);
                lock (lockerForSum)
                {
                    sum += threadSum;
                }
            });
            Console.WriteLine($"ID: {thread[i].ManagedThreadId} - {startIndex}:{finishIndex}");
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

    private long PartSum(long startIndex, long finishIndex)
    {
        long threadSum = 0;
        for (var i = startIndex; i < finishIndex; i++)
        {
            threadSum += arr[i];
        }
        return threadSum;
    }
}