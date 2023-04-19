package Stream_synchronization_tools.Java;

public class ManageThread {
    private final int threadCount;
    private final double[] array;

    public ManageThread(int threadCount, double[] array) {
        this.threadCount = threadCount;
        this.array = array;
        this.minElems = new double[threadCount];
        this.finishedThreadCount = 0;
        threadMin();
    }

    private void threadMin(){
        MyThread[] myThread = new MyThread[threadCount];

        for (int i = 0; i < myThread.length; i++) {
            myThread[i] = new MyThread(i, i * array.length / threadCount, (i + 1) * array.length / threadCount, this);
        }

        for (MyThread thread : myThread) {
            new Thread(thread).start();
        }
    }

    private final double[] minElems;
    private int finishedThreadCount;

    synchronized public void collectMin(int id, double minElem){
        minElems[id] = minElem;
        finishedThreadCount++;
        notify();
    }

    public synchronized double getMin() {
        while (getFinishedThreadCount() < threadCount){
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

        return findMinInArray(minElems);
    }

    private int getFinishedThreadCount() {
        return finishedThreadCount;
    }

    public double partMin(int firstBound, int secondBound) {
        double min = array[firstBound];

        for (int i = firstBound; i < secondBound; i++) {
            if (array[i] < min) {
                min = array[i];
            }
        }

        return min;
    }

    private double findMinInArray(double[] array) {
        double min = array[0];

        for (double num : array) {
            if (num < min) {
                min = num;
            }
        }
        return min;
    }
}