
# Software Implementation of the Autoclave Cipher


### This is a step by step guide to recreate the project in Vitis IDE 2021.1
---




## Steps

- Create a new Vitis IDE Project

  - Open Vitis IDE 2021.1 and locate a suitable possition then click **Launch**.
  - When you go to Weelcome window select **Create Platform Project**.
  - Write a Platform project name and click **Next**.
  - In New Platform project window , under **Hardware Specification** click **Browse** and select the **.XSA** file which we exported earlier in **Vitis HLS** implementation.
  - Make sure that the operating system should be **standalone** and processor should be **ps7_cortexa9_0** under the **Software Specification** section, then click **Finish**.
  - In the Explorer tab  right click on the **Platform project** In our case it is **Autoclave_en** and click **Build Project**.

- Create a new Application Project

  - Click the **File** button , which is in the top-left corner, click **New** and select **Application Project..**
  - Now in the **New Application Project** window select the Platform you created earlier section and click **Next**.
  - Give an appropriate name and click **Next**.
  - Again click **Next**.
  - Select **Hello World** and click **Finish**.
  - Sowap the Content of the **Hello World** file with the Main file. In our case this is **AutoclaveCipherSW.c**.

- Build and Run the Project

  - Go the the **Explorer** tab in the top-left corner, right click your project name (In our case it is **autoclave**) under the **autoclave_system** section and select **Build Project**
  - Remember to set the boot mode jumper [(21 in the Figure)](https://digilent.com/reference/_media/reference/programmable-logic/zybo-z7/zybo-z7-callout.png?cache=) to JTAG mode (to the far right).
  - Right click your project again and select **Run As** --> **Launch Hardware**.
  - PuTTY will connect with your running application on the Zybo.

- PuTTY Configuration
  - Download PuTTY from here: https://www.putty.org/
  - Open the Device Manager on your computer, and find the port for serial communication under Ports(COM & LPT. It should be something like COM4/6 or so on. Just keep it noted.
  - Open PuTTY you should be on the Session tab with a page called Basic options for your PuTTY session on the top.
  - Select Serial and enter your port name (e.g. COM4) in the Serial line field and 19200 in the Speed field.
  - Select Terminal on the left side under the Category and select Force on for Local echo.
  - Select Serial under Connection on the left, and select Flow Control to None.
  - Click Open and this should open the PuTTY Terminal.

- Encryption and Decryption Operation
 
  - When opened terminal, you should see a message **Press 'e' for encrypt or 'd' for decrypt, 'q' for quit**.
  - If type **e** and **Enter**,  PuTTY Terminal should asked for the **Plain text** to encode or if type **d** and **Enter** it would ask for **Cipher text** to decode or if       type **q** and **Enter** it will show the message **programm finished**.
  - For example if typing **Return** followed by the **Enter** from your keyboard should show cipher text **Swpjan**.
  - And,typing **Swpjan** followed by the **Enter** from your keyboard should show plain text **Return**.
  
 
  
  
