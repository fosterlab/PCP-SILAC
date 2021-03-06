%MAKEFIGURES_ALIGNMENT Makes figures for the PRINCE Alignment module.

%colsr = {[1 0 0 ] [0 1 0] [0 0 1]};
colsr = rand(Nreplicates,3);


%% Bar alignment figures
% use pfit from Alignment.m
Image=figure; 

for kk = 1:2
  subplot(2,1,kk)
  hold on
  
  ci = 1;
  x = 1:55;
  
  x_rep = nan(Nreplicates,length(x));
  for rr = 1:Nreplicates
    if kk == 1
      x_rep(rr,:) = x;
    else
      b = pfit(ci,rr,1); % intercept
      m = pfit(ci,rr,2); % slope
      x_rep(rr,:) = x*m + b;
    end
  end
  
  % make initial patches for legend
  for rr = 1:Nreplicates
    patch([-1 -1 -2 -2]*.01 - 100,[-2 -1 -1 -2]*.01 -100,colsr(rr,:))
  end
  
  for rr = 1:Nreplicates
    for pp = 1:length(x)-1
      if mod(pp,5) == 0;
        cc = [.5 .5 .5];
      else
        cc = colsr(rr,:);
      end
      patch([x_rep(rr,pp) x_rep(rr,pp) x_rep(rr,pp+1) x_rep(rr,pp+1)],[rr rr+1 rr+1 rr],cc)
    end
    patch([x_rep(rr,end) x_rep(rr,end) x_rep(rr,end)+1 x_rep(rr,end)+1],[rr rr+1 rr+1 rr],cc)
  end
  
  %Figure details
  axis([-3 60 0.5 Nreplicates+1.5]);
  if kk == 1
    title('Before alignment','FontSize', 12);
  else
    title('After alignment','FontSize', 12);
  end
  ylabel('Replicates','FontSize', 12);
  xlabel('Fractions','FontSize', 12);
  sleg = cell(Nreplicates,1);
  for jj = 1:Nreplicates
    sleg{jj} = ['Replicate ' num2str(jj)];
  end
  legend(sleg, 'Orientation', 'horizontal','Location', 'South')
  
  set(gca,'YTickLabel',[],'ytick',[]);
  
  %generate image name
  Image_name = [figdir 'Bar_alignment_image.png'];
  
  %Save image
  saveas(Image, Image_name)
end



% % Divergence histograms
% 
% raw_bin_values=1:50;
% 
% for ci = 1:Nchannels
%   figure
%   
%   for ii = 1:Nreplicates
%     subplot(Nreplicates,1,ii)
%     raw_divergent=abs(Delta_height{ci,replicate_to_align_against(ci),ii}) ...
%       + abs(Delta_width{ci,replicate_to_align_against(ci),ii})...
%       + abs(Delta_center{ci,replicate_to_align_against(ci),ii});
%     hist(raw_divergent,raw_bin_values)
%     title('Divergence between rep1 and rep2')
%     xlabel('Divergence');
%     ylabel('Number of identifications');
%   end
%   
%     subplot(2,2,2)
%     raw_divergent=abs(Delta_height{ci,1,3})+abs(Delta_width{ci,1,3})+abs(Delta_center{ci,1,3});
%     hist(raw_divergent,raw_bin_values)
%     title('Divergence between rep1 and rep2')
%     xlabel('Divergence');
%     ylabel('Number of identifications');
%   
%     subplot(2,2,3)
%     raw_divergent=abs(Delta_height{ci,3,2})+abs(Delta_width{ci,3,2})+abs(Delta_center{ci,3,2});
%     hist(raw_divergent,raw_bin_values)
%     title('Divergence between rep1 and rep2')
%     xlabel('Divergence');
%     ylabel('Number of identifications');
%   
%   Image_name=[figdir 'DivergenceHist_between_replicates' Experimental_channels{ci} '.png'];
%   saveas(gcf, Image_name, 'png');
% end
% 
% 
% 
% % Delta_C, _H, _W, _Euc histogram
% 
% comparisons = nan(Nreplicates,2);
% for ii = 1:Nreplicates
%   comparisons(ii,:) = [replicate_to_align_against(ci) ii];
% end
% 
% for ci = 1:Nchannels
%   for rr = 1:size(comparisons,1)
%     rr1 = comparisons(rr,1);
%     rr2 = comparisons(rr,2);
%     
%     Hist of Center, height and width widthin user defined setting
%     fh2 = figure; % open figure tablet to create figure on
%     
%     hist for height
%     P1=subplot(4,1,1); hold on
%     raw_bin_height_values_user=0.1:0.1:7.5; % bin values can be changed by the user to improve figure quility
%     Histc_height=histc(Delta_height{ci,rr1,rr2},raw_bin_height_values_user);
%     bar(raw_bin_height_values_user,Histc_height); %crete bar graph of values
%     y=ylim;
%     plot([1 1].*prctile(Delta_height{ci,rr1,rr2},90),y,'k')
%     xlabel(P1,'Height');
%     ylabel(P1,'# of Gaussians');
%     
%     hist for center
%     P2=subplot(4,1,2); hold on
%     raw_bin_center_values_user=0.1:0.1:4.5;
%     Histc_center=histc(Delta_center{ci,rr1,rr2},raw_bin_center_values_user);
%     bar(raw_bin_center_values_user,Histc_center);
%     y=ylim;
%     plot([1 1].*prctile(Delta_center{ci,rr1,rr2},90),y,'k')
%     xlabel(P2,'Center');
%     ylabel(P2,'# of Gaussians');
%     
%     hist for width
%     P3=subplot(4,1,3); hold on
%     raw_bin_center_values_user=0.1:0.1:4.5;
%     Histc_center=histc(Delta_width{ci,rr1,rr2},raw_bin_center_values_user);
%     bar(raw_bin_center_values_user,Histc_center);
%     y=ylim;
%     plot([1 1].*prctile(Delta_width{ci,rr1,rr2},90),y,'k')
%     xlabel(P3,'Width');
%     ylabel(P3,'# of Gaussians');
%     
%     hist for Euclidean distance
%     P4 = subplot(4,1,4); hold on
%     Euclidean_distance_maximum_value=max(EuDis{ci,rr1,rr2});
%     raw_bin_Euclidean_distance_values_user=0.5:0.5:Euclidean_distance_maximum_value;
%     Histc_Euclidean_distance=histc(EuDis{ci,rr1,rr2},raw_bin_Euclidean_distance_values_user);
%     bar(raw_bin_Euclidean_distance_values_user,Histc_Euclidean_distance);
%     y=ylim;
%     plot([1 1].*prctile(EuDis{ci,rr1,rr2},90),y,'k')
%     xlabel(P4,'Euclidean Distance');
%     ylabel(P4,'# of Gaussians');
%     
%     Image_name=[figdir 'Histograms_rep' num2str(rr1) '_vs_rep' num2str(rr2) '_' Experimental_channels{ci} '.png'];
%     saveas(gcf, Image_name, 'png');
%   end
% end



