clc;
clear;
close all;

%% data path :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\';
data_dir = dir(data_path);

%% output image ro mikhoonim ke badan patch haro toosh sort konim :
%% khode original image ro ham baraye in dar nazar migirim ke natije nahaii ro
%% bahash moghaiese konim :

output_path = 'Output.tif';
original_path = 'Original.tif';

output_image = imread([data_path output_path]);
original_image = imread([data_path original_path]);



%% size tasvir :
h = 1200;
w = 1920;

%% tedad e block haye puzzle (patch_size) :
pieces = numel(data_dir) - 5;
%% bar asas e size e tasvir size har patch ro bedast miarim :
patch_size = sqrt((h * w) / pieces);

%% ye array dorost mikonim ta etelaat e patch haro zakhire konim :
my_array = feature_extraction(data_dir, data_path, patch_size);



%% inja gradient ro check mikonim :
output_image_2 = gradient_check(output_image, patch_size, my_array, h, w);

%% hala shartesh :
if mse(output_image_2, original_image) ~= 0
    
    
counter = 1;

    for i = 1 : patch_size : h
        for j = 1 : patch_size : w
        
            image_slice = output_image(i : i + patch_size - 1, j : j + 1);
            if(sum(image_slice) ~= 0) continue;
            else
                
                if(j == 1)
                new_picture = cell2mat(my_array(counter, 3));
                output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
                counter = counter + 1;
                else                    
                    temp_picture_ = output_image(i : i + patch_size - 1, j - patch_size : j - 1, :);
                    new_picture = cell2mat(my_array(counter, 3));
                    output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
                    counter = counter + 1;
                end
            end
        end
    end
    
    %% age ravesh e ghabl natije matloob ro nadad
    %% az ravesh e MGC estefade mikonim :
    
    output_image = im2double(output_image);
    maxiter = 3;
    [imageblocks, M, N] = change_to_array(output_image, patch_size);
    [x, y] = meshgrid(1:N, 1:M);
    [restoredimage, x, y, D] = solve(imageblocks, M, N, maxiter);
    disp("MSE : ");
    disp(mse(restoredimage, im2double(original_image)));
end