s = tf('s')
G11 = tf(12.8,[16.7 1],'InputDelay',1);
G12 = tf(-18.9,[21 1],'InputDelay',3);
G21 = tf(6.6,[10.9 1],'InputDelay',7);
G22 = tf(-19.4,[14.4 1],'InputDelay',3);

G = [G11 G21;G12 G22];

C1 = 0.375*(1+1/(8.29*s));
C2 = -0.075*(1+1/(23.60*s));

C = [C1 0;0 C2];

t = 0:0.1:100;
step(feedback(C*G,eye(2)),t)
