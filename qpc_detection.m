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

M = 1024; 
K = floor(length(signal)/M);
signal = signal(1:(K*M));

Y = reshape(signal,M,K);

Nfft = 512; % It will go up to 1024 inside the bispecd function

% Bispectrum

[bspec,waxis] = bispecd(Y,Nfft,1,M,0);
SS = Nfft/2+1;
waxis1 = waxis(SS:end)*fs;
figure
subplot(121)
bspec1 = bspec(SS:end,SS:end);
contour(waxis1,waxis1,abs(bspec1),10);
grid on
set(gca,'ylim',[-20 20])
set(gca,'xlim',[-20 20])
title('bispectrum')
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
ylabel('f1')
ylabel('f2')
zlabel('range')
title('bispectrum')


% Frequency ranges do not match with bispectrum

[co_bis,co_waxis] = bicoher(Y,Nfft,1,M,0);
waxis2 = co_waxis(SS:end)*fs;
figure()
subplot(121)
contour(waxis2,waxis2,abs(co_bis(SS:end,SS:end)),4);
grid on
title('coherent bispectrum')
xlabel('f1'),ylabel('f2')
subplot(122)

mesh(X1,Y1,abs(co_bis(SS:end,SS:end)));
axis tight
xlabel('f1')
ylabel('f2')
zlabel('range')
title('coherent bispectrum')

end



