clc;
clear;

image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Shuffled_Patches.tif');
image = im2double(image);
blocksize = 120;
maxiter = 1;
pieces = size(image,1) * size(image,2) / blocksize^2;

[imageblocks, M, N] = disorg(image, blocksize);
[x, y] = meshgrid(1:N, 1:M);

puzzleimage = jointblocks(imageblocks,x(:),y(:));

title('x');

drawnow;

[restoredimage, x, y, D] = LPsolve(imageblocks, M, N, maxiter);

jointimage = greedymatch(x,y,M,N,D,imageblocks);
    
% uicontrol('style','pushbutton','string','Continue','callback','close all');





