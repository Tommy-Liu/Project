function [train_data ,train_label ,test_data,test_label , label_num, dir_name] = readDirImage(path,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% data are images as a 4-D array, and label is a array. label_num %
% is the number of label, and total is the number of total image. %
% image_size : The size which you want to resize the data to.     %
% padding    : add padding                                        %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% var setup

if nargin > 1
    % image size which u want to resize by
    image_size = varargin{1};
    if nargin > 2
        % image padding size
        padding = varargin{2};
        ispadding = 1;
    end
else
    % default
    image_size = 28;
    padding = 4;
    ispadding = 0;
end
% original size
orig_size = image_size - 2 * padding;

%% path setup

%path = 'D:\matlab\data_set\All_Train_Data';
[dir_name , data_list,label_list,train_total , test_total] = GetDirInfo(path);
%% read image and add padding

% Setup variables
fprintf('Reading image and padding section.\n');
train_data = zeros(image_size,image_size,1,train_total,'uint8');
train_label = zeros(train_total,1);
train_k = 1;

test_data = zeros(image_size,image_size,1,test_total,'uint8');
test_label = zeros(test_total,1);
test_k = 1;

if ispadding == 0 % not use padding
    fprintf('Reading image without no padding.\n');
    for i = 1:size(data_list,1)
        fprintf('Reading Dir %d.\n',i);
        train = round(size(data_list{i},2)*0.85);
        fprintf('Reading train %d.\n',i);
        for j = 1:train
            tmp = imread(char(data_list{i}{j}));
            tmp = imresize(tmp,[image_size,image_size],'bilinear');
            if size(tmp,3) == 3
                tmp = rgb2gray(tmp);
            end
            train_data(:,:,:,train_k) = reshape(tmp,[image_size,image_size,1,1]);
            train_label(train_k) = label_list(i);
            train_k = train_k + 1;
        end
        fprintf('\nReading train %d done.\n',i);
        fprintf('Reading test %d.\n',i);
        for j = train + 1:size(data_list{i},2)
            tmp = imread(char(data_list{i}{j}));
            tmp = imresize(tmp,[image_size,image_size],'bilinear');
            if size(tmp,3) == 3
                tmp = rgb2gray(tmp);
            end
            test_data(:,:,:,test_k) = reshape(tmp,[image_size,image_size,1,1]);
            test_label(test_k) = label_list(i);
            test_k = test_k + 1;
        end
        fprintf('\nReading test %d done.\n',i);
        fprintf('Reading Dir %d done\n',i);
    end
else  % use padding
    fprintf('Reading image with padding.\n');
    for i = 1:size(data_list,1)
        fprintf('Reading Dir %d.\n',i);
        train = round(size(data_list{i},2)*0.85);
        fprintf('Reading train %d.\n',i);
        for j = 1:train
            tmp = imread(char(data_list{i}{j}));
            tmp = imresize(tmp,[orig_size,orig_size],'bilinear');
            if size(tmp,3) == 3
                tmp = rgb2gray(tmp);
            end
            train_data(:,:,:,train_k) = padarray(tmp,[padding,padding]);
            train_label(train_k) = label_list(i);
            train_k = train_k + 1;
        end
        fprintf('\n\nReading train %d done.\n',i);
        fprintf('Reading test %d.\n',i);
        for j = train + 1:size(data_list{i},2)
            tmp = imread(char(data_list{i}{j}));
            tmp = imresize(tmp,[orig_size,orig_size],'bilinear');
            if size(tmp,3) == 3
                tmp = rgb2gray(tmp);
            end
            test_data(:,:,:,test_k) = padarray(tmp,[padding,padding]);
            test_label(test_k) = label_list(i);
            test_k = test_k + 1;
        end
        fprintf('\n\nReading test %d done.\n',i);
        fprintf('Reading Dir %d done.\n',i);
    end
end
label_num = size(data_list,1);
end