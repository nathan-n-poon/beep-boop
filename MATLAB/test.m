//for research and initial prototyping
//not used n final product
//taken from https://www.fpga4student.com/2016/11/image-processing-on-fpga-verilog.html
//the hex conversion was later done in c/main.c
b=imread('../bmps/sushi.bmp'); % 24-bit BMP image RGB888 
%C:\Users\natha\OneDrive\Documents\GitHub\beep-boop\output.bmp
k=1;
for i=100:-1:1 % image is written from the last row to the first row
for j=1:100
a(k)=b(i,j,1);
a(k+1)=b(i,j,2);
a(k+2)=b(i,j,3);
k=k+3;
end
end
fid = fopen('sushi.hex', 'wt');
fprintf(fid, '%x\n', a);
disp('Text file write done');disp(' ');
fclose(fid);