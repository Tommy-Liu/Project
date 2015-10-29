function [dir_name , data_list,label_list,train_total , test_total] = GetDirInfo(dirname)
%% path setup
    %dirname = 'D:\matlab\data_set\All_Train_Data';
    fprintf('Setting up path.\n');
    raw_dir = dir(dirname);
    dir_list = struct2cell(raw_dir(3:end));
    dir_name = dir_list(1,1:end)';
%% true label setup

    fprintf('Label list is setting up.\n');
    label_list = zeros(size(dir_name));
    [maps, revmaps] = MapSets();
    for i = 1:size(dir_name)
        label_list(i) = maps(dir_name{i});
        if label_list(i) == 0
            fprintf('No such label.\n');
            fprintf('%s\n',dir_name{i});
            return;
        end
    end
    fprintf('Label list is OK.');
    dir_list = fullfile(dirname , dir_name);
    data_list = cell(size(dir_list,1),1);
    fprintf('Done.\n');
    
%% concatenate string

    fprintf('Concatenating string.\n');
    total = 0;
    train_total = 0;
    test_total = 0;
    for i = 1:size(dir_list,1)
        fprintf('Dir %d.\n',i);
        raw_data_dir = dir(char(dir_list(i)));
        raw_data_list = struct2cell(raw_data_dir(3:end));
        raw_data_list = raw_data_list(1,1:end)';
        data_list{i} = cell(1,1);
        tmp = round(size(raw_data_list,1)*0.85);
        train_total = train_total + tmp;
        test_total =  test_total + size(raw_data_list,1) - tmp;
        total = total + size(raw_data_list,1);
        for j = 1:size(raw_data_list,1)
            data_list{i}{j} = fullfile(dir_list(i),raw_data_list(j));
        end
        fprintf('Dir %d done.\n',i);
    end
    fprintf('Total %d dir. Concatenating done.\n',size(dir_list,1));
end