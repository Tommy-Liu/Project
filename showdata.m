function showdata(data,label)
    [~, revmap] = mapset();
    num = 10;
    index = randperm(size(data,4) , num);
    for i = 1:10
        tmp = reshape(data(:,:,:,index(i)),[28,28]);
        tmp = imadjust(tmp);
        figure,imshow(tmp);
        title(sprintf('%s',revmap(label(index(i)))));
    end
end