module dyn_arr_ex;

int dyn_arr1[], dyn_arr2[];

initial begin
dyn_arr1 = new[6];

foreach(dyn_arr1[i])
    dyn_arr1[i] = i;

dyn_arr2 = '{9,1,8,3,4,4};

foreach(dyn_arr1[i])
    $display("Element %0d in dyn_arr1 = %0d and its Size = %0d",i,dyn_arr1[i],dyn_arr1.size());

dyn_arr1.delete();

foreach(dyn_arr2[i])
    $display("For Original Array: Element %0d in dyn_arr2 = %0d",i,dyn_arr2[i]);

dyn_arr2.reverse();

foreach(dyn_arr2[i])
    $display("For Reversed Array: Element %0d in dyn_arr2 = %0d",i,dyn_arr2[i]);

dyn_arr2.sort();

foreach(dyn_arr2[i])
    $display("For Sorted Array: Element %0d in dyn_arr2 = %0d",i,dyn_arr2[i]);

dyn_arr2.rsort();

foreach(dyn_arr2[i])
    $display("For Reversly Sorted Array: Element %0d in dyn_arr2 = %0d",i,dyn_arr2[i]);

dyn_arr2.shuffle();

foreach(dyn_arr2[i])
    $display("For Shuffled Array: Element %0d in dyn_arr2 = %0d",i,dyn_arr2[i]);
end

endmodule