%% Delta_C scatter, rep vs rep_align

for ci = 1:Nchannels
  figure
  RR = replicate_to_align_against(ci);
  
  for ri = 1:Nreplicates
    subplot(Nreplicates,1,ri),hold on
    plot([0 55],[0 55],'--r')
    overlap = intersect(summerised_names_G1{ci,ri},summerised_names_G1{ci,RR});
    overlap([1 2]) = [];
    Ia = find(ismember(Gaus_import{ci,ri}.textdata(:,1),overlap));
    Ib = find(ismember(Gaus_import{ci,RR}.textdata(:,1),overlap));
    x = Gaus_import{ci,ri}.data(Ia,2);
    y = Gaus_import{ci,RR}.data(Ib,2);
    scatter(x,y,20,abs(x-y),'filled')
    xlabel(['replicate ' num2str(ri)])
    ylabel('alignment replicate')
  end
  
  %   ri = 2;
  %   subplot(3,1,ri),hold on
  %   plot([0 55],[0 55],'--r')
  %   overlap = intersect(summerised_names_G1{ci,ri},summerised_names_G1{ci,RR});
  %   overlap([1 2]) = [];
  %   Ia = find(ismember(Gaus_import{ci,ri}.textdata(:,4),overlap));
  %   Ib = find(ismember(Gaus_import{ci,RR}.textdata(:,4),overlap));
  %   x = Gaus_import{ci,ri}.data(Ia-1,2);
  %   y = Gaus_import{ci,RR}.data(Ib-1,2);
  %   scatter(x,y,20,abs(x-y),'filled')
  %   xlabel('replicate 2')
  %   ylabel('alignment replicate')
  %
  %   ri = 3;
  %   subplot(3,1,ri),hold on
  %   plot([0 55],[0 55],'--r')
  %   overlap = intersect(summerised_names_G1{ci,ri},summerised_names_G1{ci,RR});
  %   overlap([1 2]) = [];
  %   Ia = find(ismember(Gaus_import{ci,ri}.textdata(:,4),overlap));
  %   Ib = find(ismember(Gaus_import{ci,RR}.textdata(:,4),overlap));
  %   x = Gaus_import{ci,ri}.data(Ia-1,2);
  %   y = Gaus_import{ci,RR}.data(Ib-1,2);
  %   scatter(x,y,20,abs(x-y),'filled')
  %   xlabel('replicate 3')
  %   ylabel('alignment replicate')
  
  Image_name=[figdir 'Scatter_allreps_' Experimental_channels{ci} '.png'];
  set(gcf,'paperunits','inches','paperposition',[0.1 0.1 6 2+2*Nreplicates])
  saveas(gcf, Image_name, 'png');
end

