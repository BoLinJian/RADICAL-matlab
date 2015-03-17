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

%load examples/data_5d_ind -ASCII
%load examples/data_5d_mixed -ASCII
%load examples/A_5d -ASCII
format short g;

%row vectors : 3XN
%col vec : N X3
load examples/fps25_raw -ASCII

%figure;
%plot(fps25_3d_mixed(1,:));
%figure;
%plot(fps25_3d_mixed(2,:));
%figure;
%plot(fps25_3d_mixed(3,:));

%col vec
fps25=fps25_raw;
#detrend only on "column vector"
d_data = detrend(fps25);

%figure;
%plot(d_data(:,1));
%figure;
%plot(d_data(:,2));
%figure;
%plot(d_data(:,3));

#mean in column vector
m_data = mean(d_data);
s_data = std(d_data);
#n_data = (d_data - m_data) / s_data;

#zscore to zero mean and unit variance
%Z = zscore(d_data);
%mean(Z);
%std(Z);
%figure;
%plot(Z(:,1));
%figure;
%plot(Z(:,2));
%figure;
%plot(Z(:,3));
%#colum vectors to row vectors
%fps25_3d_mixed=Z';

%row vec
fps25_3d_mixed=d_data';
#%row vectors : 3XN
[Yopt,Wopt]=RADICAL(fps25_3d_mixed);
data_3d_unmixed=Yopt;

figure;
plot(Yopt(1,:));
figure;
plot(Yopt(2,:));
figure;
plot(Yopt(3,:));

%figure(1);
%clf;
%for i=1:4
%  for j=i+1:5
%    subplot(4,4,(j-2)*4+i);
%    plot(data_5d_ind(i,:),data_5d_ind(j,:),'.');
%    axis tight;
%    axis square;
%    t=sprintf('dim %d vs. %d',i,j);
%    title(t);
%  end
%end
%subplot(4,4,3);
%axis off;
%title('Original independent components.');

if(0)
%figure;
clf;
for i=1:2
  for j=i+1:3
    subplot(2,2,(j-2)*2+i);
    plot(fps25_3d_mixed(i,:),fps25_3d_mixed(j,:),'.');
    axis tight;
    axis square;
    t=sprintf('dim %d vs. %d',i,j);
    title(t);
  end
end

subplot(2,2,2);
axis off;
title('Mixed components.');

figure;
clf;
for i=1:2
  for j=i+1:3
    subplot(2,2,(j-2)*2+i);
    plot(data_3d_unmixed(i,:),data_3d_unmixed(j,:),'.');
    axis tight;
    axis square;
    t=sprintf('dim %d vs. %d',i,j);
    title(t);
  end
end
subplot(2,2,2);
endif

axis off;
title('Unmixed components.');
#row to column : 3XN -> NX3
data_3d_unmixedt=data_3d_unmixed';
#column wise B,G,R
amp = fft(data_3d_unmixedt);
#".^2" is the element-wise power of 2, each element is powered of 2
pows = abs(amp).^2 ;
#
samp = fftshift(fft(data_3d_unmixedt));
spows=abs(samp).^2 ;
#
figure;
plot(spows(:,1));
figure;
plot(pows(:,1));
figure;
plot(spows(:,2));
figure;
plot(pows(:,2));
figure;
plot(spows(:,3));
figure;
plot(pows(:,3));
