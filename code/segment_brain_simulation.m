clear all
close all
clc

HomeDir='/pool-neu02/ds-neu2b/baprei-srv/Documents/MATLAB';

% add SPM 12
addpath /pool-neu02/ds-neu2b/baprei-srv/local_software/spm12/ %add SPM

SimulationDir=fullfile(HomeDir,'simulations','MNI_T1_1mm_tCS_C5_C6_iphring','subject_volumes');
TemplateDir=fullfile(HomeDir,'mri2msh');%'/usr/share/mricron/templates/ch2bet';

Filename='MNI_T1_1mm_TDCS_1_scalar_normE.nii';

Simulation=spm_read_vols(spm_vol(fullfile(SimulationDir,Filename)));
Template=spm_read_vols(spm_vol(fullfile(TemplateDir,'ch2bet.nii')));

%% use template as mask

% figure(),
% imagesc(Template(:,:,40));colorbar

V=spm_vol(fullfile(SimulationDir,Filename));
V.fname=fullfile(SimulationDir,'MNI_T1_1mm_TDCS_1_scalar_normE_segmented.nii');

Out=nan(size(Simulation));
Out(Template~=0)=Simulation(Template~=0);%assign simulation values to segmented brain

spm_write_vol(V,Out);

%% corregister to template

% use corregistration to adjust the bounding box(bb) of the image 
mbatch{1}.spm.spatial.coreg.write.ref = {fullfile(TemplateDir,'ch2bet.nii,1')};%take a beta image in the output dir as a reference
mbatch{1}.spm.spatial.coreg.write.source = {fullfile(SimulationDir,'MNI_T1_1mm_TDCS_1_scalar_normE_segmented.nii,1')};
mbatch{1}.spm.spatial.coreg.write.roptions.interp = 4;
mbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
mbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
mbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'c_';


spm_jobman('run',mbatch);




