%% read data :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\';
data_dir = dir(data_path);

%% output image ro mikhoonim ke badan patch haro toosh sort konim :
output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Output.tif');
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
corner_1_1 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Corner_1_1.tif'));
[GV, GD] = imgradient(corner_1_1);
right_corner_1_1 = GV(:,patch_size);
bottom_corner_1_1 = GV(patch_size, :);

%% corner e 2 :
corner_1_8 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Corner_1_8.tif'));
[GV, GD] = imgradient(corner_1_8);
left_corner_1_8 = GV(:,1);
bottom_corner_1_8 = GV(patch_size,:);

%% corner e 3 :
corner_5_1 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Corner_5_1.tif'));
[GV, GD] = imgradient(corner_5_1);
right_corner_5_1 = GV(:,patch_size);
top_corner_5_1 = GV(1,:);

%% corner e 4 :
corner_5_8 = rgb2gray(imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_40\Corner_5_8.tif'));
[GV, GD] = imgradient(corner_5_8);
left_corner_5_8 = GV(:,1);
top_corner_5_8 = GV(1,:);


%% inja mikham tasvir ro por konam :

figure(1);
imshow(output_image, []);


for i = 1 : patch_size : h
    for j = 1 : patch_size : w
    
        image_slice = output_image(i : i + patch_size - 1, j : j + 1);
        %% age sum esh sefr nabashe yani ke tasvire
        if(sum(image_slice) ~= 0) continue;
        %% sharte else esh ine ke tasvir nist,
        %% pas bayad poresh konim
        %% hala 1 shart pish miad :
        %% age j esh (sotoonesh) sefr bood bayad
        %% az balaiish esfefade kone dar gheir e in soorat
        %% miad az samt e chapish estefade mikone :
        else
            
            %% inja az balaiish migire yani output_image(1 : patch_size, j : j + patch_size_1);
            %% vaghti az balaiish migirim, pas bottom e temp va top e new_picture ro mikhaim :
            if(j == 1)
                temp_picture = output_image(i - patch_size : i - 1, j : j + patch_size - 1, :);
                temp_picture = rgb2gray(temp_picture);
                %% inja gradient esho dar miarim :
                [GV, GD] = imgradient(temp_picture);
                bottom_gradient = GV(patch_size,:);
                %% hala inja biaim element e mored e nazar ro dar biarim :
                error = [];
                for k = 1 : size(my_array);
                
                    element = cell2mat(my_array(k, 1));
                    top_gradient = element(1,:);
                    MSE = mse(bottom_gradient, top_gradient);
                    error = [error MSE];
                end
                
                minimum = min(error);
                min_error = find(error == minimum);
             
             %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
             new_picture = cell2mat(my_array(min_error, 3));
             output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
             %pause(1);
             figure(1);
             imshow(output_image, []);
             %my_array(min_error, :) = [];
             
            %% toye else az samt e chapish estefade mikonim :
            else
                
                temp_picture = output_image(i : i + patch_size - 1, j - patch_size : j - 1, :);
                temp_picture = rgb2gray(temp_picture);
                figure;
                imshow(temp_picture, []);
                %% gradient :
                [GV, GD] = imgradient(temp_picture);
                right_gradient = GV(:,patch_size);
                
                %% hala inja biaim element e mored e nazar ro dar biarim :
                error = [];
                for k = 1 : size(my_array);
                    element = cell2mat(my_array(k, 1));
                    left_gradient = element(:,1);
                    MSE = mse(left_gradient, right_gradient);
                    error = [error MSE];
                end
                
                minimum = min(error);
                min_error = find(error == minimum);
             
                 %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
                 new_picture = cell2mat(my_array(min_error, 3));
                 output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
                 %pause(1);
                 figure(1);
                 imshow(output_image, []);
                 %my_array(min_error, :) = [];
            end
        end
    
    end
end
