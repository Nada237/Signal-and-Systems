%transmitter
%-------------
%time

fprintf('browse for the audio you want to transmit\n')
[file,path] = uigetfile('*.mp3');%there we can browse for mp3 files and get the file nanme and path
fname = fullfile(path,file);%here fullfile combines the path and file name in one line
[y,fs]=audioread(fname);%reading the data of the sound and getting the sampling frequency
x=y(1:5*fs,:);%taking 5 seconds from the signal as fs is (sample per sec) then it is multiplied by 
%number of seconds to get number of samples taken from the sound
% for all columns channels

fprintf('the audio is playing...\n')
sound(x,fs)%playing the 5 sec sound
pause(5)

t=linspace(0,5,5*fs);%creating time axis for the signal % determined by the num of samples
t=t';
% plotting the left and right speaker data

figure(1)

subplot(2,2,[1,2])
plot(t,x(:,1))
title('left speaker sound in time domain')

subplot(2,2,[3,4])
plot(t,x(:,2))
title('right speaker sound in time domain')
%--------------------------------------------------------------------------
%frequancy

s=linspace(-fs\2,fs\2,5*fs);%creating frequency axis for the signal 
ys=fftshift(fft(x));%appling fourier transform and fourier shift transform to get the sygnal in 
%frequency domain with its -ve and +ve components

mag_L=abs(ys(:,1));%calculating left speaker signal magnitude
mag_R=abs(ys(:,2));%calculating right speaker signal magnitude

phase_L=angle(ys(:,1));%calculating left speaker signal phase
phase_R=angle(ys(:,2));%calculating right speaker signal phase

real_ys_L=real(ys(:,1));%calculating left speaker signal real part
real_ys_R=real(ys(:,2));%calculating right speaker signal real part

imag_ys_L=imag(ys(:,1));%calculating left speaker signal imaginary part 
imag_ys_R=imag(ys(:,2));%calculating right speaker signal imaginary part

%plotting the signal components

figure(2)
%magnitude
subplot(2,2,1)
plot(s,mag_L)
title('magnitude of left speaker sound in frequency domain')

subplot(2,2,2)
plot(s,mag_R)
title('magnitude of right speaker sound in frequency domain')
%-----------------------------------------
%phase
subplot(2,2,3)
plot(s,phase_L,'r')
title('phase of left speaker sound in frequency domain')

subplot(2,2,4)
plot(s,phase_R,'r')
title('phase of right speaker sound in frequency domain')
%-----------------------------------------
figure(3)
%real part
subplot(2,2,1)
plot(s,real_ys_L)
title('real part of left speaker sound in frequency domain')

subplot(2,2,2)
plot(s,real_ys_R)
title('real part of right speaker sound in frequency domain')
%-----------------------------------------
%imaginary part
subplot(2,2,3)
plot(s,imag_ys_L,'r')
title('imaginary part of left speaker sound in frequency domain')

subplot(2,2,4)
plot(s,imag_ys_R,'r')
title('imaginary part of right speaker sound in frequency domain')

%%
%channel -- Impulse

flag_1=0;
while flag_1==0
channel = input('Select the channel: \n (1)Delta function.\n (2)exp(-2pi*5000t).\n (3)exp(-2pi*1000t).\n (4)2*delta(t)+ delta(t-1).\n');
    if channel>=1 & channel<=4
        flag_1=1;
    else
        flag_1=0;
        messagebox6=msgbox("Select the correct channel from (1 to 4) ");
    end
end


if channel == 1 % still the same
    ch = zeros(5*fs,1); %col vector due to same num element wise muti
    ch(1) = 1;
    z = zeros(length(conv(x(:,1), ch)) , 2 );
    z(:,1) = conv(x(:,1), ch);
    z(:,2) = conv(x(:,2), ch);
     
   
