function [imageBlocks,rows,cols] = disorg(image,blockSize)
    
    %% toye in function mikhaim ke tasvir ro be ye seri ghataat 
    %% tafkik konim va dar yek array berizim :
	
    %% inja size e tasvir ro dar miarim :
    size_of_image = size(image);
   
    height = size_of_image(1);
    width = size_of_image(2);
    
    %% hesab mikonim ke ba tavajoh be size tasvir
    %% dar har satr va sotoon chand patch gharar migire :
	patch_per_row = floor(height / blockSize);
	patch_per_col = floor(width / blockSize);
	number_of_parts = patch_per_row * patch_per_col;

	image = image(1 : patch_per_row * blockSize, 1 : patch_per_col * blockSize, : );

	rgbPartsArray = zeros([blockSize,blockSize,3,number_of_parts],class(image));

	for i = 1:number_of_parts
		rowStartIndex = (ceil(i/patch_per_row)-1) * blockSize + 1;
		rowEndIndex = rowStartIndex + (blockSize-1);
		colStartIndex = mod(i-1, patch_per_row)  * blockSize + 1;
		colEndIndex = colStartIndex + (blockSize-1);
		rgbPartsArray(:,:,:,i) = image(rowStartIndex:rowEndIndex,colStartIndex:colEndIndex,:);
	end

	partsOrder = randperm(number_of_parts);
	imageBlocks = rgbPartsArray(:,:,:,partsOrder);

end
