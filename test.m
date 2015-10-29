%%
im = imread('D:\matlab\data_set\image\A.png');
im = im2bw(im);
im = imcomplement(im);
%figure,imshow(im);
%[gx ,gy] = gradient(double(im));
[Gmag,Gdir] = imgradient(im); 
%%
im_sobel = cv.Sobel(im,'XOrder',1,'YOrder',0);
figure,imshow(im_sobel);
%%
figure,imshowpair(Gmag, Gdir, 'montage');
im_dir_x = cos(Gdir);
im_dir_y = sin(Gdir);
figure,quiver(fliplr(rot90(-im_dir_x,2)),fliplr(rot90(-im_dir_y,2)));
%im_perim = bwperim(im);
%imshow(im_perim);
%%
[points_h, points_v] = findmid(im);
point_v = squeeze_1dfixed_cell(points_v);
point_h = squeeze_1dfixed_cell(points_h);
imshow(im);
hold on
scatter(point_h(:,2),point_h(:,1),'r*');
scatter(point_v(:,2),point_v(:,1),'g*');
%im_cor = corner(im);
%for i = 1:size(im_cor,1)
%    text(im_cor(i,1),im_cor(i,2),sprintf('%d',i),'color','g');
%end
%%
C = bwboundaries(im,'holes');
C = squeeze_1dfixed_cell(C);
boundaryDir = zeros(size(C,1),1);
for i = 1:size(C,1)
   Gdirx(1) = max(C(i,2) - 2,1);
   Gdirx(2) = min(C(i,2) + 2,size(im,2));
   Gdiry(1) = max(C(i,1) - 2,1);
   Gdiry(2) = min(C(i,1) + 2,size(im,1));
   tmp = Gdir(Gdirx(1):Gdirx(2),Gdiry(1):Gdiry(2));
   tmp = tmp(:);
   num = all(tmp,1);
   sum(tmp());
   
end
%imshow(im);
%hold on;
%scatter(C(:,2),C(:,1),'r*');
%scatter(C{1}(:,2),C{1}(:,1),'r*');
%%
im_perim = bwperim(im);
imshow(im_perim);
hold on;
for i = 1:size(im_perim,1)-1
    text(im_perim(i,2),im_perim(i,1),sprintf('%d',i),'color','g');
end
%%
C_draw = coordinate_draw(C,size(im,1),size(im,2));
imshow(C_draw);
C_squeeze = squeeze_1dfixed_cell(C);
contour = poly2mask(C_squeeze(:,2),C_squeeze(:,1),size(im,1),size(im,2));
imshow(contour);
%%
key = {...
        'accent','sharp','flat','nature',...
        'graceOne','breathe','barline','frontRepeat',...
        'backRepeat','cresc','decresc','lt','rt','lessThan',...
        's','turtle'...
        };
for i = 1:size(key,2)
    movefile(sprintf('D:/matlab/data_set/Train&test_data/28x28_test/%d',i+16),sprintf('D:/matlab/data_set/Train&test_data/28x28_test/%s',key{i}));
end