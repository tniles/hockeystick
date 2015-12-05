function [X,f] = plotfft(t,x,s)
% plotfft(t,x,s) produces the shifted mag plot of the FT of x(t).
% X(f) is converted to "true" units with the multiplication by dt, 
% which assumes a time-limited signal.  
%
% The string s can be used to specify symbols/colors for plot.  
%
% [X,f]=plotfft(t,x) returns the shifted X and the frequency vector f.  

N = length(t); dt=abs(t(2)-t(1));
f = ([1:N]-1-floor(N/2))/(t(N)-t(1));
X = fftshift(fft(x)*dt);

if nargin == 2, s = ''; end
plot(f,abs(X),s)
shg
