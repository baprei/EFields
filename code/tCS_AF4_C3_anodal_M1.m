%
% example script that runs a simulation
% for a center-surround ring montage
% 
% G. Saturnino, A. Thielscher, 2018
%
%addpath /opt/simnibs3/matlab/
addpath /opt/simnibs3/simnibs/matlab/ % add path simnibs 3
%addpath /opt/simnibs_2.1.2/matlab/functions/
HomeDir='/pool-neu02/ds-neu2b/baprei-srv/Documents/MATLAB';
cd /pool-neu02/ds-neu2b/baprei-srv/Documents/MATLAB/simulations
%% General information

Subj={'MNI_T1_1mm'};
Electrode_Montage='tCS_AF4_C3_PNAS_review';

Current=[1e-3, -1e-3]; %2mA peak-to-peak



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

ElectrodePositions={'AF4','C3'}; %Frist electrode is the center

for i=1:length(ElectrodePositions)
    S.poslist{1}.electrode(i).channelnr = i; % Connect it to the fisrt channel (1 mA)
    S.poslist{1}.electrode(i).centre = ElectrodePositions{i}; % Place it over C3
    S.poslist{1}.electrode(i).shape = 'rect'; % Define it to be elliptical/circular
    S.poslist{1}.electrode(i).dimensions = [50, 70]; % Electrode diameter (in mm)
    S.poslist{1}.electrode(i).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
    S.poslist{1}.electrode(i).plug = sim_struct('ELECTRODE');
    S.poslist{1}.electrode(i).plug.shape = 'rect';
    S.poslist{1}.electrode(i).plug.dimensions = [13, 5]; %all plugs are oriented perpedicular to the ground
    S.poslist{1}.electrode(i).plug.centre = [-5, 0];
end

%         S.poslist{1}.electrode(1).channelnr = 1; % Connect it to the fisrt channel (1 mA)
%         S.poslist{1}.electrode(1).centre = 'T7'; % Place it over C3
%         S.poslist{1}.electrode(1).shape = 'rect'; % Define it to be elliptical/circular
%         S.poslist{1}.electrode(1).dimensions = [50, 50]; % Electrode diameter (in mm)
%         S.poslist{1}.electrode(1).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
%         S.poslist{1}.electrode(1).plug = sim_struct('ELECTRODE');
%         S.poslist{1}.electrode(1).plug.shape = 'rect';
%         S.poslist{1}.electrode(1).plug.dimensions = [13, 5];
%         S.poslist{1}.electrode(1).plug.centre = [-5, 0];


    %% save simulation as .nii
    S.map_to_vol=1;
    %% Run Simulation

    run_simnibs(S);


    %% Visualize Simulations
    %S.pathfem = fullfile(HomeDir,'simulations',['s',Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output
    cd(S.pathfem);
    m = mesh_load_gmsh4([Subj{SubjCnt},'_','TDCS_1_scalar.msh']);
    mesh_show_surface(m);
end % loop Subj
 % TCS 
%mesh_get_simulation_result
