module main
(
    input sys_clk,           // clk input
    input sys_rst_n,         // reset input
    //output reg [5:0] led,    // 6 LEDS pin
    //output reg [5:0] led,    // 6 LEDS pin
    input uart_rx,
    output uart_tx,
    input btn1
);

reg [7:0] str[286:0];
reg [31:0] strCount = 5;

initial begin
    str[0] = "H";
    str[1] = "e";
    str[2] = "l";
    str[3] = "l";
    str[4] = "o";
end

// UART
reg uart_start = 0;
reg [7:0] uart_data;
wire uart_ready;

uart_tx #() sender (
    .sys_clk(sys_clk),
    .start(uart_start),
    .data(uart_data),
    .uart_tx(uart_tx),
    .ready(uart_ready)
);

reg [31:0] strIndex = 0;
reg [3:0] state = 0;

localparam STATE_IDLE = 0;
localparam STATE_SUBMIT_INIT = 1;
localparam STATE_SUBMIT_READY = 1;
localparam STATE_END = 2;


always @(posedge sys_clk) begin
    case (state)
        STATE_IDLE: begin
            if (btn1 == 0) begin
                state <= STATE_SUBMIT_INIT;
                strIndex <= 0;
            end else begin
                state <= STATE_IDLE;
                uart_start <= 0;
            end
        end
        STATE_SUBMIT_INIT: begin
            uart_start <= 1;
            if (strIndex == strCount) begin
                state <= STATE_END;
            end else if (uart_ready == 1) begin
                uart_data <= str[strIndex];
                strIndex <= strIndex + 1;
                state <= STATE_SUBMIT_READY;
            end
        end
        STATE_SUBMIT_READY: begin
            state <= STATE_SUBMIT_INIT;
        end
        STATE_END: begin
            uart_start <= 0;
            state <= STATE_IDLE;
        end
    endcase
//*/
end


endmodule
