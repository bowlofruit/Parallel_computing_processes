import java.util.Scanner;

public class App {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter the number of threads: ");
            int numThreads = scanner.nextInt();

            System.out.print("Enter the step to calculate the amount: ");
            int step = scanner.nextInt();

            Thread[] calculatorThreads = new Thread[numThreads];
            Thread[] delayTime = new Thread[numThreads];

            for (int i = 0; i < numThreads; i++) {
                System.out.print("Enter the time (sec) of delay for " + (i + 1) + " thread: ");
                int timeDelay = scanner.nextInt();

                Breaker threadStopper = new Breaker(timeDelay);
                Calculator caltCalculator = new Calculator(i + 1, threadStopper, step);
                delayTime[i] = new Thread(() -> threadStopper.setDelay());
                calculatorThreads[i] = new Thread(() -> caltCalculator.result());
            }

            for (int i = 0; i < numThreads; i++) {
                calculatorThreads[i].start();
                delayTime[i].start();
            }
        }
    }
}

class Breaker {
    public volatile boolean IsStop = false;
    private int delayTime;

    public Breaker(int delayTime) {
        this.delayTime = delayTime;
    }

    public void setDelay() {
        try {
            Thread.sleep(delayTime * 1000);
            IsStop = true;
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class Calculator
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

    private long sum()
    {
        long sum = 0;
        while (!_breaker.IsStop)
        {
            sum += _step;
        }
        _count = sum / _step;
        return sum;
    }

    public void result() {
        System.out.println("Thread number: " + _id + " - result: " + sum() + " (counter - " + _count + ")");
    }
    
}