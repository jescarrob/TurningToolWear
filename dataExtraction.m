clear all; clc;

%% Initialization
% Load surface roughness data
SurfData = readmatrix('SurfData.csv');

% Files to upload
feeds = [.2 .5];
VBs = [17 20 30 44];
vcs = [75 100 125];
i=1

% Initialize final table
sz = [24*3,13];
variableNames = ["feed","vc","VB","Phi","Audio","Ra","Rq","Rz","Rmax","Rt","class","Ff","Fc"];
variableTypes = ["double","double","double","double","cell","double","double","double","double","double","string","cell","cell"];
data = table('Size',sz,'VariableTypes',variableTypes,'VariableNames',variableNames);

%% Main

% For loop along all the files
for f = feeds
    for VB = VBs
        for vc = vcs

            % Forces
            [Ff_mean,Fc_mean,Ff,Fc] = meanForces(vc,VB,f,0);
            Phi = Fc_mean/Ff_mean;

            % Surface Roughness
            idx = find((SurfData(:,1) == vc).*(SurfData(:,2) == f).*(SurfData(:,3) == VB));
            Ra = SurfData(idx,5);
            Rq = SurfData(idx,6);
            Rz = SurfData(idx,7);
            Rmax = SurfData(idx,8);
            Rt = SurfData(idx,9);

            % Define classes ('good'/'bad') depending on VB
            if VB <=20
                class = 'good';
            elseif VB >=30
                class = 'bad';
            end

            % Audio
            [AudioData] = loadAudio(vc,VB,f,0);
            
            resto = rem(size(AudioData,1),3);       % Crop signal into 3
            AudioData = AudioData(resto+1:end);
            AudioData = reshape(AudioData,[],3);

            resto = rem(size(Ff,1),3);
            Ff = Ff(resto+1:end);
            Ff = reshape(Ff,[],3);

            resto = rem(size(Fc,1),3);
            Fc = Fc(resto+1:end);
            Fc = reshape(Fc,[],3);

            for j = 1:size(AudioData,2)
                data(3*(i-1)+j,:) = {f,vc,VB,Phi,{AudioData(:,j)},Ra,Rq,Rz,Rmax,Rt,class,{Ff(:,j)},{Fc(:,j)}};
            end
           
            i = i+1
            
        end
    end
end