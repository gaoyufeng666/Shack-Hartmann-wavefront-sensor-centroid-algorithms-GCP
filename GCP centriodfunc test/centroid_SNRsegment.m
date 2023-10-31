function [ret] = centroid_SNRsegment(im, thr)
% refer 'Analysis of the wavefront reconstruction error of the spot location algorithms for the Shack–Hartmann wavefront sensor'
%
im=double(im);
assert(isa(im, 'double'));
% global select;
if (nargin < 2)
    thr = 0;
end
% thr=1500;

im_sort = sort(im(:), 'descend');
im_mean = mean(im_sort(50:end));
im_sig = mean(im_sort(1:49))-im_mean;
im_noise = rms(im_sort(50:end)-im_mean);
im_SNR = im_sig/im_noise;
% if im_SNR>6.5
%     thr_percent = 0.5;
% elseif (im_SNR<=6.5 && im_SNR>3.5)
%     thr_percent = 0.3/3*(6.5-im_SNR)+0.5;
% else 
%     thr_percent = 0.8;
% end
% 
% if (nargin <3)  
%     iimin = min(min(im));
%     iimax = max(max(im));
%     thr = (iimax - iimin)*thr_percent + iimin;
% end

% ------------gauss filter to supress noise


if im_SNR<7  
    if  im_SNR<3  %  ((mean(im(:))*5.4)<max(im(:))) &&
        ret = [nan,nan];
    else
        ret = centroid_TCorre(im,thr);
    end
    
    
else
    %------- gravity center
    ret = centroid(im,thr);
end






end
