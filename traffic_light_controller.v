`timescale 1ns / 1ps

module traffic_light_controller #(
    parameter CLK_FREQ = 100_000_000, // 100 MHz System Clock
    parameter GREEN_TIME = 30,        // 30 Seconds Green Light
    parameter YELLOW_TIME = 3         // 3 Seconds Yellow Light
)(
    input  wire clk,
    input  wire rst,
    
    // Road 1
    output reg YESIL1,
    output reg SARI1,
    output reg KIRMIZI1,
    
    // Road 2
    output reg YESIL2,
    output reg SARI2,
    output reg KIRMIZI2,
    
    // Road 3
    output reg YESIL3,
    output reg SARI3,
    output reg KIRMIZI3,
    
    // Road 4
    output reg YESIL4,
    output reg SARI4,
    output reg KIRMIZI4,
    
    // Right Turn Indicators (Blinking)
    output wire SAG_OUT_1,
    output wire SAG_OUT_2,
    output wire SAG_OUT_3,
    output wire SAG_OUT_4
);

    // =========================================================================
    // Local Parameters & State Definitions
    // =========================================================================
    
    // FSM States
    localparam [2:0] 
        S_R1_G = 3'd0,
        S_R1_Y = 3'd1,
        S_R2_G = 3'd2,
        S_R2_Y = 3'd3,
        S_R3_G = 3'd4,
        S_R3_Y = 3'd5,
        S_R4_G = 3'd6,
        S_R4_Y = 3'd7;

    // Timer Thresholds to convert seconds to clock cycles
    // Note: If using this for simulation with small cycle counts, ensure params are set appropriately.
    localparam [31:0] GREEN_CYCLES  = GREEN_TIME * CLK_FREQ;
    localparam [31:0] YELLOW_CYCLES = YELLOW_TIME * CLK_FREQ;
    
    // 0.5s for blinking (1Hz total period: 0.5s ON, 0.5s OFF)
    localparam [31:0] BLINK_HALF_PERIOD = CLK_FREQ / 2; 

    // =========================================================================
    // Internal Registers
    // =========================================================================
    
    reg [2:0]   current_state, next_state;
    reg [31:0]  timer_counter;
    reg         timer_reset;
    
    // Blinking logic registers
    reg [31:0]  blink_counter;
    reg         blink_state; // 1 = ON, 0 = OFF

    // =========================================================================
    // Right Turn Blinking Logic (Independent 1Hz)
    // =========================================================================
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            blink_counter <= 0;
            blink_state   <= 0;
        end else begin
            if (blink_counter >= BLINK_HALF_PERIOD - 1) begin
                blink_counter <= 0;
                blink_state   <= ~blink_state; // Toggle state every 0.5s
            end else begin
                blink_counter <= blink_counter + 1;
            end
        end
    end

    // Assign blinking state to outputs
    assign SAG_OUT_1 = blink_state;
    assign SAG_OUT_2 = blink_state;
    assign SAG_OUT_3 = blink_state;
    assign SAG_OUT_4 = blink_state;

    // =========================================================================
    // Traffic Light FSM System
    // =========================================================================

    // State Register
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= S_R1_G;
            timer_counter <= 0;
        end else begin
            if (timer_reset) begin
                current_state <= next_state;
                timer_counter <= 0;
            end else begin
                timer_counter <= timer_counter + 1;
            end
        end
    end

    // Next State Logic
    always @(*) begin
        // Default assignments to prevent latches
        next_state  = current_state;
        timer_reset = 0;
        
        case (current_state)
            S_R1_G: begin
                // Road 1 Green for GREEN_TIME
                if (timer_counter >= GREEN_CYCLES - 1) begin
                    next_state  = S_R1_Y;
                    timer_reset = 1;
                end
            end
            
            S_R1_Y: begin
                // Road 1 Yellow for YELLOW_TIME
                if (timer_counter >= YELLOW_CYCLES - 1) begin
                    next_state  = S_R2_G;
                    timer_reset = 1;
                end
            end
            
            S_R2_G: begin
                // Road 2 Green
                if (timer_counter >= GREEN_CYCLES - 1) begin
                    next_state  = S_R2_Y;
                    timer_reset = 1;
                end
            end
            
            S_R2_Y: begin
                // Road 2 Yellow
                if (timer_counter >= YELLOW_CYCLES - 1) begin
                    next_state  = S_R3_G;
                    timer_reset = 1;
                end
            end
            
            S_R3_G: begin
                // Road 3 Green
                if (timer_counter >= GREEN_CYCLES - 1) begin
                    next_state  = S_R3_Y;
                    timer_reset = 1;
                end
            end
            
            S_R3_Y: begin
                // Road 3 Yellow
                if (timer_counter >= YELLOW_CYCLES - 1) begin
                    next_state  = S_R4_G;
                    timer_reset = 1;
                end
            end
            
            S_R4_G: begin
                // Road 4 Green
                if (timer_counter >= GREEN_CYCLES - 1) begin
                    next_state  = S_R4_Y;
                    timer_reset = 1;
                end
            end
            
            S_R4_Y: begin
                // Road 4 Yellow -> Loop back to Road 1 Green
                if (timer_counter >= YELLOW_CYCLES - 1) begin
                    next_state  = S_R1_G;
                    timer_reset = 1;
                end
            end
            
            default: begin
                next_state  = S_R1_G;
                timer_reset = 1;
            end
        endcase
    end

    // Output Logic
    // Default all to RED, then override based on state
    always @(*) begin
        // Default: All Red
        YESIL1 = 0; SARI1 = 0; KIRMIZI1 = 1;
        YESIL2 = 0; SARI2 = 0; KIRMIZI2 = 1;
        YESIL3 = 0; SARI3 = 0; KIRMIZI3 = 1;
        YESIL4 = 0; SARI4 = 0; KIRMIZI4 = 1;
        
case (current_state)

    S_R1_G: begin
        YESIL1 = 1; KIRMIZI1 = 0;
    end

    S_R1_Y: begin
        // Y1 + Y2
        SARI1 = 1; KIRMIZI1 = 0;
        SARI2 = 1; KIRMIZI2 = 0;
    end

    S_R2_G: begin
        YESIL2 = 1; KIRMIZI2 = 0;
    end

    S_R2_Y: begin
        // Y2 + Y3
        SARI2 = 1; KIRMIZI2 = 0;
        SARI3 = 1; KIRMIZI3 = 0;
    end

    S_R3_G: begin
        YESIL3 = 1; KIRMIZI3 = 0;
    end

    S_R3_Y: begin
        // Y3 + Y4
        SARI3 = 1; KIRMIZI3 = 0;
        SARI4 = 1; KIRMIZI4 = 0;
    end

    S_R4_G: begin
        YESIL4 = 1; KIRMIZI4 = 0;
    end

    S_R4_Y: begin
        // Y4 + Y1
        SARI4 = 1; KIRMIZI4 = 0;
        SARI1 = 1; KIRMIZI1 = 0;
    end

endcase

    end

endmodule
