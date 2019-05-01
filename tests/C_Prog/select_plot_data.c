#include<stdio.h>
#include<stdlib.h>
#include <unistd.h>
#include <string.h>

#define FUNC_ERROR -1

int search_cpu(char* cpu, char** cpus, int noc){
	int find = 0;
	if( (cpu == NULL) || (cpus == NULL) ){
		fprintf(stderr, "search_cpu: invalid argument!\n");
		return FUNC_ERROR;
	}

	for(int i = 2; i < noc + 2 && !find; i++){
		if(!strcmp(cpu, cpus[i])){
			find = 1;
		}
	}
	return find;
}

int* get_index_cpu(char* file, int noc, char** cpus){
	int* tab_index = malloc( sizeof(int) * noc );
	FILE* data_file;
	char * line = NULL;
    size_t len = 0;

	if(tab_index == NULL){
		fprintf(stderr, "get_index_cpu: malloc error!\n");
		return NULL;
	}

	if( (file == NULL) || (cpus == NULL) ){
		fprintf(stderr, "get_index_cpu: invalid argument!\n");
		return NULL;
	}

	data_file = fopen(file, "r+");

	if(data_file == NULL){
		fprintf(stderr, "get_index_cpu: can not open data file!\n");
		return NULL;
	}

	getline(&line, &len, data_file);
	if(line == NULL || len == 0){
		fprintf(stderr, "get_index_cpu: data file NULL!\n");
		return NULL;
	}

	char delim[2] = " ";
	char* tok = strtok(line, delim);
	int index, i = 0;
	while(tok != NULL) {
		if(strcmp(tok, "t") && strcmp(tok, "\n") && search_cpu(tok, cpus, noc)){
			tab_index[i] = index;
			i++;
		}
		tok = strtok(NULL, delim);
		index++;
	}

	fclose(data_file);
	return tab_index;
}

char* get_new_file_name(int noc, char* old_file_name, char** cpus){
	char* new_file_name;

	if( (old_file_name == NULL) || (cpus == NULL) ){
		fprintf(stderr, "new_file_name: invalid argument!\n");
		return NULL;
	}

	int len = strlen(old_file_name);
	for(int i = 2; i < noc + 2; i++){
		len += strlen(cpus[i]);
	}

	new_file_name = malloc( sizeof(char) * (len + noc + 2) );
	strcpy(new_file_name, "..");

	char delim[2] = ".";
	char* tok = strtok(old_file_name, delim);
	for(int i = 2; i < noc + 2; i++){
		strcat(tok, "_");
		strcat(tok, cpus[i]);
	}
	strcat(tok, ".dat");
	strcat(new_file_name, tok);

	return new_file_name;
}

int index_in_tab(int index, int* tab_index, int noc){
	int in_tab = 0;

	if( tab_index == NULL ){
		fprintf(stderr, "index_in_tab : tab error!\n");
		return FUNC_ERROR;
	}

	for(int i = 0; i < noc && !in_tab; i++){
		if(tab_index[i] == index){
			in_tab = 1;
		}
	}

	return in_tab;
}

int creat_new_data_file(char* old_file_name, int* tab_index, int noc, char** cpus){
	FILE* old_data_file;
	FILE* new_data_file;
	char * line = NULL;
    size_t len = 0;
    ssize_t read;
    char* buff1;
    char* buff2;

	if( (old_file_name == NULL) || (tab_index == NULL) ){
		fprintf(stderr, "creat_new_data_file: invalid argument!\n");
		return FUNC_ERROR;
	}

	old_data_file=fopen(old_file_name, "r+");
	
	char* new_file_name = get_new_file_name(noc, old_file_name, cpus);
	if( new_file_name == NULL ){
		fprintf(stderr, "creat_new_data_file: new file name NULL!\n");
		return FUNC_ERROR;
	}

	new_data_file=fopen(new_file_name, "w+");

	if( (old_data_file == NULL) || (new_data_file == NULL) ){
		fprintf(stderr, "creat_new_data_file: open file!\n");
		return FUNC_ERROR;
	}

	char delim[2] = " ";
	while((read = getline(&line, &len, old_data_file)) != -1){
		int index = 0;
		char* tok = strtok(line, delim);
		while(tok != NULL) {
			if(strcmp(tok, "\n") && index == 0){
				fprintf(new_data_file, "%s ", tok);
			}
			else if(strcmp(tok, "\n") && index_in_tab(index, tab_index, noc)){
				fprintf(new_data_file, "%s ", tok);
			}
			tok = strtok(NULL, delim);
			index++;
		}
		fprintf(new_data_file, "\n");
	}

	char del[2] = "/";
	char* tok = strtok(new_file_name, del);
	char* file;
	while(tok != NULL) {
		file = tok;
		tok = strtok(NULL, del);
	}

	buff1 = malloc( sizeof(char) * (42 + 1 + 2));
	buff2 = malloc ( sizeof(char) * (42 + 4 + strlen(file)));

	sprintf(buff1, "sed -i -e 's/N/%d/g' ../plot/plot_selected.p", noc + 1);
	sprintf(buff2, "sed -i -e 's/file/%s/g' ../plot/plot_selected.p", file);

	if( (system(buff1) < 0) || (system(buff2) < 0) ){
		fprintf(stderr, "creat_new_data_file: system call!\n");
		return FUNC_ERROR;
	}

	if(line)
		free(line);
	if(buff1)
		free(buff1);
	if(buff2)
		free(buff2);
	fclose(old_data_file);
	fclose(new_data_file);
	return 0;
}

int main(int argc, char** argv){

	if(argc < 2){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [cpu] [cpu1] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	if(argc == 2 && ( !strcmp(argv[1], "../plot/data_physical.dat") || !strcmp(argv[1], "../plot/data_logical.dat") )){
		printf("le fichier existe déjà : %s\n", argv[1]);
		return 0;
	}

	if(strcmp(argv[1], "../plot/data_physical.dat") && strcmp(argv[1], "../plot/data_logical.dat")){
		fprintf(stderr, "main: invalid data file!\n");
		printf("usage: %s [data_file] [cpu] [cpu1] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	char* file = argv[1];

	int number_of_cpu = argc - 2;
	int* tab_index = get_index_cpu(file, number_of_cpu, argv);

	if(creat_new_data_file(file, tab_index, number_of_cpu, argv) < 0){
		fprintf(stderr, "main: creat the new data dile!\n");
		return FUNC_ERROR;
	}

	return 0;
}