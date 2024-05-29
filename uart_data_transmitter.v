module uart_data_transmitter (
    input wire clk_50m,
    output wire Tx,
    output wire Tx_busy,
    input wire Rx,
    output wire ready,
    input wire ready_clr,
    output wire [7:0] data_out,
    output [7:0] LEDR,
    output wire Tx2
);

    reg [7:0] data_to_send = 8'b00000000;
    reg [31:0] counter = 0;

    // Declare internal wires for UART signals
    wire uart_Tx;
    wire uart_Tx_busy;
    wire uart_ready;
   

    // Instantiate your existing uart module
    uart uart_inst (
        .data_in(data_to_send),
        .wr_en(1'b0),
        .clear(1'b0),
        .clk_50m(clk_50m),
        .Tx(uart_Tx),
        .Tx_busy(uart_Tx_busy),
        .Rx(Rx),
        .ready(uart_ready),
        .ready_clr(ready_clr),
        .data_out(data_out), // Connect data_out to internal register
        .LEDR(LEDR),
        .Tx2(Tx2)
    );

    // Connect UART outputs to internal signals
    assign Tx = uart_Tx;
    assign Tx_busy = uart_Tx_busy;
    assign ready = uart_ready;

    // Counter to control data transmission delay
    always @(posedge clk_50m) begin
        if (counter < 50000000) begin  // 50M cycles for 1 second delay
            counter <= counter + 1;
        end else begin
            counter <= 0;
            // Increment data to send (0 to 255 wrap around)
            if (data_to_send == 8'hFF) begin
                data_to_send <= 8'b00000000;
            end else begin
                data_to_send <= data_to_send + 1;
            end
        end
    end

endmodule
