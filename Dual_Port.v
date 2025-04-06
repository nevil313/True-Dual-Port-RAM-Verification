module dual(clk,rst,we_a,we_b,data_a,data_b,add_a,add_b,read_a,read_b);

input clk,rst,we_a,we_b ;
input [7:0]data_a,data_b;
input [7:0]add_a,add_b;
output reg [7:0]read_a,read_b;

integer i;

reg [7:0]mem[19:0];

always@(posedge clk)
    begin
    read_a<=0;
    mem[add_a]<=mem[add_a];
        if(rst)
            begin
                for(i=0;i<20;i=i+1)
                mem[i]<=0;
            end
        else 
            begin
                if(we_a)
                  if(add_a==add_b)
                    mem[add_a]<=data_a;
              else
                begin
                mem[add_a]<=data_a;
                end
                else
                  if(add_a==add_b)
                     read_a<=mem[add_a];
                  else
                     read_a<=mem[add_a];
                
            end
    end

always@(posedge clk)
    begin
    read_b<=0;
    mem[add_b]<=mem[add_b];
        if(rst)
            begin
                for(i=0;i<20;i=i+1)
                mem[i]<=0;
            end
        else 
            begin
                if(we_b)
                  if(add_a==add_b)
                    mem[add_a]<=data_a;
              else
                begin
                    mem[add_b]<=data_b;
                end
                else
                  if(add_a==add_b)
                    read_a<=mem[add_a];
              else
                    read_b<=mem[add_b];
            end
    end

 endmodule




