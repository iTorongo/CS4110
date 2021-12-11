
# Complete Steps of running a Vivado project.


## Step by step guide .

1. Open up Vivado and choose Create Project.
2. Write an appropriate name of the project and select a location.
3. Choose RTL Project and tick mark "Do not specify sources at this time" and click next.
4. Choose Boards from the Defaul part and choose Basys3 Board then click next and finish.
5. On the left sidebar of project window click PROJECT MANAGER 
6. Now click Add Sources and choose "Add or create design sources" then click next.
7. Click Add files and Select all design files except tb and xdc file then click finish.
8. Then again in the left sidebar in SYNTHESIS section click "Run Synthesis" and click OK.
9. After completed Synthesis click  Add sources and choose "Add or create simulation sources" then click next.
10. Now click Add Files and choose the testbench file ("_tb.vhd") and click finish.
11. On the left sidebar in SIMULATION section click Run simulation and choose "Run Behavioral Simulation".
12. After simulation, again from PROJECT MANAGER click add sources and choose the constraints file (".xdc") then add the .xdc file and finish.
13. Now from the left sidebar click PROGRAM AND DEBUG section and click Generate Bitstream then click OK.
14. After generated Btstream now conncet the Basys3 Device with the computer and select Open Hardware Manager form the PROGRAM AND DEBUG section.
15. Click Open Target and choose Auto Connect.
16. Configure Putty and Run the program.