elseif channel == 2 % inc amp
    ch=exp(-2*pi*5000*t);
    z = zeros(length(conv(x(:,1), ch)) , 2 );
    z(:,1) = conv(x(:,1), ch);
    z(:,2) = conv(x(:,2), ch);
     
elseif channel == 3 % 
    ch=exp(-2*pi*1000*t);
    z = zeros(length(conv(x(:,1), ch)) , 2 );
    z(:,1) = conv(x(:,1), ch);
    z(:,2) = conv(x(:,2), ch);
    
elseif channel == 4 %echo
    ch=zeros(5*fs,1);
    ch(1)=2;
    ch(fs +1)=1;
    z = zeros(length(conv(x(:,1), ch)) , 2 );
    z(:,1) = conv(x(:,1), ch);
    z(:,2) = conv(x(:,2), ch);
    
end

fprintf('the convoluted audio is playing...\n')
sound(z,fs)
pause(5)
 
t=linspace(0,length(conv(x(:,1), ch))/fs,length(ch)+length(x(:,1))-1);
t=t';
 figure;
   
subplot(2,1,1)
plot(t,z(:,1))
title('left speaker of convoluted signal')

subplot(2,1,2)
plot(t,z(:,2))
title('right speaker of convoluted signal')
%%
%noise
   
fprintf('noise stage: if the value of sigma exceeds 0.1, it will damage the sound \n please enter the sigma \n')
sigma=input('');
ns=sigma*randn(1,length(z)); 
ns=ns';
z(:,1)=z(:,1)+ns;
z(:,2)=z(:,2)+ns;

fprintf('the audio with noise is playing ... \n')
sound(z,fs)
pause(10) 

figure;
   
subplot(2,1,1)
plot(t,z(:,1))
title('left speaker of the signal after adding noise in time domain')

subplot(2,1,2)
plot(t,z(:,2))
title('right speaker of the signal after adding noise in time domain')



zs=fftshift(fft(z));
s=linspace(-fs\2,fs\2,length(zs));


mag_L=abs(zs(:,1));
mag_R=abs(zs(:,2));

phase_L=angle(zs(:,1));
phase_R=angle(zs(:,2));

figure;

subplot(2,2,1)
plot(s,mag_L)
title('magnitude of left speaker after adding noise in frequency domain')

subplot(2,2,2)
plot(s,mag_R)
title('magnitude of right speaker after adding noise in frequency domain')

subplot(2,2,3)
plot(s,phase_L,'r')
title('phase of left speaker after adding noise in frequency domain')

subplot(2,2,4)
plot(s,phase_R,'r')
title('phase of right speaker after adding noise in frequency domain')

%% receiver
time=(length(zs))/fs;

limit1=(fs/2-3400)*time;
limit2=length(zs)-limit1+1;

zs([1:round(limit1) round(limit2):end],1)=0;
zs([1:round(limit1) round(limit2):end],2)=0;

zsnew=zs;

mag_L_new=abs(zsnew(:,1));
mag_R_new=abs(zsnew(:,2));

phase_L_new=angle(zsnew(:,1));
phase_R_new=angle(zsnew(:,2));

figure;

subplot(2,2,1)
plot(s,mag_L_new)
title('magnitude of left speaker after filtering noise in frequency domain')

subplot(2,2,2)
plot(s,mag_R_new)
title('magnitude of right speaker after filtering noise in frequency domain')

subplot(2,2,3)
plot(s,phase_L_new,'r')
title('phase of left speaker after filtering noise in frequency domain')

subplot(2,2,4)
plot(s,phase_R_new,'r')
title('phase of right speaker after filtering noise in frequency domain')

% time domain
znew=real(ifft(ifftshift(zsnew)));

figure;
   
subplot(2,1,1)
plot(t,znew(:,1))
title('left speaker of the signal after filter in time domain')

subplot(2,1,2)
plot(t,znew(:,2))
title('right speaker of the signal after filter in time domain')

fprintf('the audio after filteing is playing ... \n')
sound(znew,fs) 

