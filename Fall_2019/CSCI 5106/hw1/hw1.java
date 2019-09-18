class hw1{
 public char[] getOdds(char[] lst, int len){
  int newlen;
  if (len % 2 == 0) {
   newlen = len / 2;
  } else {
   newlen = (len / 2) + 1;
  }
  char ret[] = new char[newlen];
  int ind = 0;
  for (int i = 0; i < len; i+=2) {
   ret[ind] = lst[i];
   ind ++;
  }
  return ret;
 }

 public int test1(char[] rep, char[] expect, int ver) {
  char result[] = getOdds(rep, rep.length);
  for (int i = 0; i < expect.length; i++) {
   if (result[i] != expect[i]) {
    System.out.format("Test %d failed\n", ver);
    return 0;
   }
  }
  System.out.format("Test %d passed\n", ver);
  return 1;
 }


 public static void main(String[] args) {
  hw1 tested = new hw1();
  char rep1[] = {'a', 'b', '?', 'd', 'e'};
  char expect1[] = {'a', '?', 'e'};
  char rep2[] = {'a', 'b', '?', 'd'};
  char expect2[] = {'a', '?'};
  char rep3[] = {};
  char expect3[] = {};
  int val1 = tested.test1(rep1, expect1, 1);
  int val2 = tested.test1(rep2, expect2, 2);
  int val3 = tested.test1(rep3, expect3, 3);

 }
}
