function [imageBlocks,patch_per_row,patch_per_col] = change_to_array(image,blockSize)
    
    %% toye in function mikhaim ke tasvir ro be ye sers ghataat 
    %% tafkik konim va dar yek array berszim :
	
    %% inja size e tasvir ro dar miarsm :
    size_of_image = size(image);

    %% height va width :
    height = size_of_image(1);
    width = size_of_image(2);
    
    %% hesab mikonim ke ba tavajoh be size tasvir
    %% dar har satr va sotoon chand patch gharar migire :
	patch_per_row = floor(height / blockSize);
	patch_per_col = floor(width / blockSize);
	number_of_parts = patch_per_row * patch_per_col;

	image = image(1 : patch_per_row * blockSize, 1 : patch_per_col * blockSize, : );
    
    %% ye array tashkil midim baraye zakhire block haye tasvir :
    %% age size ha block N bashe size in array mishe N * N * 3 * tedad e patch haye tasvir
    
	rgbPartsArray = zeros([blockSize,blockSize,3,number_of_parts],class(image));

    %% dar inja ghesmat ghesmat mikonim :
    %% har ghesmat ro to ye khoone az array zakhire mikonim
	for i = 1 : number_of_parts
        
		rs = (ceil(i/patch_per_col) - 1) * blockSize + 1;
        re = rs + (blockSize - 1);
        cs = mod(i-1 , patch_per_col)  * blockSize + 1;
        ce = cs + (blockSize - 1);
        rgbPartsArray(:,:,:,i) = image(rs:re,cs:ce,:);
    
    end
    
    %% inja ye shuffle mizanim rooye array e tasviremoon :
	partsOrder = randperm(number_of_parts);
	imageBlocks = rgbPartsArray(:,:,:,partsOrder);

end
