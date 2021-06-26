% Load signals from 1T MRI
[ECGMRI1T01Out,FsECGMRI1T01Out,~]=rdsamp('database/ECGMRI1T01Out' , 1 ) ; 
[ECGMRI1T01Pro,FsECGMRI1T01Pro,~]=rdsamp('database/ECGMRI1T01Pro' , 1 ) ; 
[ECGMRI1T01Sup,FsECGMRI1T01Sup,~]=rdsamp('database/ECGMRI1T01Sup' , 1 ) ; 

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




