
#include "autoclave_ip.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdbool.h>

void autoclave(bool enc, uint8_t input, uint8_t *output)
{

#pragma HLS INTERFACE mode = s_axilite port = autoclave
#pragma HLS INTERFACE mode = s_axilite port = enc
#pragma HLS INTERFACE mode = s_axilite port = input
#pragma HLS INTERFACE mode = s_axilite port = output
#pragma HLS PIPELINE II = 1

    // MARK:- VARIABLES
    int convertedText = 0; // To store processed text
    int keyIndex = 0;

    if (input == ' ')
    {
        *output = ' '; // Handle spacing
    }

    keyIndex = 'b' - 97;

    if (enc)
    { // Encode
        convertedText = (input >= 65 && input <= 90) ? (input - 65) : (input - 97) + keyIndex;
        convertedText = (convertedText > 25) ? (convertedText - 26) : convertedText;
    }
    else
    { // Decode
        convertedText = (input >= 65 && input <= 90) ? (input - 65) : (input - 97) - keyIndex;
        convertedText = (convertedText < 0) ? (convertedText + 26) : convertedText;
    }

    // Handling uppercase/lowercase input
    convertedText = (input >= 65 && input <= 90) ? (convertedText + 'A') : (convertedText + 'a');

    *output = (char)convertedText; // Assiging converted text input output text based on index
    return;
}
