function [] = qpc_detection(signal,fs)

signal = detrend(signal,14); % Remove the 14th degree polyonomial trend (removes peak at 0 Hz)

% Estimate power spectrum using basic spectral analysis

fftsignal = (fft(signal));
n = length(fftsignal);   % number of samples
f = (0:n-1)*fs/n;  % frequency range
power = abs(fftsignal).^2/n;  % power of the DFT
power = (power/max(power)); % To normalize the values

figure;
plot(f,power)
xlabel('Frequency')
ylabel('Power')
set(gca,'ylim',[0 2])
set(gca,'xlim',[0 20])


% Estimate bispectrum using direct method 

K = 64; 
M = ceil(length(signal)/K);
z = zeros( K*M - (length(signal)),1); % I need to do this, in order to reshape the signal into a K*M matrix
signal = [signal ; z];

Y = reshape(signal,M,K);

Nfft = 128;
figure;
[bspec,waxis] = bispecd(Y,Nfft,0,K);
waxis1 = waxis*fs;
figure;
contour(waxis1,waxis1,abs(bspec));
set(gca,'ylim',[-20 20])
set(gca,'xlim',[-20 20])
grid on
title('bispectrum')
xlabel('f1'),ylabel('f2')

end



