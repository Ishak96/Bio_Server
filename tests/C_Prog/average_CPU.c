#include<stdio.h>
#include<stdlib.h>
#include <unistd.h>
#include <string.h>

#define FUNC_ERROR -1

char* get_new_file_name(int noc, char* old_file_name){
	char* new_file_name;
	char number_of_cpu[12];
	sprintf(number_of_cpu, "_%d", noc);

	if( old_file_name == NULL ){
		fprintf(stderr, "new_file_name: invalid argument!\n");
		return NULL;
	}

	int len = strlen(old_file_name) + 1;

	new_file_name = malloc( sizeof(char) * len );
	strcpy(new_file_name, "..");

	char delim[2] = ".";
	char* tok = strtok(old_file_name, delim);

	strcat(tok, number_of_cpu);
	strcat(tok, ".dat");
	strcat(new_file_name, tok);

	return new_file_name;
}

int calculate_avrage(int noc, char* old_file_name){
	FILE* old_data_file;
	FILE* new_data_file;
	char * line = NULL;
    size_t len = 0;
    ssize_t read;
    float time, all;

	if( old_file_name == NULL ){
		fprintf(stderr, "calculate_avrage: invalid argument!\n");
		return FUNC_ERROR;
	}

	old_data_file=fopen(old_file_name, "r+");
	
	char* new_file_name = get_new_file_name(noc, old_file_name);
	if( new_file_name == NULL ){
		fprintf(stderr, "calculate_avrage: new file name NULL!\n");
		return FUNC_ERROR;
	}

	if( old_data_file == NULL ){
		fprintf(stderr, "calculate_avrage: open file!\n");
		return FUNC_ERROR;
	}

	new_data_file=fopen(new_file_name, "w+");
	if( new_data_file == NULL ){
		fprintf(stderr, "calculate_avrage: open file!\n");
		return FUNC_ERROR;
	}
	
	char delim[2] = " ";
	while((read = getline(&line, &len, old_data_file)) != -1){
		int index = 0;
		
		char* tok = strtok(line, delim);
		while( tok != NULL ) {
			if( strcmp(tok, "\n") && index < 2){
				if(index == 1 && strcmp(tok, "cpu")){
					fprintf(new_data_file, "%f ", atof(tok) / noc);
				}
				else{
					fprintf(new_data_file, "%s ", tok);
				}
			}
			tok = strtok(NULL, delim);
			index++;
		}
		fprintf(new_data_file, "\n");
	}

	if (line)
		free(line);
	fclose(new_data_file);
	fclose(old_data_file);

	return 0;
}

int main(int argc, char** argv){

	if(argc < 2){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [number of cpu] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	if(strcmp(argv[1], "../plot/data_physical_cpu.dat") && strcmp(argv[1], "../plot/data_logical_cpu.dat")){
		fprintf(stderr, "main: invalid data file!\n");
		printf("usage: %s [data_file] [number of cpu] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	char* file = argv[1];
	int number_of_cpu = atoi(argv[2]);

	if(calculate_avrage(number_of_cpu, file) < 0){
		fprintf(stderr, "main: calculate_avrage!\n");
		return FUNC_ERROR;		
	}


	return 0;
}