module main
(
    input wire sys_clk,      // clk input
    input wire btn1,         // right button
    output wire uart_tx      // uart transmission
);

reg sb_start = 0;
reg [8:0] sb_maru = 1;
reg [8:0] sb_batu = 4;
wire sb_ready;

sendboard #() sb (
    .sys_clk(sys_clk),
    .start(sb_start),
    .maru(sb_maru),
    .batu(sb_batu),
    .uart_tx(uart_tx),
    .ready(sb_ready)
);

reg [3:0] state = 0;

localparam STATE_IDLE = 0;
localparam STATE_SUBMIT = 1;
localparam STATE_END = 2;

always @(posedge sys_clk) begin

    case (state)
        STATE_IDLE: begin
            if (btn1 == 0) begin
                state <= STATE_SUBMIT;
            end else begin
                state <= STATE_IDLE;
            end
        end
        STATE_SUBMIT: begin
            if (sb_ready == 1) begin
                sb_start <= 1;
                state <= STATE_END;
            end
        end
        STATE_END: begin
            sb_start <= 0;
            state <= STATE_IDLE;
        end
    endcase
//*/
end


endmodule
