module pixel_generator_stg2(input video_on,input [9:0]hcount,vcount,input [63:0]boxes,input [2:0]i,j,count_1,count_2,input [7:0]k,l,input [9:0]m,o,output reg [2:0]rgb);
  always@(*)begin
    if(!video_on)
      rgb=3'b000;
    else begin
      if(hcount<640 && vcount<480)begin
        if(boxes[(j<<3)+i])
          rgb=3'b111;
        else
          rgb=3'b000;
        if(k==0 || k==79 || l==0 || l==59)
        rgb=3'b001;
        if((hcount==(m) || hcount==(count_1+2) || hcount== (count_1+78 ) || hcount==(count_1+77)) && vcount >= (count_2+1) && vcount <=o)
        rgb=3'b100;
        if(hcount>=(m) && hcount<=(count_1+78) && (vcount == (count_2+1) || vcount == (count_2+2) || vcount ==(count_2+57) || vcount == (o)))
        rgb=3'b100;
      end
      else
        rgb=3'b000;
    end
  end
endmodule