function dst = GuoHall(src,complement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% referenced from :                                  %
% http://opencv-code.com/quick-tips/implementation   %
% -of-guo-hall-thinning-algorithm/                   %
% Guo-Hall algorithm                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ischar(src)
    src = imread(src);
end
if complement == 1
    src = imcomplement(src);
end
if size(src,3) > 1 || ~islogical(src)
    src = im2bw(src);
end
prev = false(size(src));
src = GuoHalliter(src,0);
src = GuoHalliter(src,1);
diff = imabsdiff(src,prev);
while nnz(diff) > 0
    src = GuoHalliter(src,0);
    src = GuoHalliter(src,1);
    diff = imabsdiff(src,prev);
    prev = src;
end
dst = src;
end

function dst = GuoHalliter(src,iter)
tmp = false(size(src));
for i = 2:size(src,1)-1
    for j = 2:size(src,2)-1
        p2 = src(i-1, j);
        p3 = src(i-1, j+1);
        p4 = src(i, j+1);
        p5 = src(i+1, j+1);
        p6 = src(i+1, j);
        p7 = src(i+1, j-1);
        p8 = src(i, j-1);
        p9 = src(i-1, j-1);
        C  = (~p2 & (p3 | p4)) + (~p4 & (p5 | p6)) +(~p6 & (p7 | p8)) + (~p8 & (p9 | p2));
        N1 = (p9 | p2) + (p3 | p4) + (p5 | p6) + (p7 | p8);
        N2 = (p2 | p3) + (p4 | p5) + (p6 | p7) + (p8 | p9);
        if N1 < N2
            N = N1;
        else
            N = N2;
        end
        if iter == 0
            m = ((p6 | p7 | ~p9) & p8);
        else
            m = ((p2 | p3 | ~p5) & p4);
        end
        if (C == 1 && (N >= 2 && N <= 3) & m == 0)
            tmp(i,j) = 1;
        end
    end
end
dst = src & ~tmp;
end
% by Tommy Liu