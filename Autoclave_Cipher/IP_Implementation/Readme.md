
# IP Implementation of Autoclave Cipher


### This is a step by step guide to recreate the project in Vitis HLS 2021.1
---




## Steps

- Create a new Vitis HLS Project

  - Open Vitis HLS 2021.1 to create a new project
  - In the first wizard, click **Next**
  - In the next screen, provide a project name of your choice and select the project location
  - Check **Create project subdirectory** to make sure keeping all the project files under a child folder, and click **Next**
  - In the **Add/Romeve design Files** screen no need to add anything just click **Next** and Same for **Add/Romeve Testbench Files** screen, just click **Next**
  - Now In the **Solution Configuration** screen, write a solution Name or leave it as it is.
  
  - Clilck three dot button in the right hand side from the **Part Selection** which is in the same window, it will show the **Device Selection Dialog**.
  - select **Boards** button, and in the search bar, type **Zybo** board or Scroll down the boards to find the  **Zybo** board , select it and click **OK**.
  - If the board is not showing in the list, download the boards manually from here Link and add this to the boards repository.
  - Click **Finish** in the project summary screen.

- Download the source files

  - The Software implementation folder contains two subfolders - Design and Testbench. 
  - Download and keep them somewhere on your computer.

- Add Design Sources
  
  - Right click on the **Source** on the Explorer window and click **New Files or Add Files**.

  - Go to the location where you kept the source files downloaded in the earlier step, find the **Design** folder, select all of the files from that folder, and click **Open**. 

  - Then Right click on the **Test Bench** on the Explorer window and click **New Files or Add Files**, Select **autoclave_tv.c** from the **Testbench** folder and click **Open**.

  - Click **project** and select **Project setting**. In the **Project setting** window click **Synthesis** and select **autoclave_ip.c** , click **Browse** button and select **autoclave_en(autoclave_ip.c)** for Encryption or select **autoclave_de(autoclave_ip.c)** for Decryption , then click **OK**.

- Simulation & Synthesis

  - In the **Flow Navigator** window on the left, click **Run C Simulation** and then click **OK** on the popup screen.

  - **C Simulation** will run for a while and should show Finished C Simulation in the console with the encoded and decoded message.

  - Now **Run C Synthesis** from the same window and click **OK** . make sure the board is **Zybo(xc7z010clg400-1)**.

  - **C Synthesis** also take some time to run and should show Finished C Synthesis in the console.

  - You can view the summary in the **Synthesis summary** tab.

- Exporting RTL as IP 
  - In the **Flow Navigator** window press **Export RTL**, save the zip file in an appropriate location and click **OK**.

  - After sometime the console will show the message **Finished Export RTL/implementation**.
  
  - From the **Flow Navigator** window go to the **C/RTL COSIMULATION** section and click **Run Cosimulation**.

  - In the **Co-Simulation** dialog make sure that **Vivado XSIM** is **Verilog** and click **OK**.
  - When the Cosimulation is done you can see the waveform of the output.

- Hardware settup 
  - Open up Vivado , create a **New project** name it, select a location as the done in **HW implementation**.
  - Make sure to select the **Zybo** board.

- Block Design
  - In the **Flow Navigator** window on the left , go to **IP INTEGRATION** and click **Create Block Design**, click **OK**.
  - From the **Diagram** window  press teh **+** button  to add IP.

  - Search for **ZYNQ7 Processing System** and double click on it.

  - Again go to **Flow Navigator** window , under **PROJECT MANAGEMENT** click **IP catalog**.
  - Double click anywhere in the **IP CATALOG** tab  and select **Add repository**, select the folder which we exported earlier as a zip file (First unzip it), In our case it is **autoclave_en**.
  - Expand Usr repository and double click to **autoclave_en**, it will open a popup window, click **Add IP to Block Design**.
  - Now Click **Run Block Automation** and then click **OK** in the new popup window.
  - Click **Run Connection Automation** and **OK**. 
  - You can see the whole**Diagram** in Diagram Tab if everything is correct.
  - Right click in the Diagram and select **Validate Design**, click **OK**.

- HDL Wrapper
  - Form the **BLOCK DESIGN** window select the source file under the **Design Sources**.

  - Right click on the design file and Clilck **Create HDL Wrapper...**.

  - It will open a popup window , Select **Let Vivado manage wrapper and auto-update** and click **OK**.


- Generate bitstream

  - In the left **Project Manager** window, on the bottom under **Program and Debug** select **Generate Bitstream**, and then **Yes -> OK**
  - This step will take some time, depending on your computer's configuration.

  - Once bitstream generation completes a success screen should popup saying **Bitstream Generation successfully completed**.
  
- Export Hardware Platform

  - Click **File** in the top left corner select **Export** and choose **Export Hardware..**.

  - It will show a new popup screen , just click **Next** , then select **Include bitstream** and click **Next**.

  - Now write the name of the Hardware file and locate it a suitable place. then click **Finish**.
  - It would be a **.XSA** file.





