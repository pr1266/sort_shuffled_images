function [w, D] = mgc(imageblocks)
    
    %% inja mgc ro hesab mikonim
    %% baraye tamam e pairWise ha va 
    %% dar hame orientation ha :
    blksize = size(imageblocks,1);
    n = size(imageblocks,4);
    %% Dijo ro be ezaye tamami patch haye i , j
    %% va tamami orientation ha hesab mikonim :
    D = zeros(n, n, 4);

    %% toye maghale neveshte bood jahat e
    %% jelogiri az khata haye mohasebati in maghadir e
    %% gradient ro be matrixemoon ezafe mikonim :
    B = 1e-6*[0,0,1; 1,1,1; 1,0,0];
    B = repmat(B,1,1,n);
    
    for o = 1:4
        %% inja tasavir ro dar orientation haye mokhtalef micharkhoonim :
        blk = rot90(imageblocks,o-2);
        
        %% dar in ghesmat 2 radif e motavali e mojaver e nahie marzi ro
        %% az ham kam mikonim :
        GiL = blk(:,end,:,:) - blk(:,end-1,:,:);
        GiL = reshape(GiL,blksize,3,n);
        %% maghadir e B ro behesh ezafe mikonim :
        GiL = [GiL; B];
        %% miangin e ekhtelaf e 2 radif e motavali e mojaver e marzi ro
        %% be dast miarim :
        %% yani alan be ezaye har pairWise, 120 ta addad darim
        %% (baraye mesal e patch size 120 * 120) ke alan mianginesh ro
        %% hesab mikonim :
        muiL = mean(GiL);
        
        %% matrix e 3 * 3 * n ro baraye mohasebe covariance
        %% ( andaze taghirat e hamahang e 2 moteghaier )
        invSiL = zeros(3,3,n);
        for k = 1:n
            SiL = (GiL(:,:,k) - muiL(:,:,k)).'*(GiL(:,:,k) - muiL(:,:,k));
            invSiL(:,:,k) = inv(SiL);
        end
        for i = 1:n
            %% hala inja miaim compatibility ro hesab mikonim ba
            %% estefade az parameter hayii ke ta alan be dast oomad
            GijLR = blk(:,1,:,:) - blk(:,end,:,i);
            GijLR = reshape(GijLR,blksize,3,n);
            for j = 1:n
                temp = GijLR(:,:,j) - muiL(:,:,i);
                %% ba dastoor e trace sum e element haye
                %% ghotr asli matrix e hasel ro hesab mikonim
                D(i,j,o) = trace( temp * invSiL(:,:,i) * temp.' );
            end
        end
    end

    Dtemp = D;
    D(:,:,1) = (Dtemp(:,:,1) + Dtemp(:,:,3).') / 2;
    D(:,:,2) = (Dtemp(:,:,2) + Dtemp(:,:,4).') / 2;
    D(:,:,3) = D(:,:,1).';
    D(:,:,4) = D(:,:,2).';
    
    
    n = size(D,1);
	D = D + 1e-3*min(D(:))*rand(size(D));

	Dsortcol = sort(D);
	vminD = repmat(Dsortcol(1,:,:),n,1,1);
	vminD(vminD==D) = Dsortcol(2,:,:);

	Dtrans = permute(D,[2 1 3]);
	Dsortrow = sort(Dtrans);
	hminD = repmat(Dsortrow(1,:,:),n,1,1);
	hminD(hminD==Dtrans) = Dsortrow(2,:,:);
	hminD = permute(hminD,[2 1 3]);

	w = min(vminD,hminD) ./ D;
    
end