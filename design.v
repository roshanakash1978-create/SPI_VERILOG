`timescale 1ns / 1ps

module spi_master (
    input clk,           
    input rst,           
    input start,         
    input [7:0] tx_data, 
    output reg [7:0] rx_data, 
    output reg sclk,     
    output reg mosi,     
    output reg cs,       
    output reg done,     
    input miso           
);

    localparam IDLE = 2'b00;
    localparam TRANSFER = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_cnt;   
    reg [7:0] tx_shift_reg; 

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            sclk <= 0;
            mosi <= 0;
            cs <= 1;
            done <= 0;
            bit_cnt <= 0;
            tx_shift_reg <= 0;
            rx_data <= 0;
        end else begin
            case (state)
                IDLE: begin
                    cs <= 1;
                    sclk <= 0;
                    done <= 0;
                    mosi <= 0;
                    if (start) begin
                        tx_shift_reg <= tx_data;
                        mosi <= tx_data[7]; /
                        bit_cnt <= 7; 
                        cs <= 0;      
                        state <= TRANSFER;
                    end
                end

                TRANSFER: begin
                    sclk <= ~sclk; 
                    
                    if (sclk == 0) begin
                        rx_data <= {rx_data[6:0], miso};
                    end else begin
                        if (bit_cnt == 0) begin
                            state <= DONE; 
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                            mosi <= tx_shift_reg[bit_cnt - 1]; 
                        end
                    end
                end

                DONE: begin
                    cs <= 1;        
                    sclk <= 0;
                    mosi <= 0;
                    done <= 1;      
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end
endmodule

module spi_slave (
    input sclk,          
    input cs,            
    input mosi,          
    output reg miso,     
    input [7:0] tx_data, 
    output reg [7:0] rx_data 
);

    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;
    always @(negedge cs) begin
        shift_reg <= tx_data;
        bit_cnt <= 7;
        miso <= tx_data[7];
    end
    always @(posedge sclk) begin
        if (!cs) begin
            rx_data <= {rx_data[6:0], mosi};
        end
    end
    always @(negedge sclk) begin
        if (!cs) begin
            if (bit_cnt > 0) begin
                bit_cnt <= bit_cnt - 1;
                miso <= shift_reg[bit_cnt - 1];
            end
        end
    end
endmodule
