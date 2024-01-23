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

Current=[1.0e-3, -1.0e-3]; %1.5mA

%TCS={'iph','aph'};

%SimulationName='tCS_C5_C6_iph_ring';
%for iTCS=1:2 %iph vs aph
    for SubjCnt=1:length(Subj)

        SimulationName=['tCS_T7_Cz_rect'];
        S = sim_struct('SESSION'); % Define a stimulation sessions
        S.fnamehead = fullfile(HomeDir,'mri2msh',[Subj{SubjCnt},'.msh']); % Choose the head mesh
        S.pathfem = fullfile(HomeDir,'simulations',[Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output

        %% Define the tDCS simulation
        S.poslist{1} = sim_struct('TDCSLIST');
        S.poslist{1}.currents = Current;%[1.5e-3, -1.5e-3, 1.5e-3, -1.5e-3]; % Current going through each channel, in Ampere 1.5mA
        %S.poslist{1}.currents = [1e-3, -1e-3]; % Current going through each channel, in Ampere 1mA

        %% left hemisphere T7
        %First Electrode (circular, central)
        S.poslist{1}.electrode(1).channelnr = 1; % Connect it to the fisrt channel (1 mA)
        S.poslist{1}.electrode(1).centre = 'T7'; % Place it over C3
        S.poslist{1}.electrode(1).shape = 'rect'; % Define it to be elliptical/circular
        S.poslist{1}.electrode(1).dimensions = [50, 50]; % Electrode diameter (in mm)
        S.poslist{1}.electrode(1).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
        S.poslist{1}.electrode(1).plug = sim_struct('ELECTRODE');
        S.poslist{1}.electrode(1).plug.shape = 'rect';
        S.poslist{1}.electrode(1).plug.dimensions = [13, 5];
        S.poslist{1}.electrode(1).plug.centre = [-5, 0];




        %% right hemisphere Cz
        %First Electrode (circular, central)
        S.poslist{1}.electrode(2).channelnr = 2; % Connect it to the fisrt channel (1 mA)
        S.poslist{1}.electrode(2).centre = 'Cz'; % Place it over C3
        S.poslist{1}.electrode(2).shape = 'rect'; % Define it to be elliptical/circular
        S.poslist{1}.electrode(2).dimensions = [50, 70]; % Electrode diameter (in mm)
        S.poslist{1}.electrode(2).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
        S.poslist{1}.electrode(2).plug = sim_struct('ELECTRODE');
        S.poslist{1}.electrode(2).plug.shape = 'rect';
        S.poslist{1}.electrode(2).plug.dimensions = [13, 5];
        S.poslist{1}.electrode(2).plug.centre = [-5, 0];



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
%end % TCS 
%mesh_get_simulation_result
