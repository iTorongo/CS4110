

#include "autoclave_ip.h"
#include <stdio.h>

int main()
{
	uint8_t in_en = 'a';
	uint8_t in_de = 'a';
	uint8_t out;

	printf("Encode: \n");
	printf("Output: ");
	for (int i = 0; i < 10; i++)
	{
		autoclave(true, in_en++, &out);
		printf("%c", (char)out);
	}
	printf("\n");

	printf("\nDecode: ");
	printf("\nOutput: ");
	for (int j = 0; j < 10; j++)
	{
		autoclave(false, in_de++, &out);
		printf("%c", (char)out);
	}
	printf("\n");
	return 0;
}
