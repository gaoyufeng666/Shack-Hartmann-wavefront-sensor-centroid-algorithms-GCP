load('TestData100_DM_SH.mat');
load('shstruct.mat');
[shstruct.Delta_nearby,sh_map] = Point_2Dlacation_GYF(shstruct);
%--------------- data save
SNR_level = 4.1;
Deltatestnum_xy = size(TestData.SHdeltas,2);
%%  -------------------- simulated image
Test_SHdeltas  = TestData.SHdeltas(7,:);
[outputDeltas_matrix, SNR_vec] = Delta_simulation_testAlgr(Test_SHdeltas,...
    SNR_level,...
    {'centroid_SNRsegment'});
[Deltas_GCP,padding_index] = Delta_xy_Diffcheck_GYF(outputDeltas_matrix(:),...
    shstruct.Delta_nearby,shstruct.dai_E1,shstruct.dai_pE1);
%%   draw
% show deltas map
shwfs_plot_paddingIdx_quivers(Test_SHdeltas,Deltas_GCP,padding_index,shstruct);
% show SNR map
SNR_map = sh_map;
for ii = 1:shstruct.nspots
    SNR_map(sh_map==ii) = SNR_vec(ii);
end
SNR_map(sh_map==0)=NaN;
figure;
imagesc(SNR_map);
axis square;
axis off
title('SNR map')
colorbar;

