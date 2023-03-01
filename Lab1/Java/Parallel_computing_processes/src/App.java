import java.util.Scanner;

public class App {
    public static void main(String[] args) {
        try (Scanner scanner = new Scanner(System.in)) {
            System.out.print("Enter the number of threads: ");
            int numThreads = scanner.nextInt();

            Thread[] calculatorThreads = new Thread[numThreads];
            Thread[] delayTime = new Thread[numThreads];

            for (int i = 0; i < numThreads; i++) {
                System.out.print("Enter the time of delay for thread: ");
                int timeDelay = scanner.nextInt();

                ThreadStoper threadStopper = new ThreadStoper(timeDelay);
                delayTime[i] = new Thread(() -> threadStopper.setDelay());
                calculatorThreads[i] = new Thread(() -> sum(threadStopper));
            }

            for (int i = 0; i < numThreads; i++) {
                calculatorThreads[i].start();
                delayTime[i].start();
            }
        }
    }

    private static void sum(Object obj) {
        ThreadStoper stopper = (ThreadStoper) obj;
        long sum = 0;
        while (!stopper.IsStop) {
            sum++;
        }
        System.out.println("Id: " + Thread.currentThread().getId() + " -  result: " + sum);
    }
}

class ThreadStoper {
    public volatile boolean IsStop = false;
    private int delayTime;

    public ThreadStoper(int delayTime) {
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
