function justReadDirImage(dirname)
[dir_name , data_list] = getdir(dirname);
for i = 1:length(data_list)
    tmp = data_list{i};
    index = randperm(length(tmp),10);
   for j = 1:10
       im = rgb2gray(imread(char(tmp{index(j)})));
       im = imresize(im,[28,28]);
       histeq(im);
       imshow(im,'InitialMagnification',400);
       pause(0.5);
   end
end
end