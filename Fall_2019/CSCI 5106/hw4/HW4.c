#include <stdio.h>
#include <stdlib.h>

void printArray(int arr[], int len) {
	printf("\n");
	for (int i = 0; i < len; i++) {
		printf("%d ", arr[i]);
	}
	printf("\n");

}

int partition (int arr[], int v, int m, int n) {
		// Pre-condition
		// {v >= 0, m >= 0, n >= 0}
		// This is what is visibally true prior to the first iteration
		// of the main loop

    int i = m - 1;

   // Loop Invariant
	 // 1. m <= (i + 1) <= k <= (n + 1)
	 // 2. For all j s.t. m <= j <= i, arr[j] < v
	 // 3. For all l s.t. (i + 1) <= l < k, arr[l] >= v
	 // 4. Values in arr are preserved, but arr[m..n] is some permutation
	 //    of those values
	 //
	 // Proving 1)
	 // Value of i is initially m-1, and gets incremented, thus m <= (i + 1)
	 // Value of k is initially m, and gets incremented with i, thus (i + 1) <= k
	 // Value of k is no longer incremented once k == n, thus k <= (n + 1)
	 //
	 // Proving 2)
	 // The design of this loop is such that once a value is found to be less than
	 // the value of v  it is replaced with arr[i]. Thus, for any value j in
	 // arr[m..i], arr[j] < v.
	 //
	 // Proving 3)
	 // The design of this loop is such that once a value is found to be greater
	 // than the value of v, the value k is incremented, getting larger than the
	 // value of i+1. Thus, for any value l in arr[i+1..i], arr[l] < v.
	 //
	 // Proving 4)
	 // The loop maintains the values in the array, however only positions are
	 // changed for values when arr[k] <= v
	 //
	 // Side Effects
	 // arr is altered to reflect the purpose of partitioning
    for (int k = m; k < n; k++) {
        if (arr[k] <= v) {
					  i++;
						int temp = arr[i];
	 					arr[i] = arr[k];
	 					arr[k] = temp;
        }
    }
		// Post-condition
		// {k == n}
		//
		// Termination
		// The terminating state is when the value of k == n, which will
		// inevitably occur since k is incremented during each iteration of the
		// loop.

    return i;
}


int main(int argc, char *argv[]){
	int array[] = {4, 11, 1 , 3 , 9, 8, 5, 6, 23};
	printf("Global Array:");
	int len = sizeof(array)/sizeof(array[0]);
	printArray(array, len);

	// Test 1, Edge Case
	printf("\nTest 1, Pivot value: 24");
	int ind = partition(array, 24, 0, len-1);
	printArray(array, len);

	// Test 2, Edge Case
	printf("\nTest 2, Pivot value: 0");
	ind = partition(array, 0, 0, len-1);
	printArray(array, len);

	// Test 3, Middle Case
	printf("\nTest 3, Pivot value: 7");
	ind = partition(array, 7, 0, len-1);
	printArray(array, len);

	return 0;
	}

// The tests chosen were designed to evaluate both edge cases, and a regular
// case where values in the array would be partitioned. With the edge cases,
// the values were chosen to reflect cases where all the values are greater than
// the pivot, as well as when all the values are less than the pivot. In those
// cases, the array should maintain it's original structure.
