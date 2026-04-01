% Optimization rotutine 
% For case 1

clear all
clc
s = tf('s');

% MIMO Plant
G11 = tf(22.89,[4.572 1],'InputDelay',0.2);
G12 = tf(4.689,[2.174 1],'InputDelay',0.2);
G21 = tf(-11.64,[1.807 1],'InputDelay',0.4);
G22 = tf(5.8,[1.801 1],'InputDelay',0.4);

G = [G11 G21;G12 G22]; % This looks like reverse but actually correct

%% Consider 1st Loop Only

% initial Parameters 

kP = 0.24;
kI = 0.05;
kD = 0.03;

kPID0 = [kP,kI,kD];

% Bounds (optional)
lb = [0, 0, 0];
ub = [1, 1, 1];

% fmincon options
options = optimoptions('fmincon', ...
    'Display', 'iter', ...
    'MaxFunctionEvaluations', 2e4);

% Optimization
kPID_opt = fmincon(@(kPID) objectiveIAE(kPID, G12), ...
                    kPID0, ...
                    [], [], [], [], ...
                    lb, ub, ...
                    @(kPID) sensitivityConstraint(kPID, G11), ...
                    options);

disp('Optimal parameters:');
disp(kPID_opt);

%% Plottings

%optimal PID controllers (the results of optimization problem from paper)
C1 = 0.46+0.12/s+0.04*s/(0.1*s+1);

w = logspace(-2, 2, 2000);   % only positive frequencies

% figure 1

np = nyquistplot(C1*G11,w);
np.ShowNegativeFrequencies = "off";
xlim([-2 1])
ylim([-1.5 0.5])

Ms = 1.6;
r = 1 / Ms;
% 
theta = linspace(0, 2*pi, 500);
% 
% % Circle centered at (-1,0)
x = -1 + r*cos(theta);
y = r*sin(theta);
% 
hold on;
plot(x, y, 'r--', 'LineWidth', 1.5);
title('loop 1')


C = buildController(kPID_opt); % optimized values
np = nyquistplot(C*G11,w);
np.ShowNegativeFrequencies = "off";

%% Function Definitions

function J = objectiveIAE(kPID, P)
    C = buildController(kPID);

    % Closed-loop system
    T = feedback(C*P, 1);

    % Time vector
    t = linspace(0, 20, 1000);

    % Step response
    [y, t] = step(T, t);

    % Error
    e = 1 - y;

    % IAE
    J = trapz(t, abs(e));
end

function [c, ceq] = sensitivityConstraint(kPID, P)
    
    C = buildController(kPID);

    % Sensitivity function
    S = feedback(1, C*P);

    % Frequency grid
    w = logspace(-3, 3, 1000);

    % Compute magnitude
    [mag, ~] = bode(S, w);
    mag = squeeze(mag);

    Ms = max(mag);

    % Inequality constraint: Ms <= 1.6
    c = Ms - 1.6;

    % No equality constraint
    ceq = [];
end

function C = buildController(kPID)
    s = tf('s');
    kP = kPID(1);
    kI = kPID(2);
    kD = kPID(3);

    % Build controller (example PID)
    C = kP+kI/s+kD*s/(0.1*s+1);
end

