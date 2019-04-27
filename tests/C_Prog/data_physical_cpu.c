#include<stdio.h>
#include<stdlib.h>
#include <unistd.h>

#define FUNC_ERROR -1

/**
*This fonction takes a table of logical cpu's data ana calcul the physical data of them.
*@param nopc is the number of physical cpu's
*@param tab_data_logical the logical cpu data
*@return a table how contains the physical data of the cpu's
*/

float* table_convert(int nopc, float* tab_data_logical){
	float* tab_data_physical = malloc(sizeof(float) * (nopc - 1));
	if(tab_data_physical == NULL){
		fprintf(stderr, "table_convert: malloc error!\n");
		return NULL;
	}

	for(int i = 0; i < nopc; i++){
		tab_data_physical[i] = (tab_data_logical[i] + tab_data_logical[i + nopc]) / 2;
	}
	return tab_data_physical;	
}

/**
*This function is used to convert the data of logical cpu's to an physical data cpu's
*@param nopc is the number of physical cpu's
*@return it's returns 0 if evrithing is done, FUNC_ERROR if ther's a problem
*data_logical.dat is the name of the file how contains the data of the logical cpu's
*/

int convert_to_physical(int nopc){
	FILE* file_data_logical;
	FILE* file_data_physical;
	int time;
	float all;
	char * line = NULL;
    size_t len = 0;
    ssize_t read;
    float* tab_data_physical;

	file_data_logical = fopen ("plot/data_logical.dat", "r+");
	file_data_physical = fopen("plot/data_physical.dat", "w+");

	if(file_data_logical == NULL || file_data_logical == NULL){
		fprintf(stderr, "convert_to_physical: open file data error!\n");
		return FUNC_ERROR;
	}

	if(nopc < 2){
		fprintf(stderr, "convert_to_physical: invalid argument!\n");
		return FUNC_ERROR;
	}

	float* tab_data = malloc(sizeof(float) * ((nopc * 2) - 1));
	if(tab_data == NULL){
		fprintf(stderr, "convert_to_physical: malloc error!\n");
		return FUNC_ERROR;
	}

	fprintf(file_data_physical, "t CORE[ALL] ");
	for(int i = 0; i < nopc; i++){
		if(i < nopc - 1)
			fprintf(file_data_physical, "CORE[%d] ", i);
		else
			fprintf(file_data_physical, "CORE[%d]\n", i);
	}
	
	while((read = getline(&line, &len, file_data_logical)) != -1){
		fscanf(file_data_logical, "%d %f ", &time, &all);
		fprintf(file_data_physical, "%d %.2f ", time, all);
		
		for(int i = 0; i < nopc * 2; i++){
	    	if(i < (nopc * 2) - 1){
	    		fscanf(file_data_logical, "%f ", tab_data+i);
	    	}
	    	else{
	    		fscanf(file_data_logical, "%f ", tab_data+i);
	    	}
	    }
	    tab_data_physical = table_convert(nopc, tab_data);
	    for (int i = 0; i < nopc; i++){
	    	if(i < nopc - 1){
	    		fprintf(file_data_physical, "%.2f ", tab_data_physical[i]);
	    	}
	    	else{
	    		fprintf(file_data_physical, "%.2f\n", tab_data_physical[i]);
	    	}
	    }
	}

	if (line)
		free(line);
	fclose(file_data_logical);
	fclose(file_data_physical);
	free(tab_data);
	return 0;
}


int main(int argc, char** argv){
	
	if(argc < 2){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [number of physical cpu]\n", argv[0]);
		return FUNC_ERROR;
	}

	if(convert_to_physical(atoi(argv[1])) < 0){
		fprintf(stderr, "main: convert_to_physical!\n");
		return FUNC_ERROR;		
	}

	return 0;
}