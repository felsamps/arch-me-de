def int2bin(n, count=24):
    """returns the binary of integer n, using count number of digits"""
    return "".join([str((n >> y) & 1) for y in range(count-1, -1, -1)])

SW = []
for i in range(0,16):
    column = []
    for j in range(0,31):
        column.append(i)
    SW.append(column)

CB = []
for i in range(1,17):
    column = []
    for j in range(0,16):
        column.append(i)
    CB.append(column)

print CB

fp = open("D:\\Arch_TCC\\Input_Tests\\input_pe_column.txt","w")

for j in range(0,16):
        cb_column = CB[j]
        sw_column = SW[j]
        for i in range(0,16):
            for curr_sample in cb_column:
                fp.write(int2bin(curr_sample,8)+'\n')
            for ref_sample in sw_column[i:i+16]:
                fp.write(int2bin(ref_sample,8)+'\n')
fp.close()
    
    
