
function res = hosrestim(sig,sampling_frequency)

beginsample = 1; %Starting sample
endsample = length(sig); %Last sample

%Calculate the window length
winlength = floor(0.02*sampling_frequency); % 20 samples 


%Create the window now
fprintf('Creating window\n');
t = (0:winlength)/winlength;
w = 1-exp(-8*t);
w = w';
clear t; %clear t from workspace

%Calculate the duration of the R wave
Rdur = floor(0.2*sampling_frequency); % 204 samples

%Calculate the size of the detection window
wind = ceil(0.02*sampling_frequency) + 1; % 22 samples

%HPF 
input = Butterworth_HPF(sig,5,3,sampling_frequency);

%Creating the appropriate buffer 
fprintf('Initializing Buffers\n');
buffer = zeros(winlength+1+wind/2,1);
buffer(winlength+2:winlength+1+wind/2) = input(beginsample:beginsample+wind/2-1);

kudbuffer = zeros(1,wind+1);
kubuffer = zeros(1,wind+1);

q = 0.05;
x1 = 6/winlength - sqrt(24/(winlength*(1-q)));
x2 = 6/winlength + sqrt(24/(winlength*(1-q)));

skip=0;
l=1;
res(1)=0;

fprintf('Starting algorithm\n');
tic

for pos=beginsample:endsample
    if pos<endsample-wind/2
        buffer=[buffer(2:winlength+1+wind/2);input(pos+wind/2)];
    else
        buffer=[buffer(2:winlength+1+wind/2);0];
    end
        kubuffer=[kubuffer(2:wind+1),kurtosis(buffer(wind/2:winlength+wind/2).*w)];
        kudbuffer=[kudbuffer(2:wind+1),kubuffer(wind+1)-kubuffer(wind-1)];
    
        [~,kdmaxp]=max(kudbuffer);
        k=max(kubuffer);
        
        if(skip>0) 
            skip=skip-1;
        end
        if kdmaxp==(wind/2+1)  
            if k<= x1 || k>=x2 && pos>40 && skip==0 
               [~,pmax]=max(buffer(winlength-5:winlength+7));  
               res(l)=pos+pmax-7;
               fprintf('R here %d\n',res(l));
               l=l+1;
             
               skip=3*Rdur;
            end
        end
end
    
end