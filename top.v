`timescale 1ns / 1ps

module top(
    input clk,                           // Pin W5 (100MHz)
    input btnU, btnD, btnL, btnR, btnC,  // Buttons
    input [2:0] sw,                      // sw[0] for Reset
    output [6:0] led,                    // Matches led[0:6] in XDC
    output reg hsync, vsync,                 // Lowercase to match XDC
    output  [3:0] vgaRed, vgaGreen, vgaBlue // 12-bit VGA output
);

    reg [1:0] counter;
    reg clk_25;  
    always @(posedge clk or posedge sw[0]) 
    begin
      if(sw[0])
      begin
        counter <= 0;
        clk_25 <= 0;
      end
      else
      begin
        counter <= counter + 1;

        if(counter == 1)
        begin
            clk_25 <= ~clk_25;
            counter <= 0;
        end
      end
    end


    // Internal Wires          
    reg video_on;
    reg [9:0] hcount, vcount, hcount_stg1, vcount_stg1,hcount_unpip, vcount_unpip;
    wire [2:0] rgb_3bit;
    wire [63:0] boxes;
    reg [2:0] c1, c2, c1_stg1, c2_stg1;
    wire done;
    wire db_U, db_D, db_L, db_R, db_C;
    reg video_on_unpip,hsync_unpip,vsync_unpip,video_on_stg1,hsync_stg1,vsync_stg1;
    reg [2:0] i,j,i_stg1, j_stg1;
    reg [7:0] k,l,k_stg1, l_stg1;
    reg [9:0] count1,count2,m,o,count_1_stg1, count_2_stg1, m_stg1, o_stg1;
    always@(posedge clk_25)begin
        hsync_stg1 <= hsync_unpip;
        vsync_stg1 <= vsync_unpip;
        video_on_stg1 <= video_on_unpip;
        hcount_stg1 <= hcount_unpip;
        vcount_stg1 <= vcount_unpip;
        hsync <= hsync_stg1;
        vsync <= vsync_stg1;
        video_on <= video_on_stg1;
        hcount <= hcount_stg1;
        vcount <= vcount_stg1;
        i <= i_stg1;
        j <= j_stg1;
        k <= k_stg1;
        l <= l_stg1;
        count1 <= count_1_stg1;
        count2 <= count_2_stg1;
        m <= m_stg1;
        o <= o_stg1;
    end
    

    // 1. Clock Wizard Instance (Must be named vga_clk_gen in IP Catalog)

    
    de_bounce db_u_inst (.clk(clk), .btn_in(btnU), .pulse(db_U));
    de_bounce db_d_inst (.clk(clk), .btn_in(btnD), .pulse(db_D));
    de_bounce db_l_inst (.clk(clk), .btn_in(btnL), .pulse(db_L));
    de_bounce db_r_inst (.clk(clk), .btn_in(btnR), .pulse(db_R));
    de_bounce db_c_inst (.clk(clk), .btn_in(btnC), .pulse(db_C));

    // 2. Game Logic Instance (Direct Connection)
    lights_on game_inst (
        .clk(clk),
        .reset(sw[0]),
        .sel(sw[2:1]),
        .u(db_U), .d(db_D), .l(db_L), .r(db_R), .toggle(db_C),
        .count1(c1), .count2(c2),
        .boxes(boxes),
        .done(done)
    );

    // 3. VGA Sync Generator
    vga_pointer vga_sync (
        .clk_25(clk_25),
        .reset(sw[0]),
        .hcount_unpip(hcount_unpip),
        .vcount_unpip(vcount_unpip),
        .hsync_unpip(hsync_unpip),
        .vsync_unpip(vsync_unpip),
        .video_on_unpip(video_on_unpip)
    );

    // 4. Pixel Generator
    pixel_generator_stg1 pixel_gen1 (
        .hcount(hcount_stg1),
        .vcount(vcount_stg1),
        .count1(c1_stg1),
        .count2(c2_stg1),
        .i(i_stg1), .j(j_stg1), .k(k_stg1), .l(l_stg1), .m(m_stg1), .o(o_stg1),
    );

    pixel_generator_stg2 pixel_gen2 (
        .video_on(video_on),
        .hcount(hcount),
        .vcount(vcount),
        .boxes(boxes),
        .rgb(rgb_3bit),
        .count_1(c1),
        .count_2(c2),
        .i(i), .j(j), .k(k), .l(l), .m(m), .o(o)
    );

    // 5. VGA Pin Mapping
    assign vgaRed   = {4{rgb_3bit[2]}};
    assign vgaGreen = {4{rgb_3bit[1]}};
    assign vgaBlue  = {4{rgb_3bit[0]}};

    // 6. LED Debugging
    assign led[6]   = done;

endmodule