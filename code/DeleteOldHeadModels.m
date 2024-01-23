clear all
close all
clc


% HomeDir
HomeDir='/p01-hdd/dsa/baprei-srv/Documents/FrontiersSpecialIssue';
DataDir='1_FirstLevel_GLM';

% load participants fMRI
t=readtable(fullfile(HomeDir,'participants_incl_fMRI.txt'));
Sample=t.participant_id;

FolderToDelete={'decoding_acoustic_crossnobis_xclass','decoding_acoustics', ...
    'decoding_percept','decoding_percept_crossnobis_xclass','decoding_unamb_stimulus','firstlevel_glm_sS'};

for SubjCnt=1:length(Sample)
    
    %DirPath=fullfile(HomeDir,Sample{SubjCnt});
    
    for i=1:length(FolderToDelete)
        Dir2remove=fullfile(HomeDir,Sample{SubjCnt},FolderToDelete{i});

        if exist(Dir2remove) ~= 0
             rmdir(Dir2remove, 's')
        end
        
    end
end

% FolderToRename={'decoding_percept_roi_GA_crossnobis_xclass_cv','decoding_percept_roi_DA_crossnobis_xclass_cv'};
% NewFolderNames={'decoding_acoustic_roi_GA_crossnobis_xclass_cv','decoding_acoustic_roi_DA_crossnobis_xclass_cv'};
% 
% for SubjCnt=1:length(Sample)
%         
%     for i=1:length(FolderToRename)
%         
%         Dir2rename=fullfile(HomeDir,Sample{SubjCnt},FolderToRename{i});
%         Newname=fullfile(HomeDir,Sample{SubjCnt},NewFolderNames{i});
%         
%         if exist(Dir2rename) ~= 0
%              movefile(Dir2rename,Newname);
%         end
%         
% 
%         
%     end
% end


        
        
        


