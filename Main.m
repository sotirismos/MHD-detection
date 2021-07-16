% Data
[ECGMRI1T01Out,FsECGMRI1T01Out,~]=rdsamp('database/ECGMRI1T01Out' , 1 ) ; 
[ECGMRI1T01Sup,FsECGMRI1T01Sup,~]=rdsamp('database/ECGMRI1T01Sup' , 1 ) ; 
[ECGMRI1T01Pro,FsECGMRI1T01Pro,~]=rdsamp('database/ECGMRI1T01Pro' , 1 ) ; 

% fs: sampling frequency
fs = FsECGMRI1T01Out;

% Plot the signals
%{
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

% Interpolation to bring them to same sample sizes and cut the final samples

f = ceil(size(ECGMRI1T01Sup,1)/size(cd7,1));
cd7 = interp(cd7,f);
cd7 = cd7(1:size(ECGMRI1T01Sup,1));

data = cd7; % Fill in the signal you want to analyze

y = data-mean(data);
y = y/max(abs(y));

% Call hosrestim for the estimation of the R-peaks
RpeakEst = hosrestim(y,fs);    

% Read original peaks
originalpeaks = rdann('database/ECGMRI1T01Out', 'qrs');

success = 0;
failure = 0;

% Metric (Searching for the peaks that were found with a tolerance)

for i=1:length(RpeakEst)
    min = 100000;
    for j=1:length(originalpeaks)
        minDist = abs(RpeakEst(i)- originalpeaks(j));
        if minDist < min
            min = minDist;
            index = j;
        end
    end
    
    if isempty(originalpeaks)
        break;
    end

    %tolerance (350 in order to have the best metric,  around 90%)
    if (abs(RpeakEst(i)-originalpeaks(index))) < 350
        success = success + 1;
        originalpeaks(index) = [];
    else
        failure = failure + 1;
    end
end

% Positive predictive value
metric = (success/(success+failure))*100;

% Reconstruct 
% y = wrcoef('d',c,l,'bior1.5',7);

% Question 3
% qpc_detection(y,fs) % We should pass the reconstructed signal




