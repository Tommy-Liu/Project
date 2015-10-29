function [hori_points, vert_points]= findMid(img)
    hori_points = {};
    vert_points = {};
    flag = false;
    for i = 1:size(img,1)
        for j = 1:size(img,2)
            if img(i,j) > 0 && flag == false
                flag = true;
                head = [i,j];
            end
            if img(i,j) == 0 && flag == true
                flag = false;
                tail = [i,j];
                hori_points{end + 1,1} = round((head + tail)/2);
            end
        end
    end
    flag = false;
    for i = 1:size(img,2)
        for j = 1:size(img,1)
            if img(j,i) > 0 && flag == false
                flag = true;
                head = [j,i];
            end
            if img(j,i) == 0 && flag == true
                flag = false;
                tail = [j,i];
                vert_points{end + 1,1} = round((head + tail)/2);
            end
        end
    end
end