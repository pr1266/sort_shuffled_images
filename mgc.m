function D = mgc(imageblocks)

    blksize = size(imageblocks,1);
   
    n = size(imageblocks,4);
    D = zeros(n, n, 4);

    B = 1e-6*[0,0,1; 1,1,1; 1,0,0];
    B = repmat(B,1,1,n);
    
    for o = 1:4
        blk = rot90(imageblocks, o-2);
        GiL = blk(:,end,:,:) - blk(:,end-1,:,:);
        
        GiL = reshape(GiL, blksize, n, 3);
        %GiL = [GiL; B];
        muiL = mean(GiL);
        
        muiL = reshape(muiL, 3, n);
        
        invSiL = zeros(3,3,n);
        for k = 1:n
            
            
            S1 = GiL(:, k,1) - muiL(1,k);
            S2 = GiL(:, k,2) - muiL(2,k);
            S3 = GiL(:, k,3) - muiL(3,k);
            S = [S1; S2; S3];
            S = reshape(S, blksize, 3);
            
            SiL = S.' * S;
            
            invSiL(:,:,k) = inv(SiL);
        end
        for i = 1:n           
            GijLR = blk(:,1,:,:) - blk(:,end,:,:);
            
            GijLR = reshape(GijLR,blksize,n,3);
            for j = 1:n
                
                S1 = GijLR(:, j,1) - muiL(1,k);
                S2 = GijLR(:, j,2) - muiL(2,k);
                S3 = GijLR(:, j,3) - muiL(3,k);
                temp = [S1; S2; S3];
                temp = reshape(temp, blksize, 3);
                
                %temp = GijLR(:,:,j) - muiL(:,:,i);
                
                
                D(i,j,o) = trace( temp * invSiL(:,:,i) * temp.' );
            end
        end
    end
end
