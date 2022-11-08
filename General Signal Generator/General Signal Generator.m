
%flg : flag for checking that the frequency is correct "it should be positive number" 
%flag : flag for checking that start and end times are correct "starting time must be less than ending time"
%flag_1 :flag for checking that number of break points is correct "the number is zero or positive integer && not a fraction"
%flag_2 : flag for checking that the entered times are in ascending order
%which meanes that each break point in order has its correct time position
%flag_3 : flag for checking that the entered signal number is correct and
%exists in the range between (1 and 5)
%flag_4 : flag for checking that the entered operation number is correct
%and exists in the range between (1 and 6)

%--------------------------------------------------------------------------------------------------------------%

%Code Block 1 "Inputs"
%(freq, time period,Number and position of break points)

flg=0;
while flg==0
sampling_frequency= input('sampling frequency of signal: ');
 if sampling_frequency > 0   %check if the frequency is positive number
     flg=1;
    %-------------------------------------------------------------------------------------------------------------
        flag=0;
        while flag==0
        Start_time= input ('start time: ');
        Endtime= input ('end time: ');
    
         if (Start_time<Endtime)   % starting time must be less than ending time
             flag=1;
    %--------------------------------------------------------------------------------------------------------------
            flag_1=0;
            while flag_1==0
            Number_of_Breaks= input('enter number of breaks: ');
    
                   if Number_of_Breaks >= 0 & mod(Number_of_Breaks,1)==0 % the number is zero or positive integer && not a fraction
                       flag_1=1;
    %---------------------------------------------------------------------------------------------------------------       

                        flag_2=0;
                        while flag_2==0
                            timeOfbreaks= zeros(1, Number_of_Breaks);

                                for i=1:Number_of_Breaks
                                     fprintf('enter time of breakpoint number (%d)\n ',i)
                                     timeOfbreaks(i)=input('');
                                end

                            if length(timeOfbreaks)==0 || length(timeOfbreaks)==1
                                flag_2=1;
                            else
                        
                                for j=1:length(timeOfbreaks)-1 
                                     if timeOfbreaks(j) < timeOfbreaks(j+1) %checking that the entered times are in ascending order
                                         flag_2=1;
                                     else
                                         flag_2=0;
                                         messagebox4=msgbox("enter the times in ascending order")
                                         break
                                     end
                                end
                            end
    %-----------------------------------------------------------------------------------------------------------------------       
                        end

				   else                      
                        Message3=msgbox("breakpoints be POSITIVE INTEGER")
                   end
            end 

		 else
            Message2=msgbox("start time should be bigger than end time")
         end

        end		

 else
     Message1=msgbox("sampling frequency must be positive integer")
 end
end
%-----------------------------------------------------------------------------------------------------------------%

%Code Block 2 "setting time axis && taking the signal type" 
                              
new_timeOfbreaks=[Start_time timeOfbreaks Endtime];
timeFn= cell(1,length(new_timeOfbreaks)-1); 
sig_type=zeros(1,length(new_timeOfbreaks)-1);

for k=1:1:length(new_timeOfbreaks)-1 
    t_start = new_timeOfbreaks(k);
    t_end = new_timeOfbreaks(k+1);
    timeFn{1,k}=linspace(t_start,t_end,(t_end-t_start)*sampling_frequency);
end 
flag_3=0
while flag_3==0
    for o=1:1:length(new_timeOfbreaks)-1
         fprintf('write the digit of the signal number (%d): \n (1)DC \n (2)Ramp \n (3)Polynomial \n (4)Exponential \n (5)Sinusoidal \n',o);
         sig_type(o)=input('');
    end

    for p=1:1:length(new_timeOfbreaks)-1
         if sig_type(p)>=1 & sig_type(p)<=5
             flag_3=1;
         else 
             flag_3=0;
             messagebox5=msgbox("choose the correct signal number from (1 to 5) ");
             break
         end
    end
end
%-------------------------------------------------------------------------------------------------------------------------%

%Code Block 3 "creating the signal"
sig= cell(1,length(new_timeOfbreaks)-1);

for l=1:length(new_timeOfbreaks)-1
    fprintf('Signal number (%d) :\n',l);
    if sig_type(l)==1
        amplitude=input('enter the amplitude');
        sig{1,l}=amplitude*ones(1,length(timeFn{1,l}));
    elseif sig_type(l)==2
        slope=input('enter the slope');
        intercept=input('enter the intercept');
        sig{1,l}=slope*timeFn{1,l}+intercept;
        %plot(t,x)
    elseif sig_type(l)==3
        amplitude=input('enter the amplitude');
        power=input('enter the power');
        intercept=input('enter the intercept');
        sig{1,l}=amplitude*timeFn{1,l}.^power+intercept;
        %plot(t,x)
    elseif sig_type(l)==4
        amplitude=input('enter the amplitude');
        exponent=input('enter the exponent');
        sig{1,l}=amplitude*exp(exponent*timeFn{1,l});
        %plot(t,x)
    elseif sig_type(l)==5
        amplitude=input('enter the amplitude');
        frequency=input('enter the frequency');
        phase=input('enter the phase');
        sig{1,l}=amplitude*sin(2*pi*frequency*timeFn{1,l}+phase);
        %plot(t,x)
    end
end
%---------------------------------------------------------------------------------------------------------------------%

%Code Block 4 "concatnition of time & signal"
time=[];
signal=[];

for m=1:length(timeFn)
time=[time timeFn{1,m}(1:end)];
end

for n=1:length(sig)
signal=[signal sig{1,n}(1:end)];
end
%-----------------------------------------------------------------------------------------------------------------------%

%Code Block 5 "visualization and plotting of original signal" 
figure
plot(time,signal);
%-----------------------------------------------------------------------------------------------------------------------%

%Code Block 6 "operations on signal" 
flag_4=0

while flag_4==0
fprintf('Select the operation: \n (1)Amplitude Scaling. \n (2)Time Reversal\n (3)Time Shift\n (4)Expanding the signal\n (5)Compressing the Signal\n (6)None\n ');
operation_type = input('');
    if operation_type>=1 & operation_type<6
       
                    fprintf('enter operation information');
            
            if operation_type == 1
                scale = input('Amplitude Scaling : \nScale value: ');
                signal = signal*scale;
            elseif operation_type == 2
                time=-time;
            elseif operation_type == 3
                shift = input('Time Reversal : \n Shift value: ');
                time = time+shift;
            elseif operation_type == 4
                expand = input('Expanding the signal : \n Expanding value: ');
                time = time/expand;
            elseif operation_type == 5
                copress = input('Compressing the Signal : \n Compressing value: ');
                time = time/copress;
            elseif operation_type == 6
                signal=signal;
                fprintf('the signal did not change' )
            end 
            %------------------------------------------------------------------------------
            %Code Block 7 "visualization and plotting after operations"
            figure
            plot(time,signal);
            %------------------------------------------------------------------------------
    elseif operation_type==6
        flag_4=1;
    else
        flag_4=0;
        messagebox6=msgbox("choose the correct operation number from (1 to 6) ");
    end
end

%--------------------------------------------------------------------------------------------------------%






           
    
    
                             
                    
                
            
           
            


