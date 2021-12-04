
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


#define MAX_TEXT_SIZE 200 // Max text size
#define DECRYPTION_KEY "bswpjan" // Hardcoded key for decryption process
#define DECRYPTION_KEY_LENTH 24 // Hardcoded key length


/***************************************************************************
* Return the encrypted text generated with the help of the key
* @param	Key, Plain text and Cipher text
* @return	Cipher text
****************************************************************************/
void encrypt(const char* key, char* plainText, char* encryptedText) {

	// MARK:- VARIABLES

	int plaintextIndex = 0; // To keep track of plaintext character index within the plaintext
    int cipherText = 0; // To store cipher text
	int messageToEncrypt = 0; // To calculate and store plain text character index, range of 0-25 for a-z
	int keyIndex = 0; // To store the key index, range of 0-25 for a-z


	for (plaintextIndex = 0; plainText[plaintextIndex] != '\0'; plaintextIndex++) {
		if(plainText[plaintextIndex] == ' ') {
			encryptedText[plaintextIndex] = ' '; // Handle the space
			continue;
		}

        // Handling Uppercase
		/// If plaintext is uppercase [A-Z], 65 is substracted to convert it into 0-25 index for simplified calculation
		/// If plaintext is lowercase [a-z], 97 is substracted to convert it into 0-25 index for simplified calculation
        if isupper(plainText[plaintextIndex]) {
            messageToEncrypt = plainText[plaintextIndex] - 65;
        } else {
            messageToEncrypt = plainText[plaintextIndex] - 97;
        }

		// Handle key index conversion
		/// Considering key will be always lowercased based on the calculations, 97 is substracted to convert it into 0-25 index for simplified calculation
        if (key > 25) {
         	keyIndex = key - 97;
        } else {
			keyIndex = key;
		}

		// The encryption equation:- (Pi + Ki)
		/// Pi = Index of plaintext character at i position, Ki = Index of key character at i position
		// In Autoclave cipher encryption - The ciphertext becomes the key for the next plaintext encryption
		/// Hence once encryption of a plaintext is complete, the key is updated with the encrypted message
        cipherText = messageToEncrypt + keyIndex;
        if (cipherText > 25) {
            cipherText = cipherText - 26;
        }
        key = cipherText; // Update the key

		// Handling uppercase/lowercase input
        if isupper(plainText[plaintextIndex]) {
            cipherText = cipherText + 'A'; // If uppercase
        } else {
            cipherText = cipherText + 'a'; // If lowercase
        }
		
		encryptedText[plaintextIndex] = (char)cipherText; // Assiging ciphertext character
	}
	encryptedText[plaintextIndex] = '\0';
	return;
}


/***************************************************************************
* Return the plaintext text generated with the help of the key
* @param	Cipher text and Plain text
* @return	Plain text
****************************************************************************/

void decrypt(const char* cipherText, char* decryptedText) {

	// MARK:- VARIABLES

	char key[DECRYPTION_KEY_LENTH] = DECRYPTION_KEY; // Assign hardcoded key to the variable
	int cipherTextIndex, keyCounter = 0; // Necessary counter variables
    int plainText = 0; // To store plaintext
	int messageToDecrypt = 0; // // To calculate and store cipher text character index, range of 0-25 for a-z

	for (cipherTextIndex = 0; cipherText[cipherTextIndex] != '\0'; cipherTextIndex++) {
		if(cipherText[cipherTextIndex] == ' ') {
			decryptedText[cipherTextIndex] = ' '; // Handle spacing
			continue;
		}

        // Handling Uppercase
		/// If plaintext is uppercase [A-Z], 65 is substracted to convert it into 0-25 index for simplified calculation
		/// If plaintext is lowercase [a-z], 97 is substracted to convert it into 0-25 index for simplified calculation
        if isupper(cipherText[cipherTextIndex]) {
            messageToDecrypt = cipherText[cipherTextIndex] - 65;
        } else {
            messageToDecrypt = cipherText[cipherTextIndex] - 97;
        }

		// Handle key index conversion
		/// Since key is hardcoded and lowercase is used, 97 is substracted to convert it into 0-25 index for simplified calculation
        int keyIndex = key[keyCounter] - 97;


		// The decryption equation:- (Ci - Ki)
		/// Ci = Index of ciphertext character at i position, Ki = Index of key character at i position
        plainText = messageToDecrypt - keyIndex;
        if (plainText < 0) {
            plainText = plainText + 26;
        }

		// Handling uppercase/lowercase input
        if isupper(cipherText[cipherTextIndex]) {
            plainText = plainText + 'A'; // if uppercase
        } else {
            plainText = plainText + 'a'; // if lowercase
        }

		decryptedText[cipherTextIndex] = (char)plainText; // Assiging plaintext character
		keyCounter++;
		keyCounter = (keyCounter > DECRYPTION_KEY_LENTH-1) ? 0 : keyCounter; // If keyCounter greated than predefined key length make the keyCounter to 0, else keyCounter will remain same
	}
	decryptedText[cipherTextIndex] = '\0';
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
			    encrypt(key, inputText, convertedText); // Encryption method - Key, inputText and convertedText variables are passed as arguments.
				printf("\r\nThe cipher text:\r\n");
				printf("%s", convertedText); // prints cipher text. 
			}
			else {
			    decrypt(inputText, convertedText); // Decryption method - inputText and convertedText variables are passed as arguments.
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
