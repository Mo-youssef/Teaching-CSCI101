function res = vecs2g(x)
res = '';
res(x>=90) = 'A';
res(and(x>=80,x<90)) = 'B';
res(and(x>=70,x<80)) = 'C';
res(and(x>=60,x<70)) = 'D';
res(x<60) = 'F';
end