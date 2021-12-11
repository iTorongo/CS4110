/****************************************************************************
		Candiate No - 8019, 8012, 8007, 8026
* @file     PortaTableCipherSW.c
*
* This file contains the software implementation of the Autoclave Cipher.
*
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>

#define MAX_TEXT_SIZE 200                     // Max text size
#define CIPHER_KEY "mistermistermistermister" // Hardcoded key for encryption/decryption process
#define CIPHER_KEY_LEN 24                     // Hardcoded key length

/***************************************************************************
* Return the encrypted/decrypted text generated with the help of the key
* @param	Input text and Output text
* @return	Cipher/Plain text
****************************************************************************/
void encryptDecrypt(const char *inputText, char *outputText)
{
    // MARK:- VARIABLES
    char key[CIPHER_KEY_LEN] = CIPHER_KEY; // Assign hardcoded key to the variable
    int inputTextCounter, keyCounter = 0;  // Necessary counter variables
    int convertedText = 0;                 // To store processed text
    int messageToProcess = 0;              // To calculate and store input text character index, range of 0-25 for a-z

    for (inputTextCounter = 0; inputText[inputTextCounter] != '\0'; inputTextCounter++)
    {
        if (inputText[inputTextCounter] == ' ')
        {
            outputText[inputTextCounter] = ' '; // Handle spacing
            continue;
        }

        // Handling Uppercase
        /// If inputtext is uppercase [A-Z], 65 is substracted to convert it into 0-25 index for simplified calculation
        /// If inputtext is lowercase [a-z], 97 is substracted to convert it into 0-25 index for simplified calculation
        if isupper (inputText[inputTextCounter])
        {
            messageToProcess = inputText[inputTextCounter] - 65;
        }
        else
        {
            messageToProcess = inputText[inputTextCounter] - 97;
        }

        // Handle key index conversion
        /// Considering key will be always lowercased as its hardcoded, 97 is substracted to convert it into 0-25 index for simplified calculation
        int keyIndex = key[keyCounter] - 97;

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
            convertedText = 13 + (difference + 13) % 13;
        }
        else
        {
            convertedText = (messageToProcess + (keyIndex / 2)) % 13; // if message index >= 13
        }

        // Handling uppercase/lowercase input
        if isupper (inputText[inputTextCounter])
        {
            convertedText = convertedText + 'A'; // If uppercase
        }
        else
        {
            convertedText = convertedText + 'a'; // If lowercase
        }

        outputText[inputTextCounter] = (char)convertedText; // Assiging converted text input output text based on index
        keyCounter++;
        keyCounter = (keyCounter > CIPHER_KEY_LEN - 1) ? 0 : keyCounter; // If keyCounter greated than predefined key length make the keyCounter to 0, else keyCounter will remain same
    }
    outputText[inputTextCounter] = '\0';
    return;
}

/***************************************************************************
* Main function to take user inputs and encrypt/decrypt them based on selection
* @param	None
* @return	None
****************************************************************************/
int main()
{

    // MARK:- VARIABLES
    char inputText[MAX_TEXT_SIZE] = {'\0'};     // To store inserted text from user
    char convertedText[MAX_TEXT_SIZE] = {'\0'}; // To store converted text
    char selection = '\0';                      // To store users selection
    while (1)
    {
        char temp;
        while (selection != 'e' && selection != 'd' && selection != 'q')
        {
            printf("\n****Porta Table Cipher****\nPress 'e' for encrypt or 'd' for decrypt, 'q' for quit: "); // this printfs twice after first selection
            scanf("%c%c", &selection, &temp);
        }
        if (selection == 'q')
        {
            printf("\n Program finished.");
            return 0;
        }

        // Handle the selection
        /// e = encryption; d = decryption
        if (selection == 'e' || selection == 'd')
        {
            if (selection == 'e')
            {
                printf("\r\nEnter the plain text:\r\n");
            }
            else
            {
                printf("\r\nEnter the cipher text:\r\n");
            }
            int i = 0;
            while ((temp = getchar()))
            {

                if ((temp >= 'A' && temp <= 'Z') || (temp >= 'a' && temp <= 'z') || temp == ' ')
                {
                    inputText[i] = temp;
                }
                else
                {
                    // Handle new line and carriage return
                    /// If none of those, it's invalid input as we will encrypt/decrypt a-z and A-Z
                    if (temp == '\n' || temp == '\r')
                    {
                        inputText[i] = '\0';
                        break;
                    }
                    else
                    {
                        printf("Please enter valid characters e.g [a-z or A-Z]\r\n");
                        continue;
                    }
                }

                inputText[i] = temp;
                i++;
                if (i == MAX_TEXT_SIZE - 2)
                {
                    printf("max size reached\r\n");
                    i++;
                    inputText[i] = '\0';
                    break;
                }
            }

            if (selection == 'e')
            {
                printf("\r\nThe plain text:\r\n");
            }
            else
            {
                printf("\r\nThe cipher text:\r\n");
            }
            printf("%s", inputText);

            // Encryption/Decryption
            /// A single method is called with inputText and convertedText variable as arguments
            /// because the encryption and decryption method is same for this cipher
            /// this method computes the encrypted or decrypted message and returns

            encryptDecrypt(inputText, convertedText);
            if (selection == 'e')
            {
                printf("\r\nThe cipher text:\r\n");
            }
            else
            {
                printf("\r\nThe plain text:\r\n");
            }
            printf("%s", convertedText); // Prints the encrypted/decrypted message
            printf("\r\n");
        }
        selection = '\0';
    }
    return 0;
    cleanup_platform();
}