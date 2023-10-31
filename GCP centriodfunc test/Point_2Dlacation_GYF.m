function [out_mat,idx_image] = Point_2Dlacation_GYF(shstruct)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%----------------
point = shstruct.centres;
microlens_pixls = shstruct.pitch /shstruct.camera_pixsize;
point_centered = point - shstruct.pupil_centre_pix;
%---------------- rotate image to get 
theta = 0;
T=[cos(theta) -sin(theta); sin(theta) cos(theta)];
point_rotated_centered = point_centered *T;
%%
point_rotated_centered_Nmicrolens = point_rotated_centered/microlens_pixls;
point_rotated_centered_Nmicrolens_r = point_rotated_centered_Nmicrolens(:,1).^2+point_rotated_centered_Nmicrolens(:,2).^2;
[~,min_idx] = min(point_rotated_centered_Nmicrolens_r);
point_rotated_centered_Nmicrolens = point_rotated_centered_Nmicrolens-point_rotated_centered_Nmicrolens(min_idx,:);


%%
XY_location = round(point_rotated_centered_Nmicrolens); 
%%
XY_location2 = XY_location - min(XY_location)+1;
Point_image = zeros(max(XY_location2));
idx_image = zeros(size(Point_image));
for ii = 1:size(XY_location2,1)
    Point_image(XY_location2(ii,1),XY_location2(ii,2))  = 1;
    idx_image(XY_location2(ii,1),XY_location2(ii,2))=ii;
end

%%
Point_image_expand = zeros(size(Point_image)+2);
Point_image_expand(2:end-1,2:end-1) = Point_image;
[Gx,Gy] = imgradientxy(Point_image_expand,'central');
Gx(Point_image_expand==0)=0;
Gy(Point_image_expand==0)=0;
temp = (abs(Gx)>0)+(abs(Gy)>0);
temp = temp>0;
Point_edge = temp(2:end-1,2:end-1);
%%

out_mat = zeros(size(XY_location,1),5);
for ii = 1:size(XY_location2,1)
    if Point_edge(XY_location2(ii,1),XY_location2(ii,2))  == 1
        out_mat(ii,1) =  0;
%         idx= XY_location(ii,:);
%         idx_sign = sign(idx);
%         idx_abs = abs(idx);
%         idx_abs2 = idx_abs-1;
%         idx_near = idx_abs2.*idx_sign;
%         out_mat(ii,2) = find(XY_location(:,1)==idx(1)& XY_location(:,2)==idx_near(2) );
%         out_mat(ii,3) = find(XY_location(:,1)==idx_near(1)& XY_location(:,2)==idx(2) );
%         out_mat(ii,4) = find(XY_location(:,1)==idx_near(1)& XY_location(:,2)==idx_near(2) );
        idx= XY_location(ii,:);
        %--------------
        aa_temp = find(XY_location(:,1)==(idx(1)+1)& XY_location(:,2)==idx(2) );
        if isempty(aa_temp)
            out_mat(ii,2) = nan;
        else 
            out_mat(ii,2) = aa_temp(1);
        end
        %-------------
        aa_temp = find(XY_location(:,1)==(idx(1)-1)& XY_location(:,2)==idx(2) ); 
        if isempty(aa_temp)
            out_mat(ii,3) = nan;
        else 
            out_mat(ii,3) = aa_temp(1);
        end
        %--------------
        aa_temp = find(XY_location(:,1)== idx(1)& XY_location(:,2)==(idx(2)+1) ); 
        if isempty(aa_temp)
            out_mat(ii,4) = nan;
        else 
            out_mat(ii,4) = aa_temp(1);
        end
        %--------------
        aa_temp = find(XY_location(:,1)== idx(1)& XY_location(:,2)==(idx(2)-1) ); 
        if isempty(aa_temp)
            out_mat(ii,5) = nan;
        else 
            out_mat(ii,5) = aa_temp(1);
        end        

    else 
        out_mat(ii,1) =  1;
        idx= XY_location(ii,:);      
        out_mat(ii,2) = find(XY_location(:,1)==(idx(1)+1)& XY_location(:,2)==idx(2) ,1);
        out_mat(ii,3) = find(XY_location(:,1)==(idx(1)-1)& XY_location(:,2)==idx(2) ,1);       
        out_mat(ii,4) = find(XY_location(:,1)== idx(1)& XY_location(:,2)==(idx(2)+1) ,1); 
        out_mat(ii,5) = find(XY_location(:,1)== idx(1)& XY_location(:,2)==(idx(2)-1) ,1); 
    end
end

end

