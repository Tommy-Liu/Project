function [train4D, trainLabel, test4D, testLabel] = readMNISTDataset(trainImgFile, trainLabelFile, testImgFile, testLabelFile)
    m = memmapfile(trainImgFile,'Offset', 16,'Format', {'uint8' [28 28] 'img'});
    imgData = m.Data;
    clearvars m;
    train4D = zeros(28,28,1,numel(imgData), 'uint8');
    for i=1:numel(imgData)
        train4D(:,:,1,i) = imgData(i).img';
    end

    m = memmapfile(testImgFile,'Offset', 16,'Format', {'uint8' [28 28] 'img'});
    imgData = m.Data;
    clearvars m;
    test4D = zeros(28,28,1,numel(imgData), 'uint8');
    for i=1:numel(imgData)
        test4D(:,:,1,i) = imgData(i).img';
    end

    m = memmapfile(trainLabelFile,'Offset', 8,'Format', 'uint8');
    trainLabel = m.Data;
    m = memmapfile(testLabelFile, 'Offset', 8,'Format', 'uint8');
    testLabel = m.Data;
    clearvars m;

    trainMean = mean(train4D,4);
    %train4D = bsxfun(@minus, single(train4D), trainMean);
    %test4D = bsxfun(@minus, single(test4D), trainMean);
    

end
