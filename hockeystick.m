% hockeystick.m
% Tyler Niles
% 10.10.10

% clear memory
clear


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read-in Data
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% import from textfile to matrix M
M = dlmread('lambh23b.txt','\t');
% print out data
%disp(M)
% parse
x = M(:,1);
y = M(:,2);
N = length(y);
% plot
figure(1)
subplot(2,1,1), plot(x,y);
title('Temperature Data: year 895 to 1975')
xlabel('Year'), ylabel('Relative Temperature')
subplot(2,1,2), plotfft(x,y);
title('fft')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Noise
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% gen noise
amp = 0.9;      % amplitude
var = 0.6;      % variance
a = amp * sqrt(var) * randn(N,1); % gaussian samples
figure(2)
subplot(2,1,1), plot(x,a)
title('Gaussian Additive Noise')
subplot(2,1,2), plotfft(x,a);
title('fft')

% add noise
y = y + a;
figure(3)
subplot(2,1,1), plot(x,y)
title('Noisy Signal')
xlabel('Year'), ylabel('Dithered Temperature')
subplot(2,1,2), [Y,f]=plotfft(x,y);
title('fft')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% bpf - Mrs. Syrup
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Butterworth Bandpass Filtering\n')
%n   = input('Please enter n-1 filter order: ');
%fp1 = input('Please enter low-end frequency: ');
%fp2 = input('Please enter high-end frequency: ');
n=1; fp1=0; fp2=11;
fprintf('\n')
fprintf('\nThe BW Selected is f_lo = %f and f_hi = %f\n', fp1, fp2)
fo = fp1 + (fp2-fp1)/2;
fprintf('Thus, fo for the filter is %f\n\n', fo)
        
w   = 2*pi*f;       %freq. vector
wo  = 2*pi*fo;      %resonant frequency
wlo = 2*pi*fp1;
whi = 2*pi*fp2;
bw  = whi - wlo;    %bandwith     
q = wo/bw;          %quality factor

%h_f = (1 + (((j.*w)./wo).^2)) ./ (1 + ((j.*w)./(q*wo)) + (((j.*w)./wo).^2));
h_f = (1./(1+(w./wo).^(2*n))) .* (1./(1+(wo./w).^(2*n)));     % lpf * hpf
Y_f = (Y) .* abs(h_f');
Fs=N;
Y_t = Fs * real(ifft(ifftshift(Y_f)));

figure(4)
subplot(2,1,1), plot(x,Y_t), title('Filtered Signal')
xlabel('Year'), ylabel('Temperature')
subplot(2,1,2), plot(f,abs(Y_f)), title('fft')



% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% all done :-)
