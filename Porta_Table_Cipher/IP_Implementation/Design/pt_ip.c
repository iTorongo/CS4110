#include "pt_ip.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>

#define KeyLength 18

void porta(uint8_t input, uint8_t *output)
{

#pragma HLS INTERFACE mode=s_axilite port=porta
#pragma HLS INTERFACE mode=s_axilite port=input
#pragma HLS INTERFACE mode=s_axilite port=output
#pragma HLS PIPELINE II = 1
    // MARK:- VARIABLES
    int convertedText = 0;       // To store processed text
    int messageToProcess = 0;    // To calculate and store input text character index, range of 0-25 for a-z
    int keyIndex = 0;

    if (input == ' ')
    {
        *output = ' '; // Handle spacing
    }

    keyIndex = 'm' - 97;
    messageToProcess = ((input >= 65 && input <= 90) ? (input - 65) : (input - 97));


    // Encryption/Decryption Process:-
    /// We figured out a formula for the encryption and decryption of the porta table cipher
    /// The same formula works for both encryption and decryption as they are basically same for this cipher
    /// The formula:- 
    /// If message < 13 { return 13 + (message - (k/2)) mod 13}
    /// else {return (message + (k/2)) mod 13}
    /// message and key both are considered index of respective character. e.g. a-0, b=1, z=25

    if (messageToProcess < 13)
    { // if message index < 13
        int mod = 0;
        int difference = messageToProcess - (keyIndex / 2);
        if (difference > 0)
        {
            convertedText = 13 + (difference % 13);
        }
        else
        {
            convertedText = 13 + (difference + 13);
        }
    }
    else
    {
        convertedText = (messageToProcess + (keyIndex / 2)) % 13; // if message index >= 13
    }

    // Handling uppercase/lowercase input
    convertedText = (input >= 65 && input <= 90) ? (convertedText + 'A') : (convertedText + 'a');

    *output = (char)convertedText; // Assiging converted text input output text based on index
    return;
}

