import class_pkg::*;
module top_file();
Excercise2 Obj;
initial begin
Obj = new();
for(int i = 0; i < 20; i++) begin 
    assert(Obj.randomize());
    Obj.disp();
    #10;
end
end
endmodule