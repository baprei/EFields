%
% example script that runs a simulation
% for a center-surround ring montage
% 
% G. Saturnino, A. Thielscher, 2018
%
addpath /opt/simnibs/matlab
HomeDir='/pool-neu02/ds-neu2b/baprei-srv/Documents/ElectricFieldSimulation';
cd /pool-neu02/ds-neu2b/baprei-srv/Documents/ElectricFieldSimulation/simulations
%% General information

Subj={'MNI_T1_1mm'};
SimulationName='tCS_FC5_ring_whole_dorsal';

for SubjCnt=1:length(Subj)

    
    S = sim_struct('SESSION'); % Define a stimulation sessions
    S.fnamehead = fullfile(HomeDir,'mri2msh',[Subj{SubjCnt},'.msh']); % Choose the head mesh
    S.pathfem = fullfile(HomeDir,'simulations',[Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output

    %% Define the tDCS simulation
    S.poslist{1} = sim_struct('TDCSLIST');
    S.poslist{1}.currents = [1e-3, -1e-3]; % Current going through each channel, in Ampere

    %% left hemisphere FC5
    %First Electrode (circular, central)
    S.poslist{1}.electrode(1).channelnr = 1; % Connect it to the fisrt channel (1 mA)
    S.poslist{1}.electrode(1).centre = 'FC5'; % Place it over C3
    S.poslist{1}.electrode(1).shape = 'ellipse'; % Define it to be elliptical/circular
    S.poslist{1}.electrode(1).dimensions = [20, 20]; % Electrode diameter (in mm)
    S.poslist{1}.electrode(1).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
    S.poslist{1}.electrode(1).plug = sim_struct('ELECTRODE');
    S.poslist{1}.electrode(1).plug.shape = 'rect';
    S.poslist{1}.electrode(1).plug.dimensions = [13, 5];
    S.poslist{1}.electrode(1).plug.centre = [-5, 0];

    %Second Electrode (ring, surrounding)
    S.poslist{1}.electrode(2).channelnr = 2; %Connect it to the second channel (-1mA)
    S.poslist{1}.electrode(2).centre = 'FC5'; % Place it over C3
    S.poslist{1}.electrode(2).shape = 'ellipse'; % Elliptical shape
    S.poslist{1}.electrode(2).dimensions = [100, 100]; %Diameter of 100mm
    S.poslist{1}.electrode(2).thickness = [5, 2];
    S.poslist{1}.electrode(2).plug = sim_struct('ELECTRODE');
    S.poslist{1}.electrode(2).plug.shape = 'rect';
    S.poslist{1}.electrode(2).plug.dimensions = [13, 5];
    S.poslist{1}.electrode(2).plug.centre = [41, 0];

    % Hole on outter electrode ring
    S.poslist{1}.electrode(2).holes(1) = sim_struct('ELECTRODE'); % Define the hole
    S.poslist{1}.electrode(2).holes(1).centre = [-42, 0]; % Hole is also centered in C3
    S.poslist{1}.electrode(2).holes(1).shape = 'rect'; % Shape of the hole
    S.poslist{1}.electrode(2).holes(1).dimensions = [18, 15]; % Diameter of 75mm

    % Hole inner electorde ring
    %S.poslist{1}.electrode(2).holes(2) = sim_struct('ELECTRODE'); % Define the hole
    S.poslist{1}.electrode(2).holes(2).centre = [0,0];%'FC5'; % Hole is also centered in C3
    S.poslist{1}.electrode(2).holes(2).shape = 'ellipse'; % Shape of the hole
    S.poslist{1}.electrode(2).holes(2).dimensions = [75, 75]; % Diameter of 75mm
    %% save simulation as .nii
    S.map_to_vol=1;


    %% Run Simulation
    run_simnibs(S);


    %% Visualize Simulations
    cd(S.pathfem);
    %cd(fullfile(HomeDir,'simnibs_examples',['s',Subj{SubjCnt},'_','tcs_FC5_ring_whole_tw_ground']));
    m = mesh_load_gmsh4([Subj{SubjCnt},'_','TDCS_1_scalar.msh']);
    mesh_show_surface(m);
end
%mesh_get_simulation_result
