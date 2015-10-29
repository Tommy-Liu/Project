%% prepare
clear;clc;close all;
cd D:\matlab\WaitWhat
run('D:\matlab\toolbox\matconvnet-master\matlab\vl_setupnn');
path = 'D:\matlab\data_set\Train&test_data\28x28_train';
[train_img , train_label, test_img, test_label, label_num, dir_name] = readDirImage(path);

%%
[train4D, trainLabel, test4D, testLabel] = readMNISTDataset( ...
    'D:\matlab\data_set\mnist\train-images-idx3-ubyte', ...
    'D:\matlab\data_set\mnist\train-labels-idx1-ubyte', ...
    'D:\matlab\data_set\mnist\t10k-images-idx3-ubyte', ...
    'D:\matlab\data_set\mnist\t10k-labels-idx1-ubyte');
trainLabel = trainLabel(trainLabel <= 7);
train4D = train4D(:,:,:,trainLabel <= 7);
testLabel = testLabel(testLabel <= 7);
test4D = test4D(:,:,:,testLabel <= 7);
%% set up data
train_label = train_label - 1;% shift to min 0 
test_label = test_label - 1;% shift to min 0
train_img = cat(4, train4D, train_img);
train_label = cat(1,trainLabel,train_label);
test_img = cat(4,test4D,test_img);
test_label = cat(1,testLabel,test_label);
train_num = size(train_img,4);
test_num = size(test_img,4);
save Alldata.mat train_img train_label test_img test_label train_num test_num label_num
%%
load Alldata.mat

% %% logistic regression
% traindata = zeros(size(train_img,4),size(train_img,1)*size(train_img,2));
% testdata =  zeros(size(test_img,4),size(test_img,1)*size(test_img,2));
% for i = 1:train_num
%     tmp = train_img(:,:,:,i);
%     traindata(i,:) = tmp(:);
% end
% for i = 1:label_num
%     tmp = test_img(:,:,:,i);
%     testdata(i,:) = tmp(:);
% end
% %%
% lambda = 0.1;
% W = LogisticRegression(traindata, train_label,label_num, lambda);
% %%
% tmp = [ones(size(testdata,1),1),testdata];
% res = tmp * W';
% [~, i]= max(res,[],2);
% fprintf('Accuracy: %f\n',sum(i == test_label) / size(i,1));
%% Layer setup
net = LayerSetup(label_num);
lr = 0.001;
K = 100;
%% train section
for i=1:10000
    
    index = randperm(train_num, K);
    data  = single(  train_img(:,:,:,index)  );
    label = single(  train_label(index)     );
    % è¨­å??®å?data?„label
    net.layers{end}.class = label'+ 1;
    
    % ä¸Ÿåˆ°vl_simplenn.m
    result = [];
    result = vl_simplenn(net, data, single(1), result);
    
    % é¡¯ç¤º?®å?loss
    fprintf('Iter%d, loss = %.3g, ', i, result(end).x/K);
    
    % é¡¯ç¤ºæº–ç¢ºåº?
    [~, label_p] = max(result(end-1).x,[],3); % 1 1 label_num K
    label_p = label_p - 1;
    fprintf('train acc = %4.1f%%\n', sum(label_p(:)==label)/K*100 );
    
    % ?´æ–°weights
    for l=1:numel(net.layers)
        for w=1:numel(result(l).dzdw)
            net.layers{l}.weights{w} = net.layers{l}.weights{w} - (1/K)*lr*result(l).dzdw{w};
        end
    end
end
save model.mat net
%% test section
load model.mat
totalAcc = 0;
for i = 1:test_num
    data  = single(  test_img(:,:,:,i) );
    label = single(  test_label(i) );
    
    % è¨­å??®å?data?„label
    net.layers{end}.class = label' +  1;
    
    % ä¸Ÿåˆ°vl_simplenn.m
    result = vl_simplenn(net, data);
    
    % é¡¯ç¤ºç´¯è?æº–ç¢ºåº?
    [~, label_p] = max(result(end-1).x,[],3);
    label_p = label_p - 1;
    totalAcc = totalAcc+sum(label_p(:)==label);
    if label_p(:)~=label
        imwrite(reshape(test_img(:,:,:,i),[28,28]),sprintf('D:/matlab/testwrong/%s_%d.jpg',map(label_p(:)),i));
    end
end
fprintf('test acc = %4.1f%%\n', totalAcc/i*100 );
%% test data set
dirnum = 3;
testpath = sprintf('D:/matlab/data_set/ssROI/ssA%d',dirnum);
load model.mat
raw_data_dir = dir(testpath);
raw_data_list = struct2cell(raw_data_dir(3:end));
raw_data_list = raw_data_list(1,1:end)';
testdata = zeros(28,28,1,size(raw_data_list,1),'uint8');
%% read test
for i = 1:size(raw_data_list)
    name = fullfile(testpath,raw_data_list{i});
    tmp = imread(name);
    tmp = imresize(tmp,[28,28]);
    if size(tmp,3) == 3
        tmp = rgb2gray(tmp);
    end
    testdata(:,:,:,i) = reshape(tmp,[28,28,1,1]);
end
%%
net.layers{1,8}.type = 'softmax';
res = vl_simplenn(net,single(testdata));
[~, label_p] = max(res(end-1).x,[],3);
label_p = squeeze(label_p) - 1;
list_name = raw_data_list(1:end,1);
[~, map] = mapset();
mkdir(sprintf('D:/matlab/resultA%d',dirnum));
for i = 1:size(testdata,4)
    imwrite(reshape(testdata(:,:,:,i),[28,28]),sprintf('D:/matlab/resultA%d/%s_%d.jpg',dirnum,map(label_p(i)),i));
end

