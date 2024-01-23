%
% example script that runs a simulation
% for a center-surround ring montage
% 
% G. Saturnino, A. Thielscher, 2018
%
%addpath /opt/simnibs3/matlab/
addpath /opt/simnibs/matlab
%addpath /opt/simnibs_2.1.2/matlab/functions/
HomeDir='/pool-neu02/ds-neu2b/baprei-srv/Documents/ElectricFieldSimulation';
cd /pool-neu02/ds-neu2b/baprei-srv/Documents/ElectricFieldSimulation/simulations
%% General information

%Subj={'ernie','basil'};
Subj={'MNI_T1_1mm'};

Current=[0.50e-3, -0.50e-3, 0.50e-3, -0.50e-3
    0.50e-3, -0.50e-3, -0.50e-3, 0.50e-3]; %1.5mA peak-to-peak

TCS={'iph','aph'};

%SimulationName='tCS_C5_C6_iph_ring';
for iTCS=1:2 %iph vs aph
    for SubjCnt=1:length(Subj)

        SimulationName=['tCS_FC5_P5_',TCS{iTCS},'ring','_050'];
        S = sim_struct('SESSION'); % Define a stimulation sessions
        S.fnamehead = fullfile(HomeDir,'mri2msh',[Subj{SubjCnt},'.msh']); % Choose the head mesh
        S.pathfem = fullfile(HomeDir,'simulations',[Subj{SubjCnt},'_',SimulationName]); % Folder for the simulation output

        %% Define the tDCS simulation
        S.poslist{1} = sim_struct('TDCSLIST');
        S.poslist{1}.currents = Current(iTCS,:);%[1.5e-3, -1.5e-3, 1.5e-3, -1.5e-3]; % Current going through each channel, in Ampere 1.5mA
        %S.poslist{1}.currents = [1e-3, -1e-3]; % Current going through each channel, in Ampere 1mA

        %% IFG
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
        S.poslist{1}.electrode(2).shape = 'ellipse'; % Elliptical shape 'rect', 'ellipse', 'custom' or ''
        S.poslist{1}.electrode(2).dimensions = [80, 80]; %Diameter of 100mm
        S.poslist{1}.electrode(2).thickness = [5, 2];
        S.poslist{1}.electrode(2).plug = sim_struct('ELECTRODE');
        S.poslist{1}.electrode(2).plug.shape = 'rect';
        S.poslist{1}.electrode(2).plug.dimensions = [13, 5];
        S.poslist{1}.electrode(2).plug.centre = [-41, 0];

        % Hole
        S.poslist{1}.electrode(2).holes(1) = sim_struct('ELECTRODE'); % Define the hole
        S.poslist{1}.electrode(2).holes(1).centre = [0,0];%'FC5'; % Hole is also centered in C3
        S.poslist{1}.electrode(2).holes(1).shape = 'ellipse'; % Shape of the hole
        S.poslist{1}.electrode(2).holes(1).dimensions = [70, 70]; % Diameter of 78mm


        %% STG
        %First Electrode (circular, central)
        S.poslist{1}.electrode(3).channelnr = 3; % Connect it to the fisrt channel (1 mA)
        S.poslist{1}.electrode(3).centre = 'P5'; % Place it over C3
        S.poslist{1}.electrode(3).shape = 'ellipse'; % Define it to be elliptical/circular
        S.poslist{1}.electrode(3).dimensions = [20, 20]; % Electrode diameter (in mm)
        S.poslist{1}.electrode(3).thickness = [5, 2]; % Electrode Electrode composed of a 5mm thick saline gel in the bottom and a 2mm thick rubber electrode on top
        S.poslist{1}.electrode(3).plug = sim_struct('ELECTRODE');
        S.poslist{1}.electrode(3).plug.shape = 'rect';
        S.poslist{1}.electrode(3).plug.dimensions = [13, 5];
        S.poslist{1}.electrode(3).plug.centre = [-5, 0];

        %Second Electrode (ring, surrounding)
        S.poslist{1}.electrode(4).channelnr = 4; %Connect it to the second channel (-1mA)
        S.poslist{1}.electrode(4).centre = 'P5'; % Place it over C3
        S.poslist{1}.electrode(4).shape = 'ellipse'; % Elliptical shape
        S.poslist{1}.electrode(4).dimensions = [80, 80]; %Diameter of 100mm
        S.poslist{1}.electrode(4).thickness = [5, 2];
        S.poslist{1}.electrode(4).plug = sim_struct('ELECTRODE');
        S.poslist{1}.electrode(4).plug.shape = 'rect';
        S.poslist{1}.electrode(4).plug.dimensions = [13, 5];
        S.poslist{1}.electrode(4).plug.centre = [-41, 0];

        % Hole
        S.poslist{1}.electrode(4).holes(1) = sim_struct('ELECTRODE'); % Define the hole
        S.poslist{1}.electrode(4).holes(1).centre = [0,0];%'FC5'; % Hole is also centered in C3
        S.poslist{1}.electrode(4).holes(1).shape = 'ellipse'; % Shape of the hole
        S.poslist{1}.electrode(4).holes(1).dimensions = [70, 70]; % Diameter of 78mm

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
end % TCS 
%mesh_get_simulation_result
