folderPath = 'UAV';
if ~isFolderInPath(folderPath)
    path1 = 'UAV';
    path2 = 'Rapid_path_planning_system';
    path3 = 'function_design';
    path4 = 'Forest_environment';
    path2_1 = 'Rapid_path_planning_system\other_method';
    path2_2 = 'Rapid_path_planning_system\other_ants';
    addpath(path1)
    addpath(path2)
    addpath(path3)
    addpath(path4)
    addpath(path2_1)
    addpath(path2_2)
end