clear;
close all;
%% read data :
data_path = 'C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\';
data_dir = dir(data_path);
block_count = str2num(data_path(size(data_path) - 3: size(data_path) - 2));
%% output image ro mikhoonim ke badan patch haro toosh sort konim :
output_image = imread('C:\Users\pr1266\Desktop\cv_project\Puzzle_2_160\Output.tif');
%% size tasvir :
h = 1200;
w = 1920;

%% bar asas e size e tasvir size har patch ro bedast miarim :
patch_size = sqrt((h * w) / block_count);

%% horizontal sobel filter
sobel_filter = [-1, -2, -1; 0, 0, 0; 1, 2, 1];
%% ye array dorost mikonim ta etelaat e patch haro zakhire konim :
my_array = cell(numel(data_dir) - 9, 5);

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
    
    filtered_picture = imfilter(picture, sobel_filter);
    my_array(image - 8, 5) = mat2cell(filtered_picture, patch_size, patch_size, 3);
    
    %figure;
    %imshow(filtered_picture, []);
    
end

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
                temp_picture_ = output_image(i - patch_size : i - 1, j : j + patch_size - 1, :);
                temp_picture = rgb2gray(temp_picture_);
                %% inja gradient esho dar miarim :
                [GV, GD] = imgradient(temp_picture);
                bottom_gradient = GV(patch_size,:);
                
                %% sobel filter :
                %% paiinesh ro estekhraj mikonim :
                filtered_image = imfilter(temp_picture_, sobel_filter);
                filtered_image = filtered_image(patch_size,:);
                %% hala inja biaim element e mored e nazar ro dar biarim :
                error = [];
                edge_error = [];
                for k = 1 : size(my_array);
                    
                    %% inja baraye gradient :
                    
                    element = cell2mat(my_array(k, 1));
                    top_gradient = element(1,:);
                    MSE = mse(bottom_gradient, top_gradient);
                    error = [error MSE];
                    
                    %% inja baraye sobel :
                    %% balasho estekhraj mikonim :
                    sobel_element = cell2mat(my_array(k, 5));
                    sobel_element = sobel_element(1,:);
                    MSE = mse(sobel_element, filtered_image);
                    edge_error = [edge_error MSE];
                    
                end
                
                minimum = min(error);
                min_error = find(error == minimum);
                
                edge_minimum = min(edge_error);
                edge_min_error = find(edge_error == edge_minimum);
                
                %% hala biaim raii giri konim :
                
                if edge_minimum < minimum
                    index = edge_min_error;
                elseif edge_minimum > minimum
                    index = min_error;
                else
                    index = min_error;
                end
                
                
             %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
             new_picture = cell2mat(my_array(min_error, 3));
             output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
             %pause(1);
             figure(1);
             imshow(output_image, []);
             %my_array(index, :) = [];
             
            %% toye else az samt e chapish estefade mikonim :
            else
                
                temp_picture_ = output_image(i : i + patch_size - 1, j - patch_size : j - 1, :);
                temp_picture = rgb2gray(temp_picture_);
                %figure;
                %imshow(temp_picture, []);
                %% gradient :
                [GV, GD] = imgradient(temp_picture);
                right_gradient = GV(:,patch_size);
                
                %% soble filter :
                filtered_image = imfilter(temp_picture_, sobel_filter);
                %% samt e rastesh ro estekhraj mikonim :
                filtered_image = filtered_image(:,patch_size);
                %% hala inja biaim element e mored e nazar ro dar biarim :
                error = [];
                edge_error = [];
                for k = 1 : size(my_array);
                    
                    element = cell2mat(my_array(k, 1));
                    left_gradient = element(:,1);
                    MSE = mse(left_gradient, right_gradient);
                    error = [error MSE];
                    
                    %% inja baraye sobel :
                    sobel_element = cell2mat(my_array(k, 5));
                    %% samt e rast e tasvir ghabl va samt chap tasvir jadid :
                    sobel_element = cell2mat(my_array(k, 5));
                    sobel_element = sobel_element(:,1);
                    %% hala error :
                    MSE = mse(sobel_element, filtered_image);
                    edge_error = [edge_error MSE];
                    
                end
                
                minimum = min(error);
                min_error = find(error == minimum);
                
                edge_minimum = min(edge_error);
                edge_min_error = find(edge_error == edge_minimum);
                
                %% hala biaim raii giri konim :
                index = 0;
                if edge_minimum < minimum
                    index = edge_min_error;
                elseif edge_minimum > minimum
                    index = min_error;
                else
                    index = min_error;
                end
                
                %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
                new_picture = cell2mat(my_array(min_error, 3));
                output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
                %pause(1);
                figure(1);
                imshow(output_image, []);
                %my_array(index, :) = [];
            end
        end
    end
 end

