function my_array = feature_extraction(data_dir, data_path, patch_size)
my_array = cell(numel(data_dir) - 9, 5);

%% horizontal sobel filter
sobel_filter = [-1, -2, -1; 0, 0, 0; 1, 2, 1];

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
end
