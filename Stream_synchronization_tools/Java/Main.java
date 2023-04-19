package Stream_synchronization_tools.Java;

import java.util.Arrays;
import java.util.Random;

public class Main {
    public static void main(String[] args) {
        int threadCount = 4;
        double[] array = getRandomArray(12000000);
        ManageThread threadController = new ManageThread(threadCount, array);
        System.out.println(threadController.getMin());
        System.out.println(Arrays.stream(array).min().getAsDouble());
    }

    private static double[] getRandomArray(int count) {
        Random random = new Random();
        double[] array = new double[count];
        for (int i = 0; i < count; i++) {
            array[i] = random.nextDouble(1000);
        }
        array[random.nextInt(count)] = -(random.nextDouble(1000));
        return array;
    }
}