
#include "autoclave_ip.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>


void autoclave_en(uint8_t input, uint8_t *output)
{

#pragma HLS INTERFACE mode=s_axilite port=autoclave_en
#pragma HLS INTERFACE mode=s_axilite port=input
#pragma HLS INTERFACE mode=s_axilite port=output
#pragma HLS PIPELINE II = 1

	// MARK:- VARIABLES
    int convertedText = 0; 
    int keyIndex = 0;

    if (input == ' ')
    {
        *output = ' '; // Handle spacing
    }

    keyIndex = 'b' - 97; // A hardcoded key 'b' is used for design purpose

    // Encryption: Ci + Ki
    /// Ci = Input cipher character
    /// Ki = Key
    convertedText = (input >= 65 && input <= 90) ? (input - 65) : (input - 97) + keyIndex;
    convertedText = (convertedText > 25) ? (convertedText - 26): convertedText;
    convertedText = (input >= 65 && input <= 90) ? (convertedText + 'A') : (convertedText + 'a');

    *output = (char)convertedText;  // Assiging converted text input output text based on index
    return;
}


void autoclave_de(uint8_t input, uint8_t *output)
{

#pragma HLS INTERFACE mode=s_axilite port=autoclave_en
#pragma HLS INTERFACE mode=s_axilite port=input
#pragma HLS INTERFACE mode=s_axilite port=output
#pragma HLS PIPELINE II = 1

	// MARK:- VARIABLES
    int convertedText = 0;
    int keyIndex = 0;

    if (input == ' ')
    {
        *output = ' '; // Handle spacing
    }

    keyIndex = 'b' - 97; // A hardcoded key 'b' is used for design purpose

    // Decryption: Ci - Ki
    /// Ci = Input cipher character
    /// Ki = Key
    convertedText = (input >= 65 && input <= 90) ? (input - 65) : (input - 97) - keyIndex;
    convertedText = (convertedText < 0) ? (convertedText + 26) : convertedText;

    // Handling uppercase/lowercase input
    convertedText = (input >= 65 && input <= 90) ? (convertedText + 'A') : (convertedText + 'a');

    *output = (char)convertedText; // Assiging converted text input output text based on index
    return;
}

