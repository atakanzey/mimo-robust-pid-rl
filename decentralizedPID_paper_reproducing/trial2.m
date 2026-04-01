clear all
clc
s = tf('s')
G11 = tf(22.89,[4.572 1],'InputDelay',0.2);
G12 = tf(4.689,[2.174 1],'InputDelay',0.2);
G21 = tf(-11.64,[1.807 1],'InputDelay',0.4);
G22 = tf(5.8,[1.801 1],'InputDelay',0.4);

G = [G11 G21;G12 G22];

C1 = 0.46+0.12/s+0.04*s/(0.1*s+1);
C2 = 0.16+0.06/s+0.00*s/(0.1*s+1);
w = logspace(-2, 2, 2000);   % only positive frequencies

% figure 1

np = nyquistplot(C1*G11,w);
np.ShowNegativeFrequencies = "off";
xlim([-2 1])
ylim([-1.5 0.5])

Ms = 1.6;
r = 1 / Ms;

theta = linspace(0, 2*pi, 500);

% Circle centered at (-1,0)
x = -1 + r*cos(theta);
y = r*sin(theta);

hold on;
plot(x, y, 'r--', 'LineWidth', 1.5);
title('loop 1')

% figure 2
figure


np = nyquistplot(C2*G22,w);
np.ShowNegativeFrequencies = "off";
xlim([-2 1])
ylim([-1.5 0.5])

Ms = 1.2;
r = 1 / Ms;

theta = linspace(0, 2*pi, 500);

% Circle centered at (-1,0)
x = -1 + r*cos(theta);
y = r*sin(theta);

hold on;
plot(x, y, 'r--', 'LineWidth', 1.5);
title('loop 2')

