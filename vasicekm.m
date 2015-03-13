% *****************************************************************
% Copyright (c) Erik G. Learned-Miller, 2004.
% *****************************************************************
%
% Changes from version with release 1.0.
%
% 1) Switched to log from log2. log is slightly faster in Matlab.
% 2) Switched intvals calculation to make it more direct. This is a
%    substantial speed increase.

function h=vasicekm(v,m)
% v : row vector :
% m = sqrt(N)
  len=length(v);
  vals=sort(v);

  % Note that the intervals overlap for this estimator.
  intvals=vals(m+1:len)-vals(1:len-m);
  hvec=log(intvals);
  h=sum(hvec);

%  dlmwrite('valst.txt',vals','delimiter','\t','precision',5);
%  dlmwrite('intvalst.txt',intvals','delimiter','\t','precision',5);
%  dlmwrite('hvect.txt',hvec','delimiter','\t','precision',5);
%  dlmwrite('h.txt',h,'delimiter','\t','precision',5);
