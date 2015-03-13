% *****************************************************************
% Copyright (c) Erik G. Learned-Miller, 2004.
% *****************************************************************
% RADICAL   Solve the ICA problem in arbitrary dimension.
%
%    Version 1.1. Major bug fix. Faster entropy estimator.
%
%    Apr.1, 2004. Major bug fix. Whitening matrix was wrong. Thanks
%      to Sergey Astakhov for spotting this one.
%
%    Mar.28, 2004. Sped up inner loop by about 20% with a better
%      entropy estimator.
%
%    Version 1.0. First release.
%
%    [Yopt,Wopt] = RADICAL(X) takes a single argument, X,
%    the matrix of mixed components, with one component per
%    row, and finds the best "unmixing matrix" Wopt that it
%    can. Wopt applied to the mixed components X produces the
%    approximately independent components Yopt, with one component
%    per row.
%
%    If the input data X is 5x1000, for example, then Yopt should
%    also be 5x1000, and Wopt will be 5x5.
%    *************************************************************
%
%    PARAMETERS: Set these parameters by hand in the next code block.
%
%    K:        The number of angles at which to evaluate the contrast
%              function. The ICA contrast function will be evaluated
%              at K evenly spaced rotations from -Pi/4 to Pi/4. For
%              small data sets (less than a few hundred points), the
%              default value of 150 should work well. For larger data
%              sets, very small benefits may be realized by
%              increasing the value of K, but keep in mind that the
%              algorithm is linear in K.
%
%    AUG_FLAG: This flag is set to 1 by default, which indicates
%              that the data set will be "augmented" as discussed
%              in the paper. If this flag is set to 0, then the
%              data will not be augmented, and the next two
%              arguments are meaningless. For large data
%              sets with more than 10000 points, this flag should
%              usually be set to 0, as there is usually no need to
%              augment the data in these cases.
%
%    reps:     This is the number of replicated points for each
%              original point. The default value is 30. The larger
%              the number of points in the data set, the smaller
%              this value can be. For data sets of 10,000 points or
%              more, point replication should be de-activated by setting
%              AUG_FLAG to 0 (see above).
%
%    stdev:    This is the standard deviation of the replicated points. I
%              can't give too much guidance as to how to set this
%              parameter, but values much larger or smaller than
%              the default don't seem to work very well in the
%              experiments I've done.

function [Yopt,Wopt]=RADICAL(X)
global Yoptt
% The recommended default parameter values are:
% K=150;
% AUG_FLAG=1;
% reps=30;
% stdev=0.175;

% ************************************************************
% User should change parameter values here:
K=150;
AUG_FLAG=1;
reps=30;
stdev=0.175;
% ************************************************************

% When AUG_FLAG is off, do not augment data. Use original data only.
if AUG_FLAG==0
  reps=1;
end

%dim * N : X is row vectors
[dim,N]=size(X);
m=floor(sqrt(N));      % m for use in m-spacing estimator.

% ****************
% Whiten the data. Store the whitening operation to combine with
% rotation matrix for total solution.

[u,s,v]=svd(cov(X'));
Whitening_mat=v*s^(-.5)*u';
X_white=Whitening_mat*X;

%dlmwrite('covX.txt',cov(X'),'delimiter','\t','precision',5);
%dlmwrite('X_white.txt',X_white','delimiter','\t','precision',5);
%dlmwrite('Whitening_mat.txt',Whitening_mat','delimiter','\t','precision',5);

sweeps=dim-1;
%oldTotalRot=eye(dim);
%sweepIter=0;             % Current sweep number.
totalRot=eye(dim);

%dim * N : xcur is row vectors
xcur=X_white;
%dlmwrite('xcur.txt',xcur','delimiter','\t','precision',5);

% K represents the number of rotations to examine on the FINAL
% sweep. To optimize performance, we start with a smaller number of
% rotations to examine. Then, we increase the
% number of angles to get better resolution as we get closer to the
% solution. For the first half of the sweeps, we use a constant
% number for K. Then we increase it exponentially toward the finish.
finalK=K;
startKfloat=(finalK/1.3^(ceil(sweeps/2)));
newKfloat=startKfloat;

for sweepNum=1:sweeps
  fprintf(1,'Sweep # %d of %d.\n',sweepNum,sweeps);
  %range=pi/2;

  % Compute number of angle samples for this sweep.

  if sweepNum>(sweeps/2)
	newKfloat=newKfloat*1.3;
    newK=floor(newKfloat);
	fprintf(1,'newKfloat: %f, newK:%f.\n',startKfloat/1.3, newK);
  else
    newKfloat=startKfloat;
    newK=max(30,floor(newKfloat));
    fprintf(1,'>>startKfloat: %f, newK:%f.\n',startKfloat, newK);
  end

  fprintf(1,'newK # %d of %f.\n',newK,newKfloat);

  % *********************************************************
  % Iterate over all possible Jacobi rotations.
  % *********************************************************
  for i=1:dim-1
    for j=i+1:dim

      fprintf(1,'Unmixing dimensions %02d and %02d ...',i,j);
      % **********************************************
      % Extract dimensions (i,j) from the current data.
      % **********************************************
      % xcur : dim * N, row vectors
      % [xcur(i,:);xcur(j,:)] => [i-row;j-row] => 2*N matrix
      curSubSpace=[xcur(i,:);xcur(j,:)];

      % ***************************************************
      % Find the best angle theta for this Jacobi rotation.
      % ***************************************************

      %[thetaStar,rotStar]=radicalOptTheta(curSubSpace,stdev,m,reps,newK,range);
      [thetaStar,rotStar]=radicalOptTheta(curSubSpace,stdev,m,reps,newK);

      % *****************************************
      % Incorporate Jacobi rotation into solution.
      % *****************************************
      newRotComponent=eye(dim);
      newRotComponent(i,i)=cos(thetaStar);
      newRotComponent(i,j)=-sin(thetaStar);
      newRotComponent(j,i)=sin(thetaStar);
      newRotComponent(j,j)=cos(thetaStar);
      %newRotComponent
      totalRot=newRotComponent*totalRot;
      xcur=totalRot*X_white;
    end
  end

  %oldTotalRot=totalRot;
end
totalRot
Whitening_mat
Wopt=totalRot*Whitening_mat;
Yopt=Wopt*X;
cov(Yopt')
Yoptt=totalRot*X_white;