#include<stdio.h>
#include<stdlib.h>
#include<math.h>
#include <sys/types.h>
#include <unistd.h>

void stree_cpu(){
	
	while( 1 ){
		sqrt( rand() );	
	}
}

int main(void){
	
	switch(fork()){
		case -1:
			/* An error has occurred */
			printf("Fork Error");
        break;
        case 0:
        	stree_cpu();
        break;
        default:
        	stree_cpu();
	}
	
	return 0;
}
