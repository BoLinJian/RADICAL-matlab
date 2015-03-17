% *****************************************************************
% Copyright (c) Erik G. Learned-Miller, 2003.
% ********************************************************
% demo_3d
% ********************************************************
%
% This code illustrates the use of RADICAL.m
% In the examples directory, you will find the following files:
%
% data_3d_unmixed   - samples from a 5-d distribution with independent
%                 components.
% fps25_3d_mixed - the same samples after they have undergone a
%                 linear transformation, which mixes the components
%                 so that they are no longer independent.
%
% ********************************************************
% The program plots two-dimensional marginals of the original
% independent samples, the two-dimensional marginals of the mixed
% samples, and RADICAL_2D's attempt at unmixing the samples.

format short g;

%col vec : N X3
load examples/fps25_raw

figure;
plot(fps25_raw(:,1));
title('R Raw @fps25');
figure;
plot(fps25_raw(:,2));
title('G Raw @fps25');
figure;
plot(fps25_raw(:,3));
title('B Raw @fps25');

%col vec
%detrend only on "column vector"
d_data = detrend(fps25_raw);

figure;
plot(d_data(:,1));
title('R detrend @fps25');
figure;
plot(d_data(:,2));
title('G detrend @fps25');
figure;
plot(d_data(:,3));
title('B detrend @fps25');

%mean in column vector
m_data = mean(d_data);
s_data = std(d_data);
%n_data = (d_data - m_data) / s_data;

% ****************
% Whiten the data. Store the whitening operation to combine with
% rotation matrix for total solution.
%cov accepts column vector
[u,s,v]=svd(cov(d_data));
Whitening_mat=v*s^(-.5)*u';
%X_white : row-major form
X_white=Whitening_mat*d_data';
%back to column major
X_white=X_white';
figure;
plot(X_white(:,1));
title('R whitened @fps25');
figure;
plot(X_white(:,2));
title('G whitened @fps25');
figure;
plot(X_white(:,3));
title('B whitened @fps25');

#column wise B,G,R
amp = fft(X_white);
#".^2" is the element-wise power of 2, each element is powered of 2
pows = abs(amp).^2 ;
#
samp = fftshift(amp);
spows=abs(samp).^2 ;
#
figure;
plot(spows(:,1));
title('R fftshift spec @fps25');

figure;
plot(pows(:,1));
title('R fft spec @fps25');

figure;
plot(spows(:,2));
title('G fftshift spec @fps25');

figure;
plot(pows(:,2));
title('G fft spec @fps25');

figure;
plot(spows(:,3));
title('B fftshift spec @fps25');

figure;
plot(pows(:,3));
title('B fft spec @fps25');