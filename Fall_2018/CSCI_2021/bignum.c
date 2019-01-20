//Moti Begna begna002
/* -----------
 * bignum_math.c
 * Project for CSCI 2021, Fall 2018, Professor Chris Dovolis
 * orginially written by Andy Exley
 * modified by Ry Wiese, Min Choi, Aaron Councilman
 * ---------- */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define false 0;
#define true 1;

typedef int bool;

/*
 * Returns true if the given char is a digit from 0 to 9
 */
bool is_digit(char c) {
	return c >= '0' && c <= '9';
}

/*
 * Returns true if lower alphabetic character
 */
bool is_lower_alphabetic(char c) {
	return c >= 'a' && c <= 'z';
}

/*
 * Returns true if upper alphabetic character
 */
bool is_upper_alphabetic(char c) {
	return c >= 'A' && c <= 'Z';
}

/*
 * Convert a string to an integer
 * returns 0 if it cannot be converted.
 */
int string_to_integer(char* input) {
	int result = 0;
	int length = strlen(input);
	int num_digits = length;
	int sign = 1;

	int i = 0;
	int factor = 1;

	if (input[0] == '-') {
		num_digits--;
		sign = -1;
	}

	for (i = 0; i < num_digits; i++, length--) {
		if (!is_digit(input[length-1])) {
			return 0;
		}
		if (i > 0) factor*=10;
		result += (input[length-1] - '0') * factor;
	}

	return sign * result;
}

/*
 * Returns true if the given base is valid.
 * that is: integers between 2 and 36
 */
bool valid_base(int base) {
	if(!(base >= 2 && base <= 36)) {
		return false;
	}
	return true;
}

