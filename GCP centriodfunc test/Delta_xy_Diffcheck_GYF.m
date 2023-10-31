function [Delta_correct,Delta_Gxy_binary_ini,deltas_fromDM] = Delta_xy_Diffcheck_GYF(Delta_xy,Delta_nearby_ini,Delta2axis,Axis2delta)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
if ~(size(Delta_xy,1)==size(Delta2axis,1)/2)
    if length(Delta_xy)==size(Delta2axis,1)
        Delta_xy = reshape(Delta_xy,[],2);        
    else       
        error('Please transpose the first input');
    end
end

%%
% Delta_x_img = nan(size(Delta_map));
% Delta_y_img = nan(size(Delta_map));
%%
% for ii = 1:size(Delta_xy,1)
%     idx_temp = find(Delta_map == ii);    
%     Delta_x_img(idx_temp) = Delta_xy(ii,1);
%     Delta_y_img(idx_temp) = Delta_xy(ii,2);
% end
%%

Delta_xy_nanMask = isnan(Delta_xy);
Delta_xy(Delta_xy_nanMask)=0;
disp(sum(Delta_xy_nanMask(:)));

%% diff of delta xy

Delta_Gxy_img = Delta_xy(:)' - Delta_xy(:)'*Delta2axis*Axis2delta;
deltas_fromDM = Delta_xy-reshape(Delta_Gxy_img,[],2);
Delta_Gxy_img = abs(reshape(Delta_Gxy_img,[],2));
Delta_Gxy_img_r = (Delta_Gxy_img(:,1).^2 + Delta_Gxy_img(:,2).^2);
disp(max(Delta_Gxy_img_r(:)));
%% threshold to find large diff
Diff_threshold = 16; % using  16
Delta_Gxy_img_binary = Delta_Gxy_img_r>Diff_threshold;
%% map to idx
Delta_Gxy_binary_ini = Delta_Gxy_img_binary | Delta_xy_nanMask(:,1);
Delta_Gxy_binary = Delta_Gxy_binary_ini;
disp(sum(Delta_Gxy_binary(:)));
%% check NaN
Delta_xy(Delta_Gxy_binary,:) = nan;
Delta_correct = Delta_xy;

while sum(sum(isnan(Delta_xy)))>0
    Delta_nearby = Delta_nearby_ini;
    for ii = 1:size(Delta_xy,1)
        if Delta_Gxy_binary(ii) == 1

            for kk = 2:5
                if ~isnan(Delta_nearby(ii,kk))      
                    if Delta_nearby(ii,kk)==0||isnan(Delta_nearby(ii,kk))
                        Delta_nearby(ii,kk) = nan;
                    else
                        temp = Delta_Gxy_binary(Delta_nearby(ii,kk),1);
                        if temp==1
                            Delta_nearby(ii,kk) = nan;
                        end
                    end
                end
            end      


        end    
    end
    Delta_nearby_nanCount = isnan(Delta_nearby(:,2:end));
    Delta_nearby_nanCount = sum(Delta_nearby_nanCount,2);
    Delta_nearby(:,1) = Delta_nearby_nanCount;  
    
%% replace wrong Delta_xy

    for ii = 1:size(Delta_xy,1)
        if Delta_Gxy_binary(ii) == 1
            if Delta_nearby(ii,1) < 2
                Delta_xx_temp = Delta_nearby(ii,2:3);
                Delta_yy_temp = Delta_nearby(ii,4:5);   
                Delta_xx_temp(isnan(Delta_xx_temp)) = [];
                Delta_yy_temp(isnan(Delta_yy_temp)) = [];   
                Delta_correct(ii,1) = mean(Delta_xy(Delta_xx_temp,1) );
                Delta_correct(ii,2) = mean(Delta_xy(Delta_yy_temp,2) );
            elseif Delta_nearby(ii,1) == 2||Delta_nearby(ii,1) == 3
                Delta_xx_temp = Delta_nearby(ii,2:5);
                Delta_yy_temp = Delta_nearby(ii,2:5);
                Delta_xx_temp(isnan(Delta_xx_temp)) = [];
                Delta_yy_temp(isnan(Delta_yy_temp)) = [];                    
                Delta_correct(ii,1) = mean(Delta_xy(Delta_xx_temp,1));
                Delta_correct(ii,2) = mean(Delta_xy(Delta_yy_temp,2));       
            
            end
        end    
    end
    Delta_xy = Delta_correct;
    if sum(isnan(Delta_xy(:,1)))==sum(Delta_Gxy_binary)
        break;
    else
        Delta_Gxy_binary = isnan(Delta_xy(:,1));
    end

end

end

