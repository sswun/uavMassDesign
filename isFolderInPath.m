function isInPath = isFolderInPath(folderPath)
    % 将输入路径转换为绝对路径
    folderPath = fullfile(pwd, folderPath);
    % 获取当前的 MATLAB 路径
    currentPath = path;
    
    % 分隔路径中的各个文件夹
    pathFolders = strsplit(currentPath, pathsep);
    
    % 判断目标文件夹是否在路径中
    isInPath = any(strcmp(pathFolders, folderPath));
end