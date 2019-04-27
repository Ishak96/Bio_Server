#include<stdio.h>
#include<stdlib.h>
#include<math.h>

int fact(int n){
	if(n == 0){
		return 1;
	}
	else{
		return fact(n-1) * n;
	}
}

int main(int argc, char** argv){
	
	if(argc < 2){
		printf("usage: %s <value>\n", argv[0]);
		return 0;
	}
	int n = atoi(argv[1]);
	int f = fact(n);
	printf("%d! = %d\n", n, f);
	printf("tan(%d) = %g\n", f, tan(f));
	printf("atan(%d) = %g\n", f, atan(f));
	return 0;
}