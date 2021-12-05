
/****************************************************************************
		Candiate No - 8019, 8012, 8007, 8026
* @file     AutoclaveCipherSW.c
*
* This file contains the software implementation of the Autoclave Cipher.
*
****************************************************************************/

#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <ctype.h>
#include <stdbool.h>


#define MAX_TEXT_SIZE 200 // Max text size

/***************************************************************************
* Return the encrypted/decrypted text generated with the help of the key
* @param	Encryption or Decryption Key, Input text and Output text
* @return	Cipher/Plain text
****************************************************************************/
void encryptDecrypt(const bool isEncrypt, char* key, char* inputText, char* outputText) {

	// MARK:- VARIABLES

	int inputTextIndex = 0; // To keep track of input plain/cipher text character index within the plain/cipher text
    int processedText = 0; // To store cipher text
	int messageToProcess = 0; // To calculate and store plain/cipher text character index, range of 0-25 for a-z
	int keyIndex = 0; // To store the key index, range of 0-25 for a-z


	for (inputTextIndex = 0; inputText[inputTextIndex] != '\0'; inputTextIndex++) {
		if(inputText[inputTextIndex] == ' ') {
			outputText[inputTextIndex] = ' '; // Handle the space
			continue;
		}

        // Handling Uppercase
		/// If plaintext is uppercase [A-Z], 65 is substracted to convert it into 0-25 index for simplified calculation
		/// If plaintext is lowercase [a-z], 97 is substracted to convert it into 0-25 index for simplified calculation
        if isupper(inputText[inputTextIndex]) {
            messageToProcess = inputText[inputTextIndex] - 65;
        } else {
            messageToProcess = inputText[inputTextIndex] - 97;
        }

		// Handle key index conversion
		/// Considering key will be always lowercased, 97 is substracted to convert it into 0-25 index for simplified calculation
        if (key > 25) {
         	keyIndex = key - 97;
        } else {
			keyIndex = key;
		}

		// The encryption equation:- (Pi + Ki)
		/// Pi = Index of plaintext character at i position, Ki = Index of key character at i position
		// In Autoclave cipher encryption - The ciphertext becomes the key for the next plaintext encryption
		/// Hence once encryption of a plaintext is complete, the key is updated with the encrypted message

		// The decryption equation:- (Ci - Ki)
		/// Ci = Index of ciphertext character at i position, Ki = Index of key character at i position
		/// In Autoclave cipher decryption - The ciphertext becomes the key for the next ciphertext decryption
		/// e.g. if key b is used to decrypt message swpjan, first 'b' will be used for 's' to decrypt, then 's' will be used as key to decrypt next plaintext 'w' and so on
		/// Hence once decryption of a ciphertext is complete, the key is updated with the ciphertext - the one just decrypted
        
		if (isEncrypt) {
			processedText = messageToProcess + keyIndex;
			if (processedText > 25) {
            	processedText = processedText - 26;
        	}
        	key = processedText; // Update the key
		} else {
			processedText = messageToProcess - keyIndex;
			if (processedText < 0) {
            	processedText = processedText + 26;
        	}
        	key = inputText[inputTextIndex]; // Update the key
		}

		// Handling uppercase/lowercase input
        if isupper(inputText[inputTextIndex]) {
            processedText = processedText + 'A'; // If uppercase
        } else {
            processedText = processedText + 'a'; // If lowercase
        }
		
		outputText[inputTextIndex] = (char)processedText; // Assiging processedText character
	}
	outputText[inputTextIndex] = '\0';
	return;
}



/***************************************************************************
* Main function to take user inputs and encrypt/decrypt them based on selection
* @param	None
* @return	None
****************************************************************************/
int main() {

	// MARK:- VARIABLES
	char inputText[MAX_TEXT_SIZE] = {'\0'}; // To store inserted text from user
	char convertedText[MAX_TEXT_SIZE] = {'\0'}; // To store converted text
	char selection = '\0'; // To store users selection
	char key = 'b'; // Hardcoded key 'b' for encryption 
	
	while (1) {
		char temp; 
		while (selection != 'e' && selection != 'd' && selection != 'q') {
			printf("\n****Autoclave Cipher****\nPress 'e' for encrypt or 'd' for decrypt, 'q' for quit: "); 
			scanf("%c%c", &selection, &temp);
		}
		if (selection == 'q') {
			printf("\n Program finished.");
			return 0;
		}
		// Handle the selection
		/// e = encryption; d = decryption
		if (selection == 'e' || selection == 'd' ) {
			if (selection == 'e') {
				printf("\r\nEnter the plain text:\r\n");
			}
			else {
				printf("\r\nEnter the cipher text:\r\n");
			}

			int i = 0;
			while((temp = getchar())) {
                if ( (temp >= 'A' && temp <= 'Z') || (temp >= 'a' && temp <= 'z') || temp == ' ' ) {
                    inputText[i] = temp;
                } else {
					// Handle new line and carriage return
					/// If none of those, it's invalid input as we will encrypt/decrypt a-z and A-Z
                    if (temp == '\n' || temp == '\r') {
                        inputText[i]='\0';
                        break;
                    } else {
                        printf("Please enter valid characters e.g [a-z or A-Z]\r\n");
				        continue;
                    }
                }

				inputText[i] = temp;
				i++;
				if ( i == MAX_TEXT_SIZE -2 ) {
					printf("max size reached\r\n");
					i++;
					inputText[i]='\0';
					break;
				}
			}
			
			// Encryption/Decryption
			if (selection == 'e') {
				printf("\r\nThe plain text:\r\n");
			}
			else {
				printf("\r\nThe cipher text:\r\n");
				
			}
			printf("%s", inputText);
			
			// Encryption/Decryption
			if (selection == 'e') {
			    encryptDecrypt(true, key, inputText, convertedText); // Encryption method - Key, inputText and convertedText variables are passed as arguments.
				printf("\r\nThe cipher text:\r\n");
				printf("%s", convertedText); // prints cipher text. 
			}
			else {
			    encryptDecrypt(false, key, inputText, convertedText); // Decryption method - inputText and convertedText variables are passed as arguments.
				printf("\r\nThe plain text:\r\n");
				printf("%s", convertedText); // prints plain text
			    
			}
			printf("\r\n");
		}
		selection = '\0';
	}
	return 0;
	cleanup_platform();
}
