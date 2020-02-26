%% compare Cr for different n

klbr = linspace(0,200);
Fy = 350;
E = 200000;
Fe = pi*pi*E./(klbr.^2);
l = sqrt(Fy./Fe);

m0 = (1 + l.^(2*0.93)).^(-1/0.93);
m1 = (1 + l.^(2*1.34)).^(-1/1.34);
m2 = (1 + l.^(2*2.24)).^(-1/2.24);

plot( klbr, m0, klbr, m1, klbr, m2 );

grid on

d = (m1-m0)./m1;
  max(d)
pause
