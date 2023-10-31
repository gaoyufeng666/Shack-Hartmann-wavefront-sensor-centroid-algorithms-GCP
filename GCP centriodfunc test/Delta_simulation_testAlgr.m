function [Delta_output,SNR_output] = Delta_simulation_testAlgr(Delta_1D,SNRlevel,MethodName_cell)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

Delta_xy = reshape(Delta_1D,[],2);
Delta_output = zeros(length(MethodName_cell),size(Delta_xy,1),size(Delta_xy,2));
SNR_output = zeros(size(Delta_xy,1),1);
for ii = 1:size(Delta_xy,1)
    wh = 51;
    [yy, xx] = meshgrid(1:wh, 1:wh);
    eps = 1e-8;
    x0 = (wh+1)/2 + Delta_xy(ii,1) + eps;
    y0 = (wh+1)/2 + Delta_xy(ii,2) + eps;
    Q = 0.32;
    img_spot = (sin(Q*(xx-x0)).*sin(Q*(yy-y0))./(Q^2*(xx-x0).*(yy-y0))).^2;
    img_spot_noise = Image_addnoise(img_spot,SNRlevel);

%     imwrite(mat2gray(img_spot_noise),'SubimageStack.tif','WriteMode','append');
    %----------------------------
    for nn = 1:length(MethodName_cell)
        eval(['Centroid_handle = @',MethodName_cell{nn},';']);
        Delta_output(nn,ii,:) = Centroid_handle(mat2gray(img_spot_noise))- (wh+1)/2;   
%         temp = reshape(Delta_output(nn,ii,:),1,2) - Delta_xy(ii,:);
%         if nn==2&&norm(temp)>20
%             figure;imagesc(img_spo_noise);
%         end
    end
    %---------- SNR calculation
    im_sort = sort(mat2gray(img_spot_noise(:)), 'descend');
    im_mean = mean(im_sort(50:end));
    im_sig = mean(im_sort(1:49))-im_mean;
    im_noise = rms(im_sort(50:end)-im_mean);
    SNR_output(ii) = im_sig/im_noise;
    
end
    
Delta_output = reshape(Delta_output,length(MethodName_cell),[]);
end

