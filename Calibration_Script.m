clear
clc

satur=[40:5:80,81:100];
% morethan1sample=[82,86,90,94,98];
stat{1,2}='LogSat';
stat{1,3}='NormalSat';
stat{1,4}='HeartRate';

for i=1:length(satur)
    clearvars -except morethan1sample stat satur i o2sat1 o2sat2
    %     if ismember(satur(i),morethan1sample)
    
    load([num2str(satur(i)) '_alight_60bpm_1']);
    o2sat2(i,1)=satur(i);
    
    for j=1:3
        %     stat{1+i,1}=(satur(i));
        tic
        index0=find(value==0,j+1);
        
        
        ind_diff=[];
        
        pulsex=value(index0(j):index0(j+1));
        plot(pulsex)
        
        pulsex(1)=pulsex(2); %Eliminate 1st zero value
        pulsex(length(pulsex))=pulsex(length(pulsex)-1); %Eliminate last zero value
        
        index1x=find(pulsex==1);
        
        a=10; %time delay before light change
        
        %Find the peaks for red light (and relative min for amplitude)
        maxredp=max(pulsex(1:(index1x-a)));
        
        thr=0.85; %Threshold over the max peak to be used.
        [redp,indexredp]=findpeaks(pulsex(1:(index1x-a)),'MinPeakHeight',thr*maxredp);
        minredp=min(pulsex(indexredp(1):indexredp(length(indexredp)))); %minimum between the first and last peaks of red light
        
        %Find the peaks for Ired light
        maxIredp=max(pulsex((index1x+a):(length(pulsex)-1)));
        
        [Iredp,indexIredp]=findpeaks(pulsex((index1x+a):(length(pulsex)-1)),'MinPeakHeight',thr*maxIredp);
        indexIredp=indexIredp+(index1x+a-1); %Scale the indexes of the Ired peak
        
        minIredp=min(pulsex(indexIredp(1):indexIredp(length(indexIredp)))); %minimum between the first and last peaks of red light
        
        %Average red and Ired peaks
        redpav=mean(redp);
        Iredpav=mean(Iredp);
        
        %Find the amplitude of red and Ired lights
        amplred=redpav-minredp;
        amplIred=Iredpav-minIredp;
        
        %Find the relative DC component
        DCredtotal=mean(pulsex(1:(index1x-a))); %DC Component of red light
        DCred=DCredtotal;%-minredp;
        
        DCIredtotal=mean(pulsex((index1x+a):(length(pulsex)))); %DC Component of Ired light
        DCIred=DCIredtotal;%-minIredp;
        
        %Calculation of Ox. Saturation
        o2sat2(i,j+4)=log10(amplIred/DCIred)/log10(amplred/DCred);
        
        o2sat2(i,j+1)=(amplred/DCred)/(amplIred/DCIred);
        if o2sat2(i,j+1)>10
            o2sat2(i,j+1)=NaN;
        end
        if o2sat2(i,j+4)>10 || o2sat2(i,j+4) < -100
            o2sat2(i,j+4)=NaN;
        end
        %         stat{1+i,2}=(o2sat1(i));
        %         stat{1+i,3}=(o2sat2(i));
        
        %Heart rate calculation
        for j=2:length(indexIredp)
            ind_diff(j-1)=(indexIredp(j)-indexIredp(j-1));
        end
        
        for l=2:length(indexredp)
            ind_diff(j+l-2)=(indexredp(l)-indexredp(l-1));
        end
        heart_rate=floor(60/(mean(ind_diff)*0.05));
        %         stat{1+i,4}=heart_rate;
        
        
    end
end

for s=1:length(o2sat2)
    final(s,1)=o2sat2(s,1);
    final(s,2)=nanmean(o2sat2(s,2:4));
    final(s,3)=nanmean(o2sat2(s,5:7));
end

plot(final(:,1),final(:,2),'o')
figure
plot(final(:,1),final(:,3),'o')

