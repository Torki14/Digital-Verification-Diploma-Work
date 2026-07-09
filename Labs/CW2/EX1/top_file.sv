import pkg::*;
module top_file();
initial begin
MemTrans Obj1 = new(,.address(2));
MemTrans Obj2 = new(.data_in(3),.address(4));
Obj1.disp_mem();
Obj2.disp_mem();
end
endmodule