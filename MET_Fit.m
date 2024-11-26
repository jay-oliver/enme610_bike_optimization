%Fits the MET table to a linear function, with velocity in m/s as input,
%METs as output
MET = [3.5 5.8 6.8 8.0 10.0 12.0];
V_mph = [5.5 9.4 10.95 12.95 14.95 17.5];
V_m_s = V_mph/2.237;
p = polyfit(V_m_s, MET, 1)
plot(V_m_s, MET, 'o');
hold on
x1 = linspace(0, 12, 100);
y1 = polyval(p,x1);
plot(x1, y1);
hold off
METs = @(x) p(1)*x + p(2)
%p = [1.5903 -0.7588]