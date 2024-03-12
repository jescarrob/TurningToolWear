function [Ff_mean,Fc_mean,Ff,Fc] = meanForces(vc,VB,f,show)
% show determines if the signal is plotted after using the function (1
% plots the signal and 0 does not)
% This function crops the force signal to the ROI based on the mean value.
% It iterates selecting values between the first and last values that
% exceed the mean value. Then iterates again using the new mean until the
% difference between the old and new mean is less than 0.5%

% Load data directly from the .mat file
filename = append('TurningTests_Forces\SS2348_v',num2str(vc),'_f0',num2str(f*10),'_ap1','_DNMG_VB',num2str(VB),'um_Force_[N]_SR_100000_LP_off_input_10V.mat');
load(filename);
time0 = fN(:,1);
Ff = fN(:,2);
Fc = fN(:,3);

% Uncomment these lines if resampling is needed
% targetSampleRate = 20000;
% [Ff,time] = resample(Ff,time0,targetSampleRate);
% [Fc,time] = resample(Fc,time0,targetSampleRate);

fN = [time,Ff,Fc];

%% Feed force

slice=fN;
mean_new = mean(slice(:,2));

dev=1;
while abs(dev)>0.005
    mean_slice = mean_new;
    slice = fN(fN(:,2)>mean_slice);
    tmin = slice(1,1);
    tmax = slice(end,1);
    slice = fN((fN(:,1)>tmin) & (fN(:,1)<tmax),:,:);
    mean_new=mean(slice(:,2));
    dev = (mean_new-mean_slice)/mean_slice;
end

Ff_mean = mean(slice(:,2));

if show == 1
    hold on
    plot(fN(:,1),fN(:,2))
    plot(slice(:,1),slice(:,2)); 
    yline(Ff_mean);
end

Ff = slice(:,2);

%% Cutting force

slice=fN;
mean_new = mean(slice(:,3));

dev=1;
while abs(dev)>0.005
    mean_slice = mean_new;
    slice = fN(fN(:,3)>mean_slice);
    tmin = slice(1,1);
    tmax = slice(end,1);
    slice = fN((fN(:,1)>tmin) & (fN(:,1)<tmax),:,:);
    mean_new=mean(slice(:,3));
    dev = (mean_new-mean_slice)/mean_slice;
end

Fc_mean = mean(slice(:,3));

if show == 1
    plot(fN(:,1),fN(:,3))
    plot(slice(:,1),slice(:,3));
    yline(Fc_mean);
    hold off
end

Fc = slice(:,3);