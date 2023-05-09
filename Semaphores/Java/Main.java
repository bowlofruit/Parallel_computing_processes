import java.util.List;
import java.util.LinkedList;
import java.util.concurrent.Semaphore;

public class Main {
    private static final int size = 4;
    private static final int work_target = 10;
    private static final int producer_count = 4;
    private static final int consumer_count = 6;

    private static List<String> storage;
    private static Semaphore accessStorage;
    private static Semaphore fullStorage;
    private static Semaphore emptyStorage;

    private static int producersWorkDone = 0;
    private static Semaphore accessProducersWorkDone;
    private static int consumersWorkDone = 0;
    private static Semaphore accessConsumersWorkDone;

    public static void main(String[] args) {
        storage = new LinkedList<>();
        accessStorage = new Semaphore(1);
        fullStorage = new Semaphore(size);
        emptyStorage = new Semaphore(0);
        accessProducersWorkDone = new Semaphore(1);
        accessConsumersWorkDone = new Semaphore(1);

        ProducerTask[] producers = new ProducerTask[producer_count];
        ConsumerTask[] consumers = new ConsumerTask[consumer_count];

        for (int i = 0; i < producer_count; i++) {
            producers[i] = new ProducerTask("Producer " + (i + 1));
            producers[i].start();
        }

        for (int i = 0; i < consumer_count; i++) {
            consumers[i] = new ConsumerTask("Consumer " + (i + 1));
            consumers[i].start();
        }
    }

    private static class ProducerTask extends Thread {
        private String producerName;

        public ProducerTask(String name) {
            producerName = name;
        }

        public void run() {
            while (producersWorkDone < work_target) {
                try {
                    accessProducersWorkDone.acquire();
                    if (producersWorkDone < work_target) {
                        fullStorage.acquire();
                        Thread.sleep(250);
                        accessStorage.acquire();

                        producersWorkDone++;
                        storage.add("item " + producersWorkDone);
                        System.out.println(producerName + " added item " + producersWorkDone);

                        accessStorage.release();
                        emptyStorage.release();
                    }
                    accessProducersWorkDone.release();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private static class ConsumerTask extends Thread {
        private String consumerName;

        public ConsumerTask(String name) {
            consumerName = name;
        }

        public void run() {
            while (consumersWorkDone < work_target) {
                try {
                    accessConsumersWorkDone.acquire();
                    if (consumersWorkDone < work_target) {
                        emptyStorage.acquire();
                        Thread.sleep(250);
                        accessStorage.acquire();

                        consumersWorkDone++;
                        String item = storage.remove(0);
                        System.out.println(consumerName + " took " + item);

                        accessStorage.release();
                        fullStorage.release();
                    }
                    accessConsumersWorkDone.release();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}