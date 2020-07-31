function output_image = gradient_check(output_image, patch_size, my_array, h, w)

sobel_filter = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

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
 
end