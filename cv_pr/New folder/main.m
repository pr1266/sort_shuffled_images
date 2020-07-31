clc;
clear;
close all;
%image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Original.tif');

data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\';
data_dir = dir(data_path);

%% output image ro mikhoonim ke badan patch haro toosh sort konim :
output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Output.tif');
%% size tasvir :
h = 1200;
w = 1920;

%% tedad e block haye puzzle (patch_size) :
pieces = str2num(data_path(size(data_path,2) - 2: size(data_path,2) - 1));

%% bar asas e size e tasvir size har patch ro bedast miarim :
patch_size = sqrt((h * w) / pieces);

%% horizontal sobel filter
sobel_filter = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

%% ye array dorost mikonim ta etelaat e patch haro zakhire konim :
my_array = feature_extraction(data_dir, data_path, patch_size);





%% inja gradient ro check mikonim :
output_image = gradient_check(output_image, patch_size, my_array, h, w);

%% hala shartesh :



image = output_image;
image = im2double(image);
blocksize = patch_size;
maxiter = 2;
%pieces = row * col / blocksize ^ 2;
%pieces = str2num(data_path(size(data_path) - 3: size(data_path) - 2));

[imageblocks, M, N] = disorg(image, blocksize);
[x, y] = meshgrid(1:N, 1:M);

puzzleimage = jointblocks(0,imageblocks,x(:),y(:));
figure(4);
title('suffeled_image');
imshow(puzzleimage);

[restoredimage, x, y, D] = LPsolve(imageblocks, M, N, maxiter);

%jointimage = greedymatch(x,y,M,N,D,imageblocks);
    
% uicontrol('style','pushbutton','string','Continue','callback','close all');





