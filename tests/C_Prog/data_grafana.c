#include<stdio.h>
#include<stdlib.h>
#include <unistd.h>
#include <string.h>
#include <assert.h>

#define FUNC_ERROR -1

char** str_split(char* a_str, const char a_delim){
    char** result    = 0;
    size_t count     = 0;
    char* tmp        = a_str;
    char* last_comma = 0;
    char delim[2];
    delim[0] = a_delim;
    delim[1] = 0;

    while (*tmp){
        if (a_delim == *tmp){
            count++;
            last_comma = tmp;
        }
        tmp++;
    }

    count += last_comma < (a_str + strlen(a_str) - 1);

    count++;

    result = malloc(sizeof(char*) * count);

    if (result){
        size_t idx  = 0;
        char* token = strtok(a_str, delim);

        while (token){
            assert(idx < count);
            *(result + idx++) = strdup(token);
            token = strtok(0, delim);
        }
        assert(idx == count - 1);
        *(result + idx) = 0;
    }

	return result;
}

int get_number_of_line(int sec_sug, int sec_sep){
	if( sec_sug == sec_sep ){
		return 0;
	}
	else{
		if( sec_sug < sec_sep ){
			return sec_sep;
		}
		else{
			if( sec_sug % sec_sep == 0 ){
				return sec_sug / sec_sep;
			}
			else{
				return FUNC_ERROR;
			}
		}
	}
}

int create_data_file(char* data_file_name, char* debut, char* fin, int number_line, int interval){
	FILE* old_data_file;
	FILE* new_data_file;
	char * line = NULL;
    size_t len = 0;
    ssize_t read;
    int index = 0;

	if( data_file_name == NULL || debut == NULL || fin == NULL ){
		fprintf(stderr, "create_data_file: invalid argument!\n");
		return FUNC_ERROR;
	}

	old_data_file=fopen(data_file_name, "r+");
	new_data_file=fopen("../plot/power_consumption_grafana.dat", "w+");

	if( old_data_file == NULL || new_data_file == NULL ){
		fprintf(stderr, "create_data_file: can't open file !\n");
		return FUNC_ERROR;
	}

	fprintf(new_data_file, "t power \n");

	getline(&line, &len, old_data_file);
	int read_data = 0;
	int time = 0;
	while((read = getline(&line, &len, old_data_file)) != -1){
		char** tokens = str_split(line, ',');

		if(tokens){
			char* date = *(tokens + 1);
			if( !strcmp(debut, date) ){
				read_data = 1;
			}
			if( read_data ){
				if( index == 0 ){
					double VA = atof(*(tokens + 3));
					double FP = atof(*(tokens + 2));
					
					fprintf(new_data_file, "%d %lf \n", time, FP * VA);

					time+=interval;
				}
				index++;

				if(index == number_line || number_line == 0){
					index = 0;
				}

				if( !strcmp(fin, date) ){
					break;
				}
			}
		}
	}

	if (line)
		free(line);
	fclose(new_data_file);
	fclose(old_data_file);

	return 0;
}

int valid_time(int hh, int min, int sec){
	if( hh > 24 || hh < 0 || min > 60 || min < 0 || sec > 60 || sec < 0 )
		return FUNC_ERROR;
	return 0;
}

int main(int argc, char** argv){

	int hour, min, sec;

	if(argc < 5){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [heure debut] [heure fin] [interval souhaiteé] [interval fichier] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	char* data_file_name = argv[1];
	char* heur_debut = argv[2];
	char* heur_fin = argv[3];
	int sec_sug = atoi(argv[4]);
	int sec_sep = atoi(argv[5]);

	sscanf(heur_debut, "%d:%d:%d", &hour, &min, &sec);

	if( valid_time(hour, min, sec) < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [H:Min:Sec] [H:Min:Sec] [integer] [integer] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	sscanf(heur_fin, "%d:%d:%d", &hour, &min, &sec);

	if( valid_time(hour, min, sec) < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [H:Min:Sec] [H:Min:Sec] [integer] [integer] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	int number_line = get_number_of_line(sec_sug, sec_sep);

	if( number_line < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [H:Min:Sec] [H:Min:Sec] [integer] [integer] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	if( create_data_file(data_file_name, heur_debut, heur_fin, number_line, sec_sug) < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [H:Min:Sec] [H:Min:Sec] [integer] [integer] ..\n", argv[0]);
		return FUNC_ERROR;
	}

	return 0;
}
