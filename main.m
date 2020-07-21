%% read data :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\';
data_dir = dir(data_path);

%% output image ro mikhoonim ke badan patch haro toosh sort konim :
output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Output.tif');
%% size tasvir :
h = 1200;
w = 1920;

%% bar asas e size e tasvir size har patch ro bedast miarim :
patch_size = sqrt((h * w) / 40);

%% ye array dorost mikonim ta etelaat e patch haro zakhire konim :
my_array = cell(numel(data_dir), 4);

%% etelaat ro be array montaghel mikonim :

for image = 9 : numel(data_dir) - 1
    
    picture = imread([data_path data_dir(image).name]);
    temp_picture = rgb2gray(picture);
    [Gmag, Gdir] = imgradient(temp_picture);
    
    %% khod e tasvir, esmesh, meghdar gradientesh va direction e gradientesh :
    my_array(image - 8, 1) = mat2cell(Gmag, patch_size, patch_size);
    my_array(image - 8, 2) = mat2cell(Gdir, patch_size, patch_size);
    my_array(image - 8, 3) = mat2cell(picture, patch_size, patch_size, 3);
    my_array(image - 8, 4) = cellstr(data_dir(image).name);
    
end

%% inja etelaat e corner haro darmiarim :

%% corner e 1 :
corner_1_1 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_1_1.tif'));
[GV, GD] = imgradient(corner_1_1);
right_corner_1_1 = GV(:,patch_size);
bottom_corner_1_1 = GV(patch_size, :);

%% corner e 2 :
corner_1_8 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_1_8.tif'));
[GV, GD] = imgradient(corner_1_8);
left_corner_1_8 = GV(:,1);
bottom_corner_1_8 = GV(patch_size,:);

%% corner e 3 :
corner_5_1 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_5_1.tif'));
[GV, GD] = imgradient(corner_5_1);
right_corner_5_1 = GV(:,patch_size);
top_corner_5_1 = GV(1,:);

%% corner e 4 :
corner_5_8 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_1_40\Corner_5_8.tif'));
[GV, GD] = imgradient(corner_5_8);
left_corner_5_8 = GV(:,1);
top_corner_5_8 = GV(1,:);


%% inja mikham tasvir ro por konam :

for i = 1 : patch_size : w
    for j = 1 : patch_size : h
        
        %% corner e aval :
        if i == 1 && j == 1
            error = [];
            %% inja right corner barash darmiarim :
            %% hame error haro darmiarim va min e error haro barash dar nazar migirim :
            for k = 1 : 36
                
                element = cell2mat(my_array(k, 1));
                disp(k);
                left_gradient = element(:, 1);
                MSE = mse(left_gradient, right_corner_1_1);
                error = [error MSE];
            end
            
            minimum = min(error);
            min_error = find(error == minimum);
            disp(min_error);
            
            %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
            new_picture = cell2mat(my_array(min_error, 3));
            
            disp(size(new_picture));
            
            
            output_image(1:patch_size, patch_size + 1: 2 * patch_size, :) = new_picture;
            figure(1);
            imshow(output_image, []);
            
        end
        
    end
end


