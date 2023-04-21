import java.awt.image.AreaAveragingScaleFilter;
import java.lang.reflect.Array;
import java.math.BigInteger;
import java.util.Scanner;
import java.util.*;

import static java.lang.System.exit;

public class Main {
    public static void main(String[] args) throws Exception {
//        hw1(args);
//        System.out.println(collapse("The quick\n\nbrown fox\njumped"));

//        hw4(args);
        luby();



    }

    public static void hw1 (String[] args) throws Exception{
        final ArrayList<String[] > inputMap = new ArrayList<>();
        final ArrayList<String> outputMap = new ArrayList<>();

        if (args.length == 0 ) {
            throw new Exception("No inputs given");

        } else if (args.length > 4 ) {
            throw new Exception("Too many inputs");

        }

        //Create input map
        for (int i = 0; i < args.length; i++) {
            String pair = args[i];
            if (!pair.contains(",")) {
                throw new Exception("input patterns are not comma separated");
            }
            String[] keyValuePair = pair.split(",");

            try {
                Integer.valueOf(keyValuePair[0]);
                Integer.valueOf(keyValuePair[1]);
            }
            catch (Exception e) {
                throw new Exception("One or more of the inputs is not an integer");
            }

            if (Integer.valueOf(keyValuePair[0]) < 1 || Integer.valueOf(keyValuePair[1]) < 1) {
                throw new Exception("One or more input integers is not positive");
            }

            if (keyValuePair[0].length() > 3 || keyValuePair[1].length() > 3) {
                throw new Exception("One or more input integers has more than 3 digits");
            }

            inputMap.add(keyValuePair);
        }

        for (int i = 0; i < inputMap.size(); i++) {
            if (i== 0) {
                outputMap.add(inputMap.get(0)[0] + "," + inputMap.get(0)[1]);
            } else {
                //First number of pair
                int k = 0;
                int firstNum = overlap(inputMap.subList(k, i+1));

                if (firstNum == -1) {
                    System.out.println(String.format("No overlap found for pattern: %s, %s", inputMap.get(i)[0], inputMap.get(i)[1]));
                    System.out.println("Thus it is being discarded\n");
                    inputMap.remove(i);
                    i -= 1; // need to decrement counter since inputMap got smaller
                    continue;
                }

                //Second number of pair
                int acc = Integer.valueOf(inputMap.get(0)[1]);
                int j = 0;
                while (j < i+1) {
                    acc = lcm(acc, Integer.valueOf(inputMap.get(j)[1]));
                    j++;
                }

                outputMap.add(firstNum + ", " + acc);
            }
        }

        System.out.println("Output:");
        outputMap.stream().forEach(str -> {
            System.out.println(str);
        });
    }

    static int gcd(int a, int b)
    {
        if (a == 0)
            return b;
        return gcd(b % a, a);
    }

    // Function to return LCM of two numbers
    static int lcm(int a, int b)
    {
        return (a / gcd(a, b)) * b;
    }