//checks if a character is valid within a given base
//ex. g is not valid in base 16
bool valid_base_character(char c, int base){
	int exists = 0;
	//handles upper and lower case cases
	char strL[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
								 '9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
							   'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
							 	 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
	char strU[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
								 '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
								 'I', 'J', 'J', 'L', 'M', 'N', 'O', 'P', 'Q',
							   'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'};
	for(int i = 0; i < base; i++){
		if (strL[i] == c){exists = 1;}
	}
	for(int i = 0; i < base; i++){
		if (strU[i] == c){exists = 1;}
	}
	if(exists == 0){
		printf("%c is not a valid character in base %d\n", c, base);
		return false;
	}
	return true;
}

/*
 * TODO
 * Returns true if the given string (char array) is a valid input,
 * that is: digits 0-9, letters A-Z, a-z
 * and it should not violate the given base and should not handle negative numbers
 */
bool valid_input(char* input, int base) {
	int len = 0;
	while(input[len] != '\0') { len++; }
	if(!valid_base(base)){
		return false;
	}
	for(int i = 0; i < len; i++){
		if(!is_upper_alphabetic(input[i]) && !is_lower_alphabetic(input[i]) && !is_digit(input[i])){
			return false;
		}

		if(!valid_base_character(input[i], base)){
			return false
		}
	}

	return true;

}

/*
 * converts from an array of characters (string) to an array of integers
 */
int* string_to_integer_array(char* str) {
	int* result;
	int i, str_offset = 0;
		result = malloc((strlen(str) + 1) * sizeof(int));
		result[strlen(str)] = -1;
	for(i = str_offset; str[i] != '\0'; i++) {
		if(is_digit(str[i])) {
			result[i - str_offset] = str[i] - '0';
		} else if (is_lower_alphabetic(str[i])) {
			result[i - str_offset] = str[i] - 'a' + 10;
		} else if (is_upper_alphabetic(str[i])) {
			result[i - str_offset] = str[i] - 'A' + 10;
		} else {
			printf("I don't know how got to this point!\n");
		}
	}
	return result;
}

/*
 * finds the length of a bignum...
 * simply traverses the bignum until a negative number is found.
 */
int bignum_length(int* num) {
	int len = 0;
	while(num[len] >= 0) { len++; }
	return len;
}

/*
 * TODO
 * Prints out a bignum using digits and lower-case characters
 * Current behavior: prints integers
 * Expected behavior: prints characters
 */
void bignum_print(int* num) {
	int i;
	char value;
	if(num == NULL) { return; }
	char str[] = {'0', '1', '2', '3', '4', '5', '6', '7', '8',
								'9', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h',
							  'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q',
							 	'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};

	i = bignum_length(num);
	//handles multiplication by 0
	if(i == 2 && num[0] == 37){printf("0");}

	/* Then, print each digit */
	for(i = 0; num[i] >= 0; i++) {
		if(num[i] != 37){
			value = str[num[i]];
			printf("%c", value);
		}
	}
	printf("\n");
}

/*
 *	Helper for reversing the result that we built backward.
 *  see add(...) below
 */
void reverse(int* num) {
	int i, len = bignum_length(num);
	for(i = 0; i < len/2; i++) {
		int temp = num[i];
		num[i] = num[len-i-1];
		num[len-i-1] = temp;
	}
}


/*
 * addition of input1 and input2
 * PROVIDED FOR GUIDANCE
 */
int* add(int* input1, int* input2, int base) {
	int len1 = bignum_length(input1); //len of input 1
	int len2 = bignum_length(input2); //len of input 2
	int resultlength = ((len1 > len2)? len1 : len2) + 2;
	int* result = (int*) malloc (sizeof(int) * resultlength);
	int r = 0;
	int carry = 0;
	int sign = input1[len1];
	int num1, num2;

	len1--;
	len2--;

	while (len1 >= 0 || len2 >= 0) {
	        if (len1 >= 0) {
        	    num1 = input1[len1];
	        } else {
        	    num1 = 0;
        	}

		if (len2 >= 0) {
		    num2 = input2[len2];
		} else {
		    num2 = 0;
		}

		result[r] = (num1 + num2 + carry) % base;
		carry = (num1 + num2 + carry) / base;

		len1--;
		len2--;
		r++;
	}
	if (carry > 0) {
		result[r] = carry;
		r++;
    	}
	result[r] = sign;
	reverse(result);
	return result;
}


/*
 * TODO
 * return true if input1 < input2, and false otherwise
 */
bool less_than(int* input1, int* input2) {
	int len1 = bignum_length(input1); //len of input 1
	int len2 = bignum_length(input2); //len of input 2
	len1--;
	len2--;
	if (len1>len2){
		return false;
	}
	else{
 		int i = 0;
 		while (i <= len1) {
 			if (input1[i] < input2[i]){
 				return true;
			}
			else if (input1[i] > input2[i]){
				return false;
			}
			i++;
		}
	}
	return false;
}


/*
 * TODO
 * return true if input1 > input2, and false otherwise
 */
bool greater_than(int* input1, int* input2) {
	int len1 = bignum_length(input1); //len of input 1
	int len2 = bignum_length(input2); //len of input 2
	len1--;
	len2--;
	if (len1<len2){
		return false;
	}
	else{
 		int i = 0;
 		while (i <= len1) {
 			if (input1[i] > input2[i]){
 				return true;
			}
			else if (input1[i] < input2[i]){
				return false;
			}
			i++;
		}
	}
	return false;
}

/*
 * TODO
 * return true if input1 == input2, and false otherwise
 */
 bool equal_to(int* input1, int* input2) {
 	int len1 = bignum_length(input1); //len of input 1
 	int len2 = bignum_length(input2); //len of input 2
	len1--;
	len2--;
 	if (len1>len2 || len2>len1){
 		return false;
 	}
 	else{
 		while (len1 >= 0) {
 			if (input1[len1] != input2[len2]){
 				return false;
			}
			len1--;
			len2--;
		}
	}
 	return true;

 }



int* multiply(int* input1, int* input2, int base) {
	int len1 = bignum_length(input1); //len of input 1
	int len2 = bignum_length(input2); //len of input 2
	int resultlength = ((len1 > len2)? len1 : len2)*2;
	int temp_len = resultlength;
	int* result = (int*) malloc (sizeof(int) * resultlength);
	int carry = 0;
	int sign = input1[len1];
	int num1, num2, result_num;
	len1--;
	len2--;
	resultlength--;
	//makes every value in result 0
	for(int i = 0; i < resultlength; i++){
		result[i] = 0;
	}
	//determines how many times to add num1 to the result
	int rep = 0;
	int power = 0;
	printf("\n");
	while (len2 >= 0){
		if (len2 >= 0) {
				num2 = input2[len2];
		} else {
				num2 = 0;
		}
		int temp_base = 1;
		int temp_power = power;
		while (temp_power > 0){
			temp_base *= base;
			temp_power--;
		}
		rep += num2*temp_base;
		power++;
		len2--;
	}
	//adds num1 to the result "rep" times
	for(rep; rep > 0; rep--){
		while (len1 >= 0 || resultlength >= 0) {
			if(len1 >= 0) {
				num1 = input1[len1];
			} else {
				num1 = 0;
			}

			if(resultlength >= 0) {
				result_num = result[resultlength];
			} else {
				result_num = 0;
			}

			result[resultlength] = (result_num + num1 + carry) % base;
			carry = (result_num + num1 + carry) / base;

			len1--;
			resultlength--;
		}
		if (carry > 0) {
			result[resultlength] = carry;
			resultlength++;
				}
		carry = 0;
		len1 = bignum_length(input1);
		resultlength = temp_len;
		len1 --;
		resultlength--;
	}
	//replaces 0's that exists in the first couple indeces of result by making
	//them 37, since a value at any given index can never be 37
	int replace = 0;
	result[temp_len] = sign;
	while(result[replace] == 0){
		result[replace] = 37;
		replace++;
	}
	return result;
}


void perform_operation(int* input1, int* input2, char op, int base) {

	if(op == '+') {
		int* result = add(input1, input2, base);
		printf("Result: ");
		bignum_print(result);
		printf("\n");
		free(result);
	}
	if(op == '*') {
		int* result = multiply(input1, input2, base);
		printf("Result: ");
		bignum_print(result);
		printf("\n");
		free(result);
	}
	if(op == '=') {
		bool result = equal_to(input1, input2);
		printf("Result: %s", result ? "true" : "false");
		printf("\n");
	}
	if(op == '<') {
		bool result = less_than(input1, input2);
		printf("Result: %s", result ? "true" : "false");
		printf("\n");
	}
	if(op == '>') {
		bool result = greater_than(input1, input2);
		printf("Result: %s", result ? "true" : "false");
		printf("\n");
	}

	/*
	 * TODO
	 * Handle multiplication, less than, greater than, and equal to
	 */
}

/*
 * Print to "stderr" and exit program
 */
void print_usage(char* name) {
	fprintf(stderr, "----------------------------------------------------\n");
	fprintf(stderr, "Usage: %s base input1 operation input2\n", name);
	fprintf(stderr, "base must be number between 2 and 36, inclusive\n");
	fprintf(stderr, "input1 and input2 are arbitrary-length integers\n");
	fprintf(stderr, "Permited operations are allowed '+', '*', '<', '>', and '='\n");
	fprintf(stderr, "----------------------------------------------------\n");
	exit(1);
}


/*
 * MAIN: Run the program and tests your functions.
 * sample command: ./bignum 4 12 + 13
 * Result: 31
 */
int main(int argc, char** argv) {

	int input_base;

	int* input1;
	int* input2;

	if(argc != 5) {
		print_usage(argv[0]);
	}

	input_base = string_to_integer(argv[1]);

	if(!valid_base(input_base)) {
		fprintf(stderr, "Invalid base: %s\n", argv[1]);
		print_usage(argv[0]);
	}

	if(!valid_input(argv[2], input_base)) {
		fprintf(stderr, "Invalid input1: %s\n", argv[2]);
		print_usage(argv[0]);
	}

	if(!valid_input(argv[4], input_base)) {
		fprintf(stderr, "Invalid input2: %s\n", argv[4]);
		print_usage(argv[0]);
	}

	char op = argv[3][0];
	if(op != '+' && op != '*' && op != '<' && op != '>' && op != '=') {
		fprintf(stderr, "Invalid operation: %s\n", argv[3]);
		print_usage(argv[0]);
	}

	input1 = string_to_integer_array(argv[2]);
	input2 = string_to_integer_array(argv[4]);

	perform_operation(input1, input2, op, input_base);

	free(input1);
	free(input2);

	exit(0);
}
