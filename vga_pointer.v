module vga_pointer(input clk_25,reset,output reg[9:0]hcount_unpip,vcount_unpip,output reg hsync_unpip,vsync_unpip,video_on_unpip);
  reg [9:0]nxthcount,nxtvcount;
  reg nxthsync,nxtvsync,nxtvideo_on;
  always@(posedge clk_25,posedge reset)begin
    if(reset)begin
      hcount_unpip<=0;
      vcount_unpip<=0;
      hsync_unpip<=1;
      vsync_unpip<=1;
      video_on_unpip<=0;
    end
    else begin
      hcount_unpip<=nxthcount;                      
      vcount_unpip<=nxtvcount; 
      hsync_unpip<=nxthsync;
      vsync_unpip<=nxtvsync;
      video_on_unpip<=nxtvideo_on;
    end               
  end
  always@(*)begin
    nxthcount=hcount_unpip;
    nxtvcount=vcount_unpip;
    nxtvideo_on=video_on_unpip;
    if(hcount_unpip<799)
        nxthcount=hcount_unpip+1;
    else 
        nxthcount=0;
    if(vcount_unpip<524 && hcount_unpip==799)
        nxtvcount=vcount_unpip+1;
    else if(vcount_unpip==524 && hcount_unpip==799)
        nxtvcount=0;
    nxthsync=~(nxthcount>=656 && nxthcount<752);
    nxtvsync=~(nxtvcount>=490 && nxtvcount<492);
    nxtvideo_on=(nxthcount<640 && nxtvcount<480);
  end
endmodule