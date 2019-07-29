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

int get_number_of_line(int file_sep, int delta){
	if( file_sep == delta ){
		return 0;
	}
	else{
		if( delta < file_sep ){
			return file_sep;
		}
		else{
			if( delta % file_sep == 0 ){
				return delta / file_sep;
			}
			else{
				return FUNC_ERROR;
			}
		}
	}
}

int moyenne_glissante(char* data_file_name, int number_line, int colomun){
	FILE* old_data_file;
	FILE* new_data_file;
	char * line = NULL;
	char * _line = NULL;
    size_t len = 0;
    size_t _len = 0;
    int read, _read;
    int read_at;

	if( data_file_name == NULL ){
		fprintf(stderr, "moyenne_glissante: invalid argument!\n");
		return FUNC_ERROR;
	}

	old_data_file=fopen(data_file_name, "r+");
	new_data_file=fopen("../plot/moyenne_glissante_on_off.dat", "w+");

	if( old_data_file == NULL || new_data_file == NULL ){
		fprintf(stderr, "moyenne_glissante: can't open file !\n");
		return FUNC_ERROR;
	}

	fprintf(new_data_file, "t power \n");

	getline(&line, &len, old_data_file);

	read_at = 0;
	while( (read = getline(&line, &len, old_data_file)) != -1 ){
		read_at = ftell(old_data_file);
		
		char** tokens = str_split(line, ' ');
		if(tokens){	
			int time = atoi(*(tokens + 0));
			
			if(*(tokens + colomun) == NULL){
				fprintf(stderr, "moyenne_glissante: can't find data colomun !\n");
				return FUNC_ERROR;			
			}
			
			float value = atof(*(tokens + colomun));

			int i = 0;
			while( ((_read = getline(&_line, &_len, old_data_file)) != -1) && ( i < number_line - 1 ) ){
				char** _tokens = str_split(_line, ' ');
				if(_tokens){	
					if(*(_tokens + colomun) == NULL){
						fprintf(stderr, "moyenne_glissante: can't find data colomun !\n");
						return FUNC_ERROR;			
					}
					
					float _v = atof(*(_tokens + colomun));
					
					value += _v;
				}
				i++;
			}

			fprintf(new_data_file, "%d %f\n", time, (value / number_line) );
		}
		
		fseek(old_data_file, read_at, SEEK_SET);
	}

	if (line)
		free(line);
	fclose(new_data_file);
	fclose(old_data_file);

	return 0;
}

int main(int argc, char** argv){

	if(argc < 4){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [interval fichier] [delta] [colomun]..\n", argv[0]);
		return FUNC_ERROR;
	}

	char* data_file_name = argv[1];
	int file_sep = atoi(argv[2]);
	int delta = atoi(argv[3]);
	int colomun = atoi(argv[4]);

	int number_line = get_number_of_line(file_sep, delta);

	if( number_line < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		printf("usage: %s [data_file] [integer] [integer] [integer]..\n", argv[0]);
		return FUNC_ERROR;
	}

	if( moyenne_glissante(data_file_name, number_line, colomun) < 0 ){
		fprintf(stderr, "main: invalid argument!\n");
		return FUNC_ERROR;
	}

	return 0;
}
