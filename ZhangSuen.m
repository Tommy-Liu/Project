function dst = ZhangSuen(src,complement)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% referenced from :                                   %
% http://opencv-code.com/quick-tips/implementation-of %
% -thinning-algorithm-in-opencv/                      %
% Zhang-Suen algorithm                                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
src = ZhangSueniter(src,0);
src = ZhangSueniter(src,1);
diff = imabsdiff(src,prev);
while nnz(diff) > 0
    src = ZhangSueniter(src,0);
    src = ZhangSueniter(src,1);
    diff = imabsdiff(src,prev);
    prev = src;
end
dst = src;
end

function dst = ZhangSueniter(src,iter)
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
        
        A  = (p2 == 0 && p3 == 1) + (p3 == 0 && p4 == 1) +...
            (p4 == 0 && p5 == 1) + (p5 == 0 && p6 == 1) + ...
            (p6 == 0 && p7 == 1) + (p7 == 0 && p8 == 1) +...
            (p8 == 0 && p9 == 1) + (p9 == 0 && p2 == 1);
        B  = p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9;
        if iter == 0
            m1 = (p2 * p4 * p6);
            m2 = (p4 * p6 * p8);
        else
            m1 = (p2 * p4 * p8);
            m2 = (p2 * p6 * p8);
        end
        if (A == 1 && (B >= 2 && B <= 6) && m1 == 0 && m2 == 0)
            tmp(i,j) = 1;
        end
    end
end
dst =  src & ~tmp;
end