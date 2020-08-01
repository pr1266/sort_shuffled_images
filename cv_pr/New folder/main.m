clc;
clear;
close all;
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\';
data_dir = dir(data_path);

%% output image ro mikhoonim ke badan patch haro toosh sort konim :
output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Output.tif');

%% original image : 
original_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Original.tif');

%% shuffled :
shuffeled = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Shuffled_Patches.tif');

%% size tasvir :
h = 1200;
w = 1920;

%% tedad e block haye puzzle (patch_size) :
%pieces = str2num(data_path(size(data_path,2) - 2: size(data_path,2) - 1));
pieces = 160;
%% bar asas e size e tasvir size har patch ro bedast miarim :
patch_size = sqrt((h * w) / pieces);

%% ye array dorost mikonim ta etelaat e patch haro zakhire konim :
my_array = feature_extraction(data_dir, data_path, patch_size);

%% inja gradient ro check mikonim :
output_image = gradient_check(output_image, patch_size, my_array, h, w);

%% hala shartesh :
if mse(output_image, original_image) ~= 0
    
    %% age ravesh e ghabl natije matloob ro nadad
    %% az ravesh e MGC estefade mikonim :
    
    output_image = im2double(shuffeled);
    maxiter = 2;
    [imageblocks, M, N] = disorg(output_image, patch_size);
    [x, y] = meshgrid(1:N, 1:M);
    [restoredimage, x, y, D] = LPsolve(imageblocks, M, N, maxiter);
    
end