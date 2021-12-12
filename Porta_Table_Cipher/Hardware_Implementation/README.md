# Hardware Implementation of the Porta Table Cipher
### This is a step by step guide to recreate the project in Vivado 2021.1
---




## Steps

- Create a new Vivado Project

  - Open Vivado 2021.1 to create a new project.
  - In the first wizard, click **Next**.
  - In the next screen, provide a project name of your choice and select the project location.
  - Check **Create project subdirectory** to make sure keeping all the project files under a child folder, and click **Next**.
  - Choose **RTL Project** and check **Do not specify sources at this time** as we are going to add sources later, click **Next**.
  - In the **Default Part** screen, select **Boards** button, and in the search bar, type **Basys3** board, select it and click **Next**.
  - If the board is not showing in the list, click **Refresh** on the bottom-left and download the board.
  - Click **Finish** in the project summary screen.

- Download the source files

  - The hardware implementation folder contains three subfolders - Design, Testbench, and Constraints. 
  - Download and keep them somewhere on your computer.

- Add Design Sources
  
  - Click on the **+** on the sources window, or from the **Project Manager** window on the left, click **Add Sources**.
  - In the add sources wizard, select **Add or create design sources** and click **Next**.
  - Click either **+** on the left top corner or click **Add Files** from bottom.
  - Go to the location where you kept the source files downloaded in the earlier step, find the **Design** folder, select all of the files from that folder, and click **Open**.
  - Click **Finish** and wait for some time to finish adding the design files to your project.

- Synthesis

  - In the **Project Manager** window on the left, click **Run Synthesis** option under **Synthesis** and click **OK** on the popup screen.
  - **Synthesis** will run for a while and should show **Synthesis successfully completed**.
  - You can view the **Scematic** by expanding **Open Synthesized Design** under **Synthesis**. 


- Add Simulation Sources
  
  - Click on the **+** on the sources window, or from the **Project Manager** window on the left, click **Add Sources**.
  - In the add sources wizard, select **Add or create simulation sources** and click **Next**.
  - Click either **+** on the left top corner or click **Add Files** from bottom.
  - Go to the location where you kept the source files downloaded in earlier step, find the **Testbench** folder, select **porta_tb.vhd** file from that folder, and click **Open**.
  - Click **Finish** and wait for some time to finish adding the simulation file to your project.


- Simulation

  - In the **Project Manager** window on the left, click **Run Simulation** and then **Run Behavioural Simulation** option under **Simulation**.
  - **Simulation** will run for a while and should show the waveform of the simulation. 


- Add Constraints Sources
  
  - Click on the **+** on the sources window, or from the **Project Manager** window on the left, click **Add Sources**.
  - In the add sources wizard, select **Add or create constraints** and click **Next**.
  - Click either **+** on the left top corner or click **Add Files** from bottom.
  - Go to the location where you kept the source files downloaded in earlier step, find the **Constraints** folder, select **porta.xdc** from that folder, and click **Open**.
  - Click **Finish** and wait for some time to finish adding the constraints file to your project.

- Connect Basys3 Board
  - Connect **Basys3** Board with your computer using the standard USB cable. 
  - Power on the board.

- Generate bitstream

  - In the left **Project Manager** window, on the bottom under **Program and Debug** select **Generate Bitstream** and then **Yes -> OK**.
  - This step will take some time, depending on your computer's configuration.
  - Once bitstream generation completes a success screen should popup saying **Bitstream Generation successfully completed**.
  - Select **Open Hardware Manager** from that screen, and click **OK**.
  - Select **Open Target -> Auto Connect** on the Hardware Manager window.
  - Select **Program device** and in the pop-up window, make sure the **Birstream file** has the correct location of the generated bitstream. The file should end with **porta.bi**.
  - Click **Program**.
  - At this point, if everything is completed as expected, the **Basys3 Board** should be programmed successfully.


- PuTTY Configuration

  - Download **PuTTY** from here: https://www.putty.org/
  - Open the **Device Manager** on your computer, and find the port for serial communication under **Ports(COM & LPT**. It should be something like **COM4/6** or so on. Just keep it noted.
  - Open **PuTTY** you should be on the **Session** tab with a page called **Basic options for your PuTTY session** on the top. 
  - Select **Serial** and enter your port name (e.g. COM4) in the **Serial line** field and **19200** in the **Speed** field. 
  - Select **Terminal** on the left side under the **Category** and select **Force on** for **Local echo**.
  - Select **Serial** under **Connection** on the left, and select **Flow Control** to **None**.
  - Click **Open** and this should open the PuTTY Terminal.


- Encryption and Decryption Operation

  - on the PuTTY terminal, typing **"Chief"** followed by the **Enter** from your keyboard should show cipher text **"Wqzvq"**.
  - And, typing **"Wqzvq"** followed by the **Enter** from your keyboard should show cipher text **"Chief"**.
  - The encryption and decryption method of the Porta Table Cipher is the same. Hence, the implementation contains only one mode which served both of the operations.


---





