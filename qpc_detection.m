function [] = qpc_detection(signal,fs)

% Estimate power spectrum using dsp.SpectrumEstimator 

SE = dsp.SpectrumEstimator;
C2=SE(signal);
n1=length(C2);
x=(0:n1-1)*(fs/n1);
y=C2;
plot(x,y);
xlabel('Frequency (Hz)')
ylabel('Power')
set(gca,'ylim',[0 0.8])
set(gca,'xlim',[0 20])

% Estimate bispectrum using Indirect method and Parzen as our window

K=128;
M=ceil(length(signal)/K);
L=64;

figure;
bispeci(y,L,M,0,'unbiased',128); % Parzen window,check others parameters as well, HOSA, check for fftlength(256)

hline1 = refline(0, 0); % Bispectrum symmetries
hline1.Color = 'k';
hline2 = refline(-1, 0.5);
hline2.Color = 'k';
hline3 = refline(1, 0);
hline3.Color = 'k';





end


