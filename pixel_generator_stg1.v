module pixel_generator_stg1(input [9:0]hcount,vcount,input [2:0]count1,count2,output reg [2:0]i,j,output reg [7:0]k,l,output reg [9:0] count_1,count_2,m,o);
  always@(*)begin
      if(hcount<640 && vcount<480)begin
        i=hcount/80;
        j=vcount/60;
        k=hcount%80;
        l=vcount%60;
        count_1=(count1<<6)+(count1<<4);
        count_2=(count2<<2)+(count2<<3)+(count2<<4)+(count2<<5);
        m=count1+1;
        o=count2+58;
  end
      else begin
        i=0;
        j=0;
        k=0;
        l=0;
        count_1=0;
        count_2=0;
        m=0;
        o=0;
      end
end
endmodule