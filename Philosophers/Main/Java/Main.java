package Main.Java;

import java.util.concurrent.Semaphore;

public class Main {
    public static void main(String[] args) {
        Fork[] forks = new Fork[4];
        for (int i = 0; i < 4; i++) {
            forks[i] = new Fork(i);
        }

        Philosopher[] philosophers = new Philosopher[4];
        for (int i = 0; i < 4; i++) {
            philosophers[i] = new Philosopher(i, forks[i], forks[(i + 1) % 4]);
        }
        
        for (int i = 0; i < 4; i++) {
            new Thread(philosophers[i]).start();
        }
    }
}

class Fork{
    public int id;
    public Semaphore access;

    public Fork(int id){
        this.id = id;
        this.access = new Semaphore(1);
    }
}

class Philosopher implements Runnable{
    private final int id;
    private final Fork leftFork;
    private final Fork rightFork;

    public Philosopher(int id, Fork leftFork, Fork rightFork){
        this.id = id;
        this.leftFork = leftFork;
        this.rightFork = rightFork;
    }

    @Override
    public void run() {
        Fork firstFork;
        Fork secondFork;

        if (leftFork.id < rightFork.id) {
            firstFork = leftFork;
            secondFork = rightFork;
        } else {
            firstFork = rightFork;
            secondFork = leftFork;
        }

        try{
            for (int i = 0; i < 3; i++) {
                System.out.println("Philosopher " + id + " thinking time " + i);

                System.out.println("Philosopher " + id + " took fork " + firstFork.id);
                firstFork.access.acquire();
                
                System.out.println("Philosopher " + id + " took fork " + secondFork.id);
                secondFork.access.acquire();
                
                System.out.println("Philosopher " + id + " eating time " + i);

                System.out.println("Philosopher " + id + " put fork " + secondFork.id);
                secondFork.access.release();

                System.out.println("Philosopher " + id + " put fork " + firstFork.id);
                firstFork.access.release();
            }
        }catch(InterruptedException e){
            e.printStackTrace();
        }
    }
}