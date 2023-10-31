function [img_spo_noise] = Image_addnoise(img_spot_ini,SNR_level)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
img_spot = img_spot_ini;
SNR_level_jitter = SNR_level + randn(1)/2;
if SNR_level_jitter<3
    SNR_level_jitter = 1./(1+exp(-SNR_level_jitter+3))+2.5;
end
if SNR_level_jitter>10
    SNR_level_jitter = 10;
end
 %------------------ add noise 
    noise_sigma = 0.25e-5;
    noise_int = 0.019;
    img_spo_noise_gauss = double(imnoise(uint16(zeros(size(img_spot))),'gaussian',noise_int,noise_sigma));
    img_spo_noise_gauss2 = double(imnoise(uint16(zeros(size(img_spot))),'gaussian',noise_int,noise_sigma));
    img_spo_noise_gauss = img_spo_noise_gauss-img_spo_noise_gauss2;
%     figure;imagesc(img_spo_noise);
    img_spot = PhotonCount_stim(img_spot_ini,round(8000*(SNR_level_jitter -2.5)+500));

%     figure;imagesc(img_spot);

    img_spo_noise_pepper = imnoise(double(img_spot-img_spot),'salt & pepper',0.01/(1+exp(1.5*(SNR_level_jitter-1.5)-2.111)));
%     figure;imagesc(img_spo_noise);
    img_spo_noise = img_spot + img_spo_noise_gauss/4;
    pepper_num = sum(sum(img_spo_noise_pepper==1));
    max_noise =  max(img_spo_noise(:));
    if SNR_level<7
        img_spo_noise(img_spo_noise_pepper==1) = (max_noise + randi(round(max_noise/8),pepper_num,1)+max_noise/16);%sign(randi(2,pepper_num,1)-1.5).*

    end
%     disp([num2str(SNR_level_jitter),'-----------------']);
%     [~,SNR_img] = centroid(img_spo_noise);
%     disp(SNR_img);
end

