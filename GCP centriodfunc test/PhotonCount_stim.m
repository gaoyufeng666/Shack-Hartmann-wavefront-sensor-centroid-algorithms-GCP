function [OutImg] = PhotonCount_stim(PhotonDistribution,Photon_num)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
h_w_pixle = size(PhotonDistribution,1);

P_2D = PhotonDistribution;
P_2D = floor(mat2gray(P_2D)*2^8);
% figure;imagesc(P_2D);
P_3D = zeros(h_w_pixle,h_w_pixle,256);
for ii = 1:h_w_pixle
     for jj = 1:h_w_pixle
         P_3D(ii,jj,1:P_2D(ii,jj)) = 1;
     end
end

P_3D = reshape(P_3D,[],1);
P_1D = find(P_3D);

%%
rand_matrix = randi(length(P_1D),Photon_num,1);
% [xx,yy,zz] = ind2sub(size(P_3D),P_1D(rand_matrix));
Edges_range = unique(rand_matrix);
[N,~]=histcounts(rand_matrix,[Edges_range;Edges_range(end)+0.1]);



%%
rand_image_3D = zeros(h_w_pixle,h_w_pixle,256);
rand_image_3D(P_1D(Edges_range)) = N;
OutImg = sum(rand_image_3D,3);
end

