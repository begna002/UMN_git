/* linknewif2.c */

/* Effectively, the value of k (both here and in main()) is set by        the last call to if_compute(), so the value of k will vary as
   the program is run.  Try it! */  int k;  // changed to weak symbol, maybe static was intended?

int if_compute(int x) {

    int result;
    k = x;

    if (x > 1)       result = x;     else result = -100;

    return result;
}