%% inja biaim az ekhtelaf e rang estefade konim :
% for i = 1 : patch_size : h
%     for j = 1 : patch_size : w
%     
%         image_slice = output_image(i : i + patch_size - 1, j : j + 1);
%         %% age sum esh sefr nabashe yani ke tasvire
%         if(sum(image_slice) ~= 0) continue;
%         %% sharte else esh ine ke tasvir nist,
%         %% pas bayad poresh konim
%         %% hala 1 shart pish miad :
%         %% age j esh (sotoonesh) sefr bood bayad
%         %% az balaiish esfefade kone dar gheir e in soorat
%         %% miad az samt e chapish estefade mikone :
%         else
%             
%             %% inja az balaiish migire yani output_image(1 : patch_size, j : j + patch_size_1);
%             %% vaghti az balaiish migirim, pas bottom e temp va top e new_picture ro mikhaim :
%             if(j == 1)
%                 temp_picture_ = output_image(i - patch_size : i - 1, j : j + patch_size - 1, :);
%                 
%                 bottom_gradient = temp_picture_(patch_size,:, :);
%                 bottom_gradient = reshape(bottom_gradient, patch_size * 3, 1);
%                 error = [];
%                 
%                 for k = 1 : size(my_array);
%                     
%                     %% inja baraye gradient :
%                     
%                     element = cell2mat(my_array(k, 3));
%                     top_gradient = element(1,:,:);
%                     top_gradient = reshape(top_gradient, patch_size * 3, 1);
%                     MAE = mae(bottom_gradient, top_gradient);
%                     error = [error MAE];
%                     
%                 end
%                 
%                 minimum = min(error);
%                 min_error = find(error == minimum);
%                 
%                 
%              %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
%              new_picture = cell2mat(my_array(min_error, 3));
%              output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
%              
%              figure;
%              imshow(new_picture, []);
%              %pause(1);
%              figure(1);
%              imshow(output_image, []);
%              my_array(min_error, :) = [];
%              
%             %% toye else az samt e chapish estefade mikonim :
%             else
%                 
%                 temp_picture_ = output_image(i : i + patch_size - 1, j - patch_size : j - 1, :);
%                 right_gradient = temp_picture_(:,patch_size, :);
%                 right_gradient = reshape(right_gradient, patch_size * 3, 1);
%                 
%                 error = [];
%                 
%                 for k = 1 : size(my_array);
%                     
%                     element = cell2mat(my_array(k, 3));
%                     left_gradient = element(:,1,:);
%                     left_gradient = reshape(left_gradient, patch_size * 3, 1);
%                     MAE = mae(left_gradient, right_gradient);
%                     error = [error MAE];
%                     
%                     
%                     
%                 end
%                 
%                 minimum = min(error);
%                 min_error = find(error == minimum);
%                 
%                 
%                 
%                 %% hala index ro darim miaim tasvir ro ba indexesh az my_array mikhonim va gharar midim :
%                 new_picture = cell2mat(my_array(min_error, 3));
%                 output_image(i : i + patch_size - 1, j : j + patch_size - 1, :) = new_picture;
%                 figure;
%                 imshow(new_picture, []);
%                 %pause(1);
%                 figure(1);
%                 imshow(output_image, []);
%                 my_array(min_error, :) = [];
%             end
%         end
%     
%     end
% end