    // Function to return overlap between at most 4 patterns
    static int overlap(List<String[] > inputMap) {
        int result =-1;
        switch (inputMap.size()) {
            case (2):
                ArrayList<Integer> iAcc = new ArrayList<>();
                iAcc.add(Integer.valueOf(inputMap.get(0)[0]));

                ArrayList<Integer> jAcc = new ArrayList<>();
                jAcc.add(Integer.valueOf(inputMap.get(1)[0]));

                int i = Integer.valueOf(inputMap.get(0)[0]);
                int j = Integer.valueOf(inputMap.get(1)[0]);
                for (int z = 0; z < 100; z++) {
                    i += Integer.valueOf(inputMap.get(0)[1]);
                    iAcc.add(i);

                    j += Integer.valueOf(inputMap.get(1)[1]);
                    jAcc.add(j);

                }

                for (int num: iAcc) {
                    if (jAcc.contains(num)) {
                        result = num;
                        break;
                    }
                }
                break;
            case (3):
                iAcc = new ArrayList<>();
                iAcc.add(Integer.valueOf(inputMap.get(0)[0]));

                jAcc = new ArrayList<>();
                jAcc.add(Integer.valueOf(inputMap.get(1)[0]));

                ArrayList<Integer> kAcc = new ArrayList<>();
                kAcc.add(Integer.valueOf(inputMap.get(2)[0]));


                i = Integer.valueOf(inputMap.get(0)[0]);
                j = Integer.valueOf(inputMap.get(1)[0]);
                int k = Integer.valueOf(inputMap.get(2)[0]);
                for (int z = 0; z < 100; z++) {
                    i += Integer.valueOf(inputMap.get(0)[1]);
                    iAcc.add(i);

                    j += Integer.valueOf(inputMap.get(1)[1]);
                    jAcc.add(j);

                    k += Integer.valueOf(inputMap.get(2)[1]);
                    kAcc.add(k);

                }

                for (int num: iAcc) {
                    if (jAcc.contains(num) && kAcc.contains(num)) {
                        result = num;
                        break;
                    }
                }
                break;
            case (4):
                iAcc = new ArrayList<>();
                iAcc.add(Integer.valueOf(inputMap.get(0)[0]));

                jAcc = new ArrayList<>();
                jAcc.add(Integer.valueOf(inputMap.get(1)[0]));

                kAcc = new ArrayList<>();
                kAcc.add(Integer.valueOf(inputMap.get(2)[0]));

                final ArrayList<Integer> lAcc = new ArrayList<>();
                lAcc.add(Integer.valueOf(inputMap.get(3)[0]));

                i = Integer.valueOf(inputMap.get(0)[0]);
                j = Integer.valueOf(inputMap.get(1)[0]);
                k = Integer.valueOf(inputMap.get(2)[0]);
                int l = Integer.valueOf(inputMap.get(3)[0]);

                for (int z = 0; z < 100; z++) {
                    i += Integer.valueOf(inputMap.get(0)[1]);
                    iAcc.add(i);

                    j += Integer.valueOf(inputMap.get(1)[1]);
                    jAcc.add(j);

                    k += Integer.valueOf(inputMap.get(2)[1]);
                    kAcc.add(k);

                    l += Integer.valueOf(inputMap.get(3)[1]);
                    lAcc.add(l);

                }

                for (int num: iAcc) {
                    if (jAcc.contains(num) && kAcc.contains(num) && lAcc.contains(num)) {
                        result = num;
                        break;
                    }
                }
                break;
            default:
        }
        return result;
    }

    public static String collapse(String argStr) {
        char last = argStr.charAt(0);
        StringBuffer argBuffer = new StringBuffer();
        for (int i = 0; i < argStr.length(); i ++) {
            char ch = argStr.charAt(i);

            if (ch != '\n' || last != '\n') {

                argBuffer.append(ch);
                last = ch;
            }
        }
        return argBuffer.toString();
    }

    public static void hw4(String[] argv) {
        String USAGE = "USAGE: Choices NUMBER1 [ NUMBER2 [-] ]\n" +
                "\tNumber of possible choices for selecting a tuple (or a subset) of size NUMBER2 from a set of size NUMBER1.\n" +
                "\tA third argument if given, must be ‘-’ and it indicates unordered selection (i.e., a subset instead of a tuple).\n" + "\t[ ] surround optional arguments; " + "NUMBER2, if not given, is NUMBER1; both must be non-negative integers.\n";


        final int argc = argv.length;
        if (argc >= 1 && argc <= 3 && (argc != 3 || (argv[2].length() >= 1 && argv[2].charAt(0) == '-'))) {
            final int arg1 = Integer.parseUnsignedInt(argv[0]);
            final int arg2 = argc > 1 ? Integer.parseUnsignedInt(argv[1]) : arg1;
            final char sym = argc == 3 ? 'C' : argc == 2 ? 'P' : '!';
            System.out.printf("%1$s%2$c%3$s = %4$s%n", argv[0], sym, argc > 1 ? argv[1] : "", choose(arg1, arg2, argc < 3));
        }
        else System.err.println(USAGE);
    }

    private static BigInteger choose(final int n, int k, final boolean ordered) { if (k > n) return BigInteger.valueOf(0);
        if (ordered || k <= n/2) k = n - k;
        BigInteger num = BigInteger.valueOf(1);
        int i = 0; while (k < n) {
            num = num.multiply(BigInteger.valueOf(++k));
            if (!ordered) num = num.divide(BigInteger.valueOf(++i)); }
        return num; }

    private static void luby() {
        Scanner input = new Scanner(System.in);
        Luby l = new Luby();

        System.out.println("Enter: ");
        int val = input.nextInt();
        ArrayList lis = new ArrayList();

        for (int i = 0; i < val; i++) {
            lis.add(l.next());
        }
        System.out.println(String.join(", ", lis));

    }

}