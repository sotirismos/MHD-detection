function [] = qpc_detection(signal,fs)

signal = detrend(signal,14); % Remove the 14th degree polyonomial trend (removes peak at 0 Hz)

% Estimate power spectrum using basic spectral analysis

fftsignal = (fft(signal));
n = length(fftsignal);   % number of samples
f = (0:n-1)*fs/n;  % frequency range
power = abs(fftsignal).^2/n;  % power of the DFT
power = (power/max(power));   % normalize the values

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
SS = Nfft/2+1;
waxis1 = waxis(SS:end)*fs;
figure;
subplot(121)
bspec1 = bspec(SS:end,SS:end);
contour(waxis1,waxis1,abs(bspec1),10);
set(gca,'ylim',[-20 20])
set(gca,'xlim',[-20 20])
grid on
title('Bispectrum')
xlabel('f1'),ylabel('f2')

% Bispectrum symmetries

hline1 = refline(0, 0); 
hline1.Color = 'k';
hline2 = refline(-1, 0.5);
hline2.Color = 'k';
hline3 = refline(1, 0);
hline3.Color = 'k';

[X1,Y1] = meshgrid(waxis1,waxis1);
subplot(122)
mesh(X1,Y1,abs(bspec1))
axis tight;
set(gca,'ylim',[-20 20])
set(gca,'xlim',[-20 20])
title('Bispectrum')
ylabel('f1')
ylabel('f2')
zlabel('range')

% Bispectrum symmetries

hline1 = refline(0, 0); 
hline1.Color = 'k';
hline2 = refline(-1, 0.5);
hline2.Color = 'k';
hline3 = refline(1, 0);
hline3.Color = 'k';


end



