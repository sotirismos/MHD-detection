% Load signals from 1T MRI
[ECGMRI1T01Out,FsECGMRI1T01Out,~]=rdsamp('database/ECGMRI1T01Out' , 1 ) ; 
[ECGMRI1T01Pro,FsECGMRI1T01Pro,~]=rdsamp('database/ECGMRI1T01Pro' , 1 ) ; 
[ECGMRI1T01Sup,FsECGMRI1T01Sup,~]=rdsamp('database/ECGMRI1T01Sup' , 1 ) ; 

%{
% Plot the signals
figure;
plot(ECGMRI1T01Out,'blue');
hold on
plot(ECGMRI1T01Pro,'red');
legend('Out','Prone')
xlabel('Frame Number')

figure;
plot(ECGMRI1T01Out,'blue');
hold on
plot(ECGMRI1T01Sup,'green');
legend('Out','Supine')
xlabel('Frame Number')

figure;
plot(ECGMRI1T01Pro,'red');
hold on
plot(ECGMRI1T01Sup,'green');
legend('Prone','Supine')
xlabel('Frame Number')
%}

% Signal decomposition
[c,l] = wavedec(ECGMRI1T01Sup,7,'bior1.5');
approx = appcoef(c,l,'bior1.5');
[cd1,cd2,cd3,cd4,cd5,cd6,cd7] = detcoef(c,l,[1 2 3 4 5 6 7]);

%{
subplot(4,1,1)
plot(approx)
title('Approximation Coefficients')
subplot(4,1,2)
plot(cd3)
title('Level 3 Detail Coefficients')
subplot(4,1,3)
plot(cd2)
title('Level 2 Detail Coefficients')
subplot(4,1,4)
plot(cd1)
title('Level 1 Detail Coefficients')


[c,l] = wavedec(ECGMRI1T01Out,3,'bior1.5');
approx = appcoef(c,l,'bior1.5');
[cd1,cd2,cd3] = detcoef(c,l,[1 2 3]);
figure;
subplot(4,1,1)
plot(approx)
title('Approximation Coefficients')
subplot(4,1,2)
plot(cd3)
title('Level 3 Detail Coefficients')
subplot(4,1,3)
plot(cd2)
title('Level 2 Detail Coefficients')
subplot(4,1,4)
plot(cd1)
title('Level 1 Detail Coefficients')
%}

% Interpolation to bring them to same sample sizes
f = ceil(size(ECGMRI1T01Sup,1)/size(cd7,1));
y = interp(cd7,f);
% Cut the final samples 
y = y(1:size(ECGMRI1T01Sup,1));
N = size(y,1);
L = floor(0.02*FsECGMRI1T01Out);
D = L/4;
refThreshold = zeros(1,ceil((N-L)/D));
index = 0;

% Calculate the kurtosis's of the ECG Signal to use as initial threshold
for i=1:D:N-L
    X = y(i:i+L);
    k = kurtosis(X);
    index = index + 1;
    refThreshold(index) = k;
  
end

max = 0;
maximums = zeros(1,size(refThreshold,2));
index = 1;
for i=1:size(refThreshold,2)
    if refThreshold(i)>max
        max = refThreshold(i);
        maximums(index) = max;
        index = index + 1;
    end
    
    
    
end

maximums = nonzeros(maximums);

% 10 last maximums
lastMaximums = maximums(end-10+1:end);


% Initial threshold is the mean of the 10 maximum kurtosis's

threshold = median(lastMaximums);
rpeaks = zeros(1,ceil((N-L)/D));
index = 1;
i = 1;
while i <= N-L
    X = y(i:i+L);
    k = kurtosis(X);
    
    if k >= threshold*0.05
        rpeaks(index) = i;
        index = index + 1;
        
        temp = lastMaximums;
        lastMaximums(10) = 0;
        for j=2:10
            lastMaximums(j)=temp(j-1);
        end
        lastMaximums(1) = k;
        
        threshold = median(lastMaximums);
        
        i = i + ceil(0.2*FsECGMRI1T01Out);
        continue;
    end
     
    i = i + D;
end

% Results
rpeaks = nonzeros(rpeaks);

RpeakMRI1T01Out = rdann('database/ECGMRI1T01Out', 'qrs');
originalpeaks = RpeakMRI1T01Out;
success = 0;

for i=1:length(rpeaks)
    min = 10000000;
    for j=1:length(RpeakMRI1T01Out)
        minDist = abs(rpeaks(i)- RpeakMRI1T01Out(j));
        if minDist < min
            min = minDist;
            index = j;
        end
        
    end
    
    if length(RpeakMRI1T01Out) == 0
        break;
    end
    
    if (abs(rpeaks(i)-RpeakMRI1T01Out(index)))<150
        success = success + 1;
        RpeakMRI1T01Out(index) = [];
    end
    
    
    
    
end


metric = (success/length(originalpeaks))*100;




