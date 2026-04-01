clc; clear; close all;

%% Define Laplace variable
s = tf('s');

%% Define a 2x2 MIMO plant (with coupling)
G = 5/(s^3+8*s^2+17*s+10);
C = 4+2.5/s;

w = logspace(-2, 2, 2000);   % only positive frequencies
np = nyquistplot(C*G,w);
np.ShowNegativeFrequencies = "off";
xlim([-3 2])
ylim([-3 2])
step(feedback(C*G,1))

figure 
G = 1/((s+1)*(s-1)*(s+2));
C = 9.65+4.24/s+12.26*s;

w = logspace(-2, 2, 2000);   % only positive frequencies
np = nyquistplot(C*G,w);
np.ShowNegativeFrequencies = "off";
xlim([-4 1])
ylim([-2 3])
figure
step(feedback(C*G,1))