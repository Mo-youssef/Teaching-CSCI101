%% p1
% a
vec = [1 2 3 4];
res = sum(vec);
% b
res = sum(vec(2:2:end));
% c
res = sum(vec(~rem(vec,2)));
% d
res = sum(~rem(vec,2));
%% p2
vec = randi(21,1,5)-11;
% vec = randi([-10 10],1,5);
vec1 = vec-3;
cp = sum(vec>0);
ab = abs(vec);
m = max(vec);
%% p3
vec = [1 7 8 2 7];
en = sum(~(rem(vec,2)));
on = sum((rem(vec,2)));
%% p4
r = [1 2 3 4 -1];
h = [2 -13 4 5 6];
li = logical((r>0).*(h>0));
r = r(li);
h = h(li);
v = pi.*r.^2.*h;
%% p5
vecs2g([98 23 77 88 99 65 57]);
%% p6
p1 = [1 2; 0 0; 10 12; 3  5];
p2 = [4 5; 3  5;1  7; 3 4];
Diff = p1-p2;
sq = Diff.^2;
su = sum(sq,2);
Dist = sqrt(su);
%% p7
G = input('enter grades arr ');
a = sum(G>=90);
b = sum(and(G>=80,G<90));
c = sum(and(G>=70,G<80));
d = sum(and(G>=60,G<70));
f = sum(G<60);
fprintf('%c  ','ABCDF');
fprintf('\n');
fprintf('%d  ',[a b c d f]);
fprintf('\n');











