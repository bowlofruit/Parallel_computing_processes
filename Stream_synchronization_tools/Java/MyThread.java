package Stream_synchronization_tools.Java;

public class MyThread implements Runnable {
    private final int id;
    private final int firstIndex;
    private final int secondIndex;
    private final ManageThread threadManager;

    public MyThread(int id, int firstIndex, int secondIndex, ManageThread threadManager) {
        this.id = id;
        this.firstIndex = firstIndex;
        this.secondIndex = secondIndex;
        this.threadManager = threadManager;
    }

    @Override
    public void run() {
        double min = threadManager.partMin(firstIndex, secondIndex);
        System.out.printf("%s %d \n", Thread.currentThread().getName(), firstIndex);
        threadManager.collectMin(id, min);
    }
}