namespace Parallel_computing_processes
{
    public class Calculator
    {
        private int _id;
        private Breaker _breaker;
        private int _step;
        private long _count;

        public Calculator(int id, Breaker breaker, int step)
        {
            _id = id;
            _breaker = breaker;
            _step = step;
        }

        private long Sum()
        {
            long sum = 0;
            while (!_breaker.Stop)
            {
                sum += _step;
            }
            _count = sum / _step;
            return sum;
        }

        public void Result()
        {
            Console.WriteLine($"Thread number: {_id} -  result: {Sum()} (counter - {_count})");
        }
    }
}
