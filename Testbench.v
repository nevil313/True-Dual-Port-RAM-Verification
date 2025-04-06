`timescale 1ns/1ns
module Testbench;
reg we_a,we_b,clk=0,rst=1;
reg [7:0]data_a,data_b;
reg [7:0]add_a,add_b;

wire [7:0]read_a,read_b;
integer i,j;
integer file1,file2;

reg [7:0]mem1[29:0];
reg [7:0]mem2[19:0];
reg [3:0]error1,error2;

dual dut(clk,rst,we_a,we_b,data_a,data_b,add_a,add_b,read_a,read_b);

initial 
    begin 
        file1=$fopen("D:/Desktop/TVDC/dual/dual.srcs/sim_1/imports/dual/port1.txt","w");
        for(i=0;i<15;i=i+1)
            begin
            $fdisplay(file1,"%0x \t %0x",i,2*i);
            end
        $fclose(file1);
    end

initial 
    begin 
    file2=$fopen("D:/Desktop/TVDC/dual/port2.txt","w");
    for(j=10;j<20;j=j+1)
        begin
        $fdisplay(file2,"%0x \t %0x ",j, 3*j);
        end
    $fclose(file2);
    
    end

always #50 clk=~clk;

task rs;
    begin
    we_a=0;
    we_b=0;
    data_a=0;
    data_b=0;
    add_a=0;
    add_b=0;
    error1=0;
    error2=0;
    #100;
    rst=0;
    end
endtask


task write_a;
    begin
    we_a=1;
    rst=0;
    file1=$fopen("D:/Desktop/TVDC/dual/dual.srcs/sim_1/imports/dual/port1.txt","r");
    $readmemh("D:/Desktop/TVDC/dual/dual.srcs/sim_1/imports/dual/port1.txt",mem1);
        for(i=0;i<15;i=i+1) begin
        @(posedge clk);
        data_a=mem1[2*i+1];
        add_a= mem1[2*i];
        end
    end
endtask

task write_b;
    begin
    we_b=1;
    rst=0;
    file2=$fopen("D:/Desktop/TVDC/dual/port2.txt","r");
    $readmemh("D:/Desktop/TVDC/dual/port2.txt",mem2);
        for(i=0;i<10;i=i+1) begin
        @(posedge clk);
        data_b=mem2[2*i+1];
        add_b= mem2[2*i];
        end 
    end
endtask

task read_1;
begin
we_a=0;
rst=0;
    for(i=0;i<=9;i=i+1)
        begin 
        @(posedge clk);
        add_a= $urandom_range(0,19);
        if(read_a==(mem1[2*add_a+1] || mem2[2*add_b+1]))
        error1=error1;
        else 
        begin
        error1=error1+1;
        end
  
        end
    end
endtask

task read_2;
begin
we_b=0;
rst=0;
    for(i=0;i<=12;i=i+1)
        begin 
        @(posedge clk);
        add_b= $urandom_range(0,19);
        if(read_b==(mem1[2*add_a+1] || mem2[2*add_b+1]))
        error2=error2;
        else 
        begin
        error2=error2+1;
        end
        end
end
endtask

initial
    begin
    $monitor("Total missmatches from port_1: %0d",error1);
    $monitor("Total missmatches from port_2: %0d",error2);
    $monitor("Total missmathes : %0d " ,error1+error2);
    #3;
    if((error1+error2)==0)
    $display(" Memory Is working properly without any ERROR ");
    else
    $display(" Memory having some ERROR");
    end
    
initial
    begin
    rs();
    write_a();
    write_b();
    read_1();
    read_2();
    end

endmodule




