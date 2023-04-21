package org.example;

public class Main {
    public static void main(String[] args) {
        compoundInterest();

    }

    public static void compoundInterest() {
        double principal = 10000;
        double rate = 10.25;
        double time = 5;
        time = time;

        /* Calculate compound interest */
        double CI = principal *
                (Math.pow((1 + rate / 100), time));

        System.out.println("Compound Interest is "+ CI);
    }
}