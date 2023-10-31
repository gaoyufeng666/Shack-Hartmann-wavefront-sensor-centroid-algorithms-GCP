function [ret] = centroid_Corre(im, thr, im_refer)
% refer 'Analysis of the wavefront reconstruction error of the spot location algorithms for the Shack–Hartmann wavefront sensor'
% 

im=double(im);
assert(isa(im, 'double'));
% global select;
if (nargin < 2)
    thr = 0;
end
%---------------------
% im(im < thr) = 0;
im = mat2gray(im);
[w, h] = size(im);
if (nargin<3)    
    [yy, xx] = meshgrid(1:11, 1:11);
    eps = 1e-7;
    x0 = 6 + eps;
    y0 = 6 + eps;
    Q = 0.32;
    im_refer = (sin(Q*(xx-x0)).*sin(Q*(yy-y0))./(Q^2*(xx-x0).*(yy-y0))).^2;
else
    im_refer = mat2gray(im_refer);
    x0 = h/2;
    y0 = w/2;
end
%------------------------

% [optimizer, metric] = imregconfig('monomodal');
% tform = imregtform(im,im_refer, 'translation', optimizer, metric);
% ret = [tform.T(3,1) tform.T(3,2)]+[x0 y0];
%------------------------
% tform = imregcorr(im,im_refer,'translation');
C = normxcorr2(im_refer,im);
CC = C(5:(4+w),5:(4+h));
CC(1:6,:) = 0;
CC(end-5:end,:) = 0;
CC(:,1:6) = 0;
CC(:,end-5:end) = 0;
[xpeak, ypeak, peakVal] = findpeak(CC,1);

if peakVal>0.01
    if ypeak<0||xpeak<0||ypeak>h||xpeak>h
            ret = [nan nan];
    else
        ret = double([ypeak-1,xpeak-1]);
    end
else
    ret = [(h+1)/2, (w+1)/2];
end

%---------------------------

end
