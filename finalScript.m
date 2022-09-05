
%Close any serial print or plot before-hand
try
    fclose(vSerial);
    delete
catch
end

clear
clc
%indicate the name of the serial port
comPortName = 'COM3';
%create a serial port
vSerial = serial(comPortName);
%configure the serial port
set(vSerial,'BaudRate',19200);
set(vSerial,'DataBits',8);
set(vSerial,'Parity','none');
set(vSerial,'StopBits',1);


%open the serial port
fopen(vSerial);
%read a string of characters
%inputString = fgetl(vSerial)

lim1= 0;
lim2=6;
value=zeros(1,20001);
xx=0:0.025:2000;
value(1)=0;

xx=zeros(20000);

i=0;
h=figure(1);
xlim([lim1 lim2]);
ylim([0 1023]);
b=zeros(1,121);
 hold on

positionb=1;
positionx=1;
read='';
while i<10000
    % inputString(i) = fscanf(vSerial,'%d');
    tic
    i=i+1;
%    a=fgets(vSerial)
%     c=str2num(a)
%     b=str2double(a)
read=fgets(vSerial);
if strcmp('Red',read)
    i=i-1;
   disp('Red')
else
       value(i)= str2double(fgets(vSerial));
       
       b(positionb)=value(i);
end
%     try
%         value(i)=int16(fscanf(vSerial,'%d',1));
%         b(positionb)=value(i);
%         if isempty(value(i))&& i>1
%             value(i)=value(i-1);
%             b(positionb)=value(i);
%         elseif isempty(value(i)) && i==1
%             value(i)=0;
%             b(positionb)=value(i);
%         end
%     catch
%         if isempty(value(i))
%             value(i)=value(i-1);
%             b(positionb)=value(i);
%         end
%     end
    %value=int16(fscanf(vSerial,'%d'));
     if xx(i)>=lim2
%                     toc
                    lim1=lim2;
                    lim2=lim2+6;
                    positionb=1;
                    positionx=i;
                   clf(h)
%                    xlim([lim1 lim2])
%                    ylim([0 1023]);
%                   hold on
                    tic
     end
%     xlim([lim1 lim2])
     plot(xx(positionx:i),b(1:positionb),'r-');
      xlim([lim1 lim2])
                   ylim([0 1023]);
     positionb=positionb+1;
%     plot(x(positionx:i),b(1:positionb),'color','r');
       toc
       xx(i+1)=xx(i)+toc;
    pause(0.01);
    
    
end
toc
%inputString=inputString(1:2:end)
% inputString=inputString(1:end);

%close the port once you are done
fclose(vSerial);