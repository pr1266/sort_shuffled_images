function [final_image,x,y] = jointblocks(boolean_,imageblocks,x,y,~)
    
    %% size har patch ro dar miarim :
	patch_size = size(imageblocks,1);
	n = size(imageblocks,4);

	x = x - min(x(:));
	x = round(x);
	y = y - min(y(:));
	y = round(y);
    
	final_image = zeros((max(y)+1) * patch_size, (max(x)+1) * patch_size, 3);
	
    %% dar entehaye amaliat e kamine sazi convex, index e har 
    %% ghete az tasvir moshakhas mishe
    %% va index ha be soorat e 1 ta n hastand ke n neshan dahande
    %% tedad e patch haye tasvire
    
    for k = 1 : n
        
		col_start = patch_size * x(k) + 1;
		col_end = patch_size * (x(k) + 1);
        row_start = patch_size * y(k) + 1;
        row_end = patch_size * (y(k) + 1);
        
		final_image(row_start:row_end,col_start:col_end,:) = imageblocks(:,:,:,k);
        %final_image(patch_size * x(k) :  patch_size * (x(k) + 1) , patch_size * y(k) + 1 : patch_size * (y(k) + 1),:) = imageblocks(:,:,:,k);
        if boolean_
            figure(1);
            imshow(final_image);
        end
    end
    figure(1);
	imshow(final_image);
    title('end')
	x = x + 1;
	y = y + 1;

end