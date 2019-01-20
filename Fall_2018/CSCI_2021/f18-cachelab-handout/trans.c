/*Moti Begna, begna002
 * trans.c - Matrix transpose B = A^T
 *
 * Each transpose function must have a prototype of the form:
 * void trans(int M, int N, int A[N][M], int B[M][N]);
 *
 * A transpose function is evaluated by counting the number of misses
 * on a 1KB direct mapped cache with a block size of 32 bytes.
 */
#include <stdio.h>
#include "cachelab.h"

int is_transpose(int M, int N, int A[N][M], int B[M][N]);

/*
 * transpose_submit - This is the solution transpose function that you
 *     will be graded on for Part B of the assignment. Do not change
 *     the description string "Transpose submission", as the driver
 *     searches for that string to identify the transpose function to
 *     be graded.
 */
char transpose_submit_desc[] = "Transpose submission";
void transpose_submit(int M, int N, int A[N][M], int B[M][N])
{
	int i, j, tmp, RBlock, CBlock;
	int D_elem, D_ind; //D_elem = diagonal element, D_ind = index of a diagonal element

	//Utalizing Blocking in order to loop through the submatrices in Matrix A and B
  //Tested various block sizes by dividing N by 2 until best performance was found
  //Implementing a method that loops through blocks in Row-Major Order
  //3 Cases: N == 32, N == 64, Catch-All
  //Diagonal values are special cases (when i == j)

	if (N == 32 && M == 32){
		for (RBlock = 0; RBlock < N; RBlock += 8){
			for (CBlock = 0; CBlock < N; CBlock += 8){
        for (i = RBlock; i < RBlock + 8; i ++){
					for (j = CBlock; j < CBlock + 8; j ++){
						if (i != j){
							tmp = A[i][j];
              B[j][i] = tmp;
						}
						else if (i == j){
							D_elem = A[i][i];
							D_ind = i;
						}
					}
					if (RBlock == CBlock){
						B[D_ind][D_ind] = D_elem;
					}
				}
			}
		}
	}

	else if (N == 64 && M == 64){
		for (RBlock = 0; RBlock < N; RBlock += 4){
			for (CBlock = 0; CBlock < N; CBlock += 4){
				for (i = RBlock; i < RBlock + 4; i ++){
					for (j = CBlock; j < CBlock + 4; j ++){
						if (i != j){
              tmp = A[i][j];
              B[j][i] = tmp;
						}
						else if (i == j){
							D_elem = A[i][i];
							D_ind = i;
						}
					}
					if (RBlock == CBlock){
						B[D_ind][D_ind] = D_elem;
					}
				}
			}
		}
	}
	else {
		//Utalize Column-Major implementation rather than Row-Major
    //Guess and Checked best Block Sizes
		for (CBlock = 0; CBlock < M; CBlock += 17){
			for (RBlock = 0; RBlock < N; RBlock += 17){
        //HAVE TO CHECK if i and j are ever greater than N and M since a
        //61x67 Matrix will not have perfectly square sub-matrices
				for (i = RBlock; (i < RBlock + 17) && (i < N); i ++){
					for (j = CBlock; (j < CBlock + 17) && (j < M); j ++){
						if (i != j){
              tmp = A[i][j];
              B[j][i] = tmp;
						}
						else if (i == j){
							D_elem = A[i][i];
							D_ind = i;
						}
					}
					if (RBlock == CBlock) {
						B[D_ind][D_ind] = D_elem;
					}
				}
	 		}
		}
	}
}


/*
 * You can define additional transpose functions below. We've defined
 * a simple one below to help you get started.
 */

/*
 * trans - A simple baseline transpose function, not optimized for the cache.
 */
char trans_desc[] = "Simple row-wise scan transpose";
void trans(int M, int N, int A[N][M], int B[M][N])
{
    int i, j, tmp;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; j++) {
            tmp = A[i][j];
            B[j][i] = tmp;
        }
    }

}

/*
 * registerFunctions - This function registers your transpose
 *     functions with the driver.  At runtime, the driver will
 *     evaluate each of the registered functions and summarize their
 *     performance. This is a handy way to experiment with different
 *     transpose strategies.
 */
void registerFunctions()
{
    /* Register your solution function */
    registerTransFunction(transpose_submit, transpose_submit_desc);

    /* Register any additional transpose functions */
    registerTransFunction(trans, trans_desc);

}

/*
 * is_transpose - This helper function checks if B is the transpose of
 *     A. You can check the correctness of your transpose by calling
 *     it before returning from the transpose function.
 */
int is_transpose(int M, int N, int A[N][M], int B[M][N])
{
    int i, j;

    for (i = 0; i < N; i++) {
        for (j = 0; j < M; ++j) {
            if (A[i][j] != B[j][i]) {
                return 0;
            }
        }
    }
    return 1;
}
