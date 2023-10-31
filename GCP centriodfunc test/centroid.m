% RET = CENTROID(IM, THR).
%   RET = CENTROID(IMG, THR) computes the centroid of IMG using THR as the
%   relative threshold. Centroid works on column major order.
%   shstruct.ord_centres and shstruct.ord_sqgrid are stored in the x,y
%   plot() coordinates, (origin is in the top left, x points right, y
%   points down). [cc(1)+dd(2)-1, cc(3)+dd(1)-1].
%
% Author: Jacopo Antonello, <jack@antonello.org>
% Technische Universiteit Delft
%用重心法计算质心
function [ret,im_SNR] = centroid(im, thr)
im=double(im);
assert(isa(im, 'double'));
%%----------------- SNR 
im_sort = sort(im(:), 'descend');
im_mean = mean(im_sort(50:end));
im_sig = mean(im_sort(1:49))-im_mean;
im_noise = rms(im_sort(50:end)-im_mean);
im_SNR = im_sig/im_noise;
if im_SNR>6.5
    thr_percent = 0.5;
elseif (im_SNR<=6.5 && im_SNR>3.5)
    thr_percent = 0.3/3*(6.5-im_SNR)+0.5;
else 
    thr_percent = 0.8;
end
%-------------------
if (nargin <3)  
    iimin = min(min(im));
    iimax = max(max(im));
    thr = (iimax - iimin)*thr_percent + iimin;
end

%----------------- SNR 
% thr=1500;
[w, h] = size(im);

[yy, xx] = meshgrid(1:h, 1:w);
im(im < thr) = 0;
sumx = sum(reshape(xx.*im, numel(xx), 1));
sumy = sum(reshape(yy.*im, numel(yy), 1));
mass = sum(im(:));

% mass1 = 0;
% sumx1 = 0;
% sumy1 = 0;
% for x=1:w
%     for y=1:h
%         val1 = im(x, y);
%         if (val1 >= thr)
%             sumx1 = sumx1 + val1*x;
%             sumy1 = sumy1 + val1*y;
%             mass1 = mass1 + val1;
%         end
%     end
% end
% assert(norm(mass1 - mass) < 1e-10);
% assert(norm(sumx1 - sumx) < 1e-10);
% assert(norm(sumy1 - sumy) < 1e-10);
% mass = mass1;
% sumx = sumx1;
% sumy = sumy1;

ret = [sumx/mass, sumy/mass];
% ret = round(ret);

% if select
% sfigure(12);
% imshow(im);
% hold on;
% plot(ret(2), ret(1), 'xr');
% pause(0.1);
% end

end
