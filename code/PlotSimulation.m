%% simnibs results visualization

clear all
close all
clc


%addpath /opt/simnibs3/matlab/
addpath /opt/simnibs3/simnibs/matlab/ % add path simnibs 3

HomeDir='/pool-neu02/ds-neu2b/baprei-srv/Documents/MATLAB';
cd /pool-neu02/ds-neu2b/baprei-srv/Documents/MATLAB/simulations/MNI_T1_1mm_tCS_CP5_CP6_iphring
%% General information

Subj={'MNI_T1_1mm'};


m = mesh_load_gmsh4([Subj{:},'_','TDCS_1_scalar.msh']);
%mesh_show_surface(m);

%mesh_show_surface(m,'field_idx','normE','region_idx',1002,'facealpha',1,'haxis','121'); % plots normJ on white matter
mesh_show_surface(m,'field_idx','normE','region_idx',1002,'facealpha',1); % plots normJ on white matter
v = [-88 22 -5];
[caz,cel] = view(v);

mesh_show_surface(m,'field_idx','normE','region_idx',1002,'facealpha',1); % plots normJ on white matter
v = [90 -22 0];
[caz,cel] = view(v);