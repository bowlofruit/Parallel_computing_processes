package Stream_synchronization_tools.Java;

public class ThreadSum extends Thread{

    private final int startIndex;
    private final int finishIndex;
    private final ArrClass arrClass;

    public ThreadSum(int startIndex, int finishIndex, ArrClass arrClass) {
        this.startIndex = startIndex;
        this.finishIndex = finishIndex;
        this.arrClass = arrClass;
    }

    @Override
    public void run() {
        long sum = arrClass.partSum(startIndex, finishIndex);
        arrClass.collectSum(sum);
        System.out.printf("%s %d \n", Thread.currentThread().getName(), finishIndex);
        arrClass.incThreadCount();
    }
}
