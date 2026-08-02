`timescale 1ns / 1ps

module tb_spi;

    reg clk;
    reg rst;
    reg start;
    reg [7:0] master_tx_data;
    wire [7:0] master_rx_data;
    wire master_done;
    
    reg [7:0] slave_tx_data;
    wire [7:0] slave_rx_data;

    wire sclk;
    wire mosi;
    wire miso;
    wire cs;

    spi_master u_master (
        .clk(clk),
        .rst(rst),
        .start(start),
        .tx_data(master_tx_data),
        .rx_data(master_rx_data),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .done(master_done),
        .miso(miso)
    );

    spi_slave u_slave (
        .sclk(sclk),
        .cs(cs),
        .mosi(mosi),
        .miso(miso),
        .tx_data(slave_tx_data),
        .rx_data(slave_rx_data)
    );

    always #5 clk = ~clk; 

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_spi);

        clk = 0;
        rst = 1;
        start = 0;
        
        master_tx_data = 8'hA5; 
        slave_tx_data  = 8'h3C;

        #20;
        rst = 0;
        #20;

        $display("Starting SPI Transaction...");
        start = 1;
        #10;
        start = 0;

        wait(master_done);
        
        #20; 

        $display("--- Transaction Complete ---");
        $display("Master sent: %h, Master received: %h", master_tx_data, master_rx_data);
        $display("Slave sent:  %h, Slave received:  %h", slave_tx_data, slave_rx_data);

        if (master_rx_data == 8'h3C && slave_rx_data == 8'hA5)
            $display("SUCCESS: Data successfully swapped over SPI!");
        else
            $display("ERROR: Data mismatch.");

        $finish; 
    end
endmodule
