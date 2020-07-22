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
my_array = cell(numel(data_dir) - 9, 4);

%% etelaat ro be array montaghel mikonim :

for image = 9 : numel(data_dir) - 1
    
    picture = imread([data_path data_dir(image).name]);
    
    temp_picture = rgb2gray(picture);
    kernel = ones(3) / 3 .^ 2;
    %temp_picture = imfilter(temp_picture, kernel, 'replicate');
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
        disp(i);
        disp(j);
        %% inja corner e satr aval sotoon aval :
        if i == 1 && j == 1
            error = [];
            %% inja right corner barash darmiarim :
            %% hame error haro darmiarim va min e error haro barash dar nazar migirim :
            for k = 1 : size(my_array);
                
                element = cell2mat(my_array(k, 1));
                left_gradient = element(:, 1);
                MSE = mse(left_gradient, right_corner_1_1);
                error = [error MSE];
            end
            
            minimum = min(error);
            min_error = find(error == minimum);
            
            %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
            new_picture = cell2mat(my_array(min_error, 3));
            output_image(1:patch_size, patch_size + 1: 2 * patch_size, :) = new_picture;
            %figure(1);
            %imshow(output_image, []);
            my_array(min_error, :) = [];

        
        %% inja corner e satr aval sotoon akhar :
        elseif i == w - patch_size + 1 && j == 1
            error = [];
            %% inja right corner barash darmiarim :
            %% hame error haro darmiarim va min e error haro barash dar nazar migirim :
            for k = 1 : size(my_array)
                element = cell2mat(my_array(k, 1));
                right_gradient = element(:, patch_size);
                MSE = mse(right_gradient, left_corner_1_8);
                error = [error MSE];
            end
            
            minimum = min(error);
            min_error = find(error == minimum);
            
            %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
            new_picture = cell2mat(my_array(min_error, 3));
            output_image(1:patch_size, w - 2 * patch_size + 1: w - patch_size, :) = new_picture;
            figure(1);
            imshow(output_image, []);
            my_array(min_error, :) = [];
            
        
        %% inja corner e satr akhar sotoon aval :
        elseif i == 1 && j == h - patch_size + 1
            error = [];
            %% inja right corner barash darmiarim :
            %% hame error haro darmiarim va min e error haro barash dar nazar migirim :
            for k = 1 : size(my_array)
                element = cell2mat(my_array(k, 1));
                left_gradient = element(:,1);
                MSE = mse(left_gradient, right_corner_5_1);
                error = [error MSE];
            end
            
            minimum = min(error);
            min_error = find(error == minimum);
            
            %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
            new_picture = cell2mat(my_array(min_error, 3));
            output_image(h - patch_size + 1: h, patch_size + 1: 2 * patch_size, :) = new_picture;
            figure(1);
            imshow(output_image, []);
            my_array(min_error, :) = [];
            
        
        %% inja corner e satr akhar sotoon akhar :
        elseif i == w - patch_size + 1 && j == h - patch_size + 1
            error = [];
            %% inja right corner barash darmiarim :
            %% hame error haro darmiarim va min e error haro barash dar nazar migirim :
            for k = 1 : size(my_array)
                element = cell2mat(my_array(k, 1));
                right_gradient = element(:,patch_size);
                MSE = mse(right_gradient, left_corner_5_8);
                error = [error MSE];
            end
            
            minimum = min(error);
            min_error = find(error == minimum);
            
            
            %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
            new_picture = cell2mat(my_array(min_error, 3));
            output_image(h - patch_size + 1: h, w - (2 * patch_size) + 1 : w - patch_size , :) = new_picture;
            figure(1);
            imshow(output_image, []);
            
            my_array(min_error, :) = [];

            
            
            

             
         elseif i == 1 && j ~= h - patch_size + 1 && j ~= 1
             error = [];
             %% inja block balayii tasvir ro darmiarim
             %% baad gradientesh ro hesab mikonim :
             
             
             %temp_picture = output_image(1: patch_size, j - patch_size : j - 1, :);
             temp_picture = output_image(j - patch_size : j - 1, 1 : patch_size, :);
             %%output_image(j : j + patch_size - 1, 1 : patch_size , :) = new_picture;
             
             temp_picture = rgb2gray(temp_picture);
             [GV ,GD] = imgradient(temp_picture);
             bottom = GV(patch_size, :);
             
             for k = 1 : size(my_array)
                 element = cell2mat(my_array(k, 1));
                 top = element(1, :);
                 MSE = mse(top, bottom);
                 error = [error ,MSE];
             end
             
             minimum = min(error);
             min_error = find(error == minimum);
             
             %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
             new_picture = cell2mat(my_array(min_error, 3));
             output_image(j : j + patch_size - 1, 1 : patch_size , :) = new_picture;
             figure(1);
             imshow(output_image, []);
             my_array(min_error, :) = [];
               
        end
    end
    
end

figure(1);
imshow(output_image, []);


