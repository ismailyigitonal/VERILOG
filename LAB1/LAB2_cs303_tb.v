module LAB2_cs303_tb();

reg X1,X0,Y1,Y0;  // Inputs are registers.
wire A1,A0;   // Outputs are wires.

LAB2_cs303 dut(X1,X0,Y1,Y0,A1,A0); // Our design-under-test.

initial begin
    //  * Our waveform is saved under this file.
    
    $dumpfile("LAB2_cs303.vcd"); 
    
    // * Get the variables from the module.

    $dumpvars(0,LAB2_cs303_tb);

    $display("Simulation started.");
    X1 = 0;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 0;
    Y0 = 0;
    #10;     // Wait 10 time units.
    X1 = 0;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 0;
    Y0 = 1;
    #10; 
    X1 = 0;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 1;
    Y0 = 0;
    #10;
    X1 = 0;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 1;
    Y0 = 1;
    #10;
    X1 = 0;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 0;
    Y0 = 0;
    #10;
    X1 = 0;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 0;
    Y0 = 1;
    #10;
    X1 = 0;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 1;
    Y0 = 0;
    #10;
    X1 = 0;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 1;
    Y0 = 1;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 0;
    Y0 = 0;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 0;
    Y0 = 1;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 1;
    Y0 = 0;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 0;
    Y1 = 1;
    Y0 = 1;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 0;
    Y0 = 0;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 0;
    Y0 = 1;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 1;
    Y0 = 0;
    #10;
    X1 = 1;  // Set all inputs to zero.
    X0 = 1;
    Y1 = 1;
    Y0 = 1;
    #10;
    $display("Simulation finished.");
    $finish(); // Finish simulation.
end

endmodule