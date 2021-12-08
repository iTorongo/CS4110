#include "pt_ip.h"
#include <stdio.h>


int main()
{
	uint8_t in = 'a';
	uint8_t out;
	printf("\nOutput: ");
	for(int i = 0; i < 10; i++)
	{
		porta(in++, &out);
		printf("%c", (char)out);
	}
	printf("\n");
	return 0;
}
