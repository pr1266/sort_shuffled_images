function [jointimage,x,y] = jointblocks(boolean_,imageblocks,x,y,~)
%function [jointimage,x,y] = jointblocks(imageblocks, BG,x,y,~)
	blocksize = size(imageblocks,1);
	n = size(imageblocks,4);

	x = x - min(x(:));
	x = round(x);
	y = y - min(y(:));
	y = round(y);
    
	jointimage = zeros((max(y)+1)*blocksize, (max(x)+1)*blocksize, 3);
	for k = 1:n
		rangecol = blocksize*x(k)+1 : blocksize*(x(k)+1);
		rangerow = blocksize*y(k)+1 : blocksize*(y(k)+1);
		jointimage(rangerow,rangecol,:) = imageblocks(:,:,:,k);
        if boolean_
            pause(0.05);
            figure(1);
            imshow(jointimage);
        end
    end
    figure;
	imshow(jointimage);
	set(gcf,'color','w');

	x = x + 1;
	y = y + 1;

end