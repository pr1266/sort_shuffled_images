function [imageBlocks,rows,cols] = disorg(image,blockSize)

	imageSize = size(image);
	rows = floor(imageSize(1) / blockSize);
	cols = floor(imageSize(2) / blockSize);
	partsNum = rows * cols;

	image = image(1:rows*blockSize,1:cols*blockSize,:);

	rgbPartsArray = zeros([blockSize,blockSize,3,partsNum],class(image));

	for i = 1:partsNum
		rowStartIndex = (ceil(i/cols)-1) * blockSize + 1;
		rowEndIndex = rowStartIndex + (blockSize-1);
		colStartIndex = mod(i-1, cols)  * blockSize + 1;
		colEndIndex = colStartIndex + (blockSize-1);
		rgbPartsArray(:,:,:,i) = image(rowStartIndex:rowEndIndex,colStartIndex:colEndIndex,:);
	end

	partsOrder = randperm(partsNum);
	imageBlocks = rgbPartsArray(:,:,:,partsOrder);

end
