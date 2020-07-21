%% read data :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\';
data_dir = dir(data_path);

%array = cell(numel(data_dir), 16)

output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Output.tif');
h = 1200;
w = 1920;
patch_size = sqrt((h * w) / 40);

%first_corner = output_image(1:patch_size,1:patch_size,:);


my_array = cell(numel(data_dir), 3); 

for image = 9 : numel(data_dir) - 1
    
    picture = rgb2gray(imread([data_path data_dir(image).name]));
    [Gmag, Gdir] = imgradient(picture);
    my_array(image - 8, 1) = mat2cell(Gmag, patch_size, patch_size);
    my_array(image - 8, 2) = mat2cell(Gdir, patch_size, patch_size);
    my_array(image - 8, 3) = cellstr(data_dir(image).name);
    
end

x_temp_1 = cell2mat(my_array(1, 1));
x_temp_2 = cell2mat(my_array(1, 2));
top_corner_1 = x_temp_1(1,:);
left_corner_1 = x_temp_1(:,1);
right_corner_1 = x_temp_1(:,patch_size);
bottom_corner_1 = x_temp_1(patch_size,:);



top_corner_2 = x_temp_2(1,:);
left_corner_2 = x_temp_2(:,1);
right_corner_2 = x_temp_2(:,patch_size);
bottom_corner_2 = x_temp_2(patch_size,:);

corner = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_1_1.tif'));

[GV, GD] = imgradient(corner);

right_corner_corner = GV(:,patch_size);

for i = 1:36
    %disp(i);
    x_temp = cell2mat(my_array(i,1));
    left_corner = x_temp(:,1);
    %if mse(left_corner, right_corner_corner) < 1
        disp(mse(left_corner, right_corner_corner));
    %end
end

patch_10 = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Patch_10.tif');
output_image(1: patch_size, patch_size + 1: 2 * patch_size, :) = patch_10;
imshow(output_image, []);