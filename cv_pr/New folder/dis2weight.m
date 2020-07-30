function w = dis2weight(D)

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
