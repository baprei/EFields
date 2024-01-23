%
% example script that runs a simulation
% for a center-surround ring montage
% 
% G. Saturnino, A. Thielscher, 2018

addpath /opt/simnibs/matlab
HomeDir='/p01-hdd/dsa/baprei-srv/Documents/ElectricFieldSimulation/';
cd /p01-hdd/dsa/baprei-srv/Documents/ElectricFieldSimulation/simulations
%% General information

Subj={'MNI_T1_1mm'};
Electrode_Montage='exp3_CP3_4_1_CPz_PO3_TP7_FC3';

% This is a simulation of the electrode Montage from Wöstmann et al., 2018
% Brain Stimulation


Current=[1e-3, -0.25e-3, -0.25e-3, -0.25e-3, -0.25e-3]; %2mA peak-to-peak



for SubjCnt=1:length(Subj)

    SimulationName=[Electrode_Montage,'_',num2str(Current(1)*1000),'mA'];
    S = sim_struct('SESSION'); % Define a stimulation sessions
    S.fnamehead = fullfile(HomeDir,'mri2msh',[Subj{SubjCnt},'.msh']); % Choose the head mesh
    S.pathfem = fullfile(HomeDir,'simulations',[Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output

    %% Define the tDCS simulation
    S.poslist{1} = sim_struct('TDCSLIST');
    S.poslist{1}.currents = Current;%[1.5e-3, -1.5e-3, 1.5e-3, -1.5e-3]; % Current going through each channel, in Ampere 1.5mA
    %S.poslist{1}.currents = [1e-3, -1e-3]; % Current going through each channel, in Ampere 1mA

%% left hemisphere center FC5 surrounded by 4 return electrodes
%First Electrode (circular, central)

ElectrodePositions={'CP3','TP7','CPz','PO3','TP7'}; %Frist electrode is the center

%ElectrodePositions={'CP1','P3','Pz','Cz','C3'};

for i=1:length(ElectrodePositions)
    S.poslist{1}.electrode(i).channelnr = i; % Connect it to the fisrt channel (1 mA)
    S.poslist{1}.electrode(i).centre = ElectrodePositions{i}; % Place it over C3
    S.poslist{1}.electrode(i).shape = 'ellipse'; % Define it to be elliptical/circular
    S.poslist{1}.electrode(i).dimensions = [25, 25]; % Electrode diameter (in mm)
    S.poslist{1}.electrode(i).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
    S.poslist{1}.electrode(i).plug = sim_struct('ELECTRODE');
    S.poslist{1}.electrode(i).plug.shape = 'rect';
    S.poslist{1}.electrode(i).plug.dimensions = [13, 5]; %all plugs are oriented perpedicular to the ground
    S.poslist{1}.electrode(i).plug.centre = [-5, 0];
end

    %% save simulation as .nii
    S.map_to_vol=1;
    %% Run Simulation

    run_simnibs(S);


    %% Visualize Simulations
    %S.pathfem = fullfile(HomeDir,'simulations',[Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output
    cd(S.pathfem);
    m = mesh_load_gmsh4([Subj{SubjCnt},'_','TDCS_1_scalar','.msh']);
    mesh_show_surface(m);
end % loop Subj
 % TCS 
%mesh_get_simulation_result
