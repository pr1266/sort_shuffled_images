%% read data :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\';
data_dir = dir(data_path);

%array = cell(numel(data_dir), 16)

output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Output.tif');
h = 1200;
w = 1920;
patch_size = sqrt((h * w) / 40);

%first_corner = output_image(1:patch_size,1:patch_size,:);


my_array = cell(numel(data_dir), 2); 


for image = 9 : numel(data_dir) - 1
    
    picture = rgb2gray(imread([data_path data_dir(image).name]));
    [Gmag, Gdir] = imgradient(picture);
    my_array(image - 8, 1) = mat2cell(Gmag, patch_size, patch_size);
    my_array(image - 8, 2) = mat2cell(Gdir, patch_size, patch_size);
    
end
    





imshow(first_corner, []);

corner = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_1_1.tif');

x = mse(corner, first_corner);