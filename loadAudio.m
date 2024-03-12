function [AudioData] = loadAudio(vc,VB,f,show)
% show determines if the signal is plotted after using the function (1
% plots the signal and 0 does not)
    
% Load already cropped data from a .mat file 
filename = append('TurningTest_Audio\SS2348_v',num2str(vc),'_f0',num2str(f*10),'_ap1','_DNMG_VB',num2str(VB),'um.mat');
AudioData = load(filename);
fns = fieldnames(AudioData);
AudioData = AudioData.(fns{1});


fs = 48000;
time = linspace(0,length(AudioData)/fs,length(AudioData));

% Plot the results
if show == 1
    plot(time,AudioData)
    xlabel('time (s)')
    ylabel('Intensity')
end