public class Luby {
    private int n = 0, count = 1;
    public String next() {
        if (count % 2 != 0) {
            count = n * count + 1;
            n = 1;
        } else {
            count = count / 3;
            n = 2 * n;
        }
        return String.valueOf(n);
    }
}
