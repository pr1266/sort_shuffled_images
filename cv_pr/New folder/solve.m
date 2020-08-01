function [jointimage,x,y,D] = solve(imageblocks,M,N,iternum,D)

%{

x va y intori hastand :
dar vaghe ma ba x , y va dastor meshgrid
miaim aks ro be tedad e del khah partition
bandi mikonim va dar akhar e behine sazi,
index e marboot be har block moshakhas mishe

---------------------------------------------
  1 |  2 |  3 |  4 |  5 | 6  |  7 | 8
---------------------------------------------
  . |  . |  . |  . |  . | .  |  . | .
---------------------------------------------
    |    |    |    |    |    |    |
---------------------------------------------
    |    |    |    |    |    |    |    
---------------------------------------------
    |    |    |    |    |    |    |
---------------------------------------------
%}

%% dar in function ba estefade az Linear Programming
%% solution e masale ro peyda mikonim :
%% inja tedad e patch ha ro be dast miarim :
n = M * N;

%% inja matrix D ke dar vaghe havi Mahalanobis Gradient Compatibility
%% ya hamoon (MGC) hast :
[w D] = mgc(imageblocks);

%% dar in function bar asas e D, meghdar e vazn haro be dast miarim :
%%w = dis2weight(D);

%% meghdar e delta ha ro tarif mikonim
%% ke dar vaghe Xi - Xj
%% va Yi - Yj ro dar 4 orientation mokhtalef neshoon mide :
delta_x = [0; -1; 0; 1];
delta_y = [1; 0; -1; 0];

U = true(n,n,4);

for ii = 1:iternum

    [~,indj] = min(D.*U,[],2);
    i = repmat((1:n)',4,1);
    j = indj(:);
    o = reshape(repmat(1:4,n,1),[],1);
    indA = sub2ind([n,n,4],i,j,o);
    
    %% inja az linear programming estefade mikonim
    %% dar vaghe mikhaim ke meghdar e 
    cvx_begin
        variables x(n) cx(4*n);
        minimize ( w(indA).' * cx );
        subject to
            -cx <= x(i) - x(j) - delta_x(o) <= cx; %#ok
            1 <= x <= N;
    cvx_end

    cvx_begin
        variables y(n) cy(4*n);
        minimize ( w(indA).' * cy );
        subject to
            -cy <= y(i) - y(j) - delta_y(o) <= cy; %#ok
            1 <= y <= M;
    cvx_end

    subA = [i, j, o];
    subR = subA(max(cx,cy)>1e-5,:);
    indR = sub2ind([n,n,4],subR);
    U(indR) = false;

    jointimage = jointblocks(1,imageblocks,x,y);
    
	end

end
