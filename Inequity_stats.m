%  Matlab 2019b script to generate figures and calculate SES and SES-G statistics
%  CC Attribution 2.0 (CC BY 2.0)
%  Attribution to Steven Lord and FoodSIVI www.foodsivi.org

%% read spreadsheet, get HDI, GII and cost columns

numVars = 8;
varNames = {'HDI','GII','NC','SC','NB','SB','C','B'} ;
varTypes = {'double','double','double','double','double','double','double','double'};
comps = {'Company A','Company B'};
ncomps=size(comps,2);
SES  = zeros(1,ncomps);
SESG = zeros(1,ncomps);
S=cell2struct(comps,'sheet',1);
DataRange='D3';
cap_color(1,:)=[0.5 0.5 0.5]; % fin benefits color
cap_color(2,:)=[0.5 0.5 0.5]; % fin costs color
cap_color(3,:)=[0.4660 0.6740 0.1880]; %nat benefits color
cap_color(4,:)=[153 255 51]/255; %nat costs color
cap_color(5,:)=[0 0.4470 0.7410]; %soc benefits color
cap_color(6,:)=[0.3010 0.7450 0.9330]; %soc costs color
cap_color(7,:)=[0.6350 0.0780 0.1840]; %net color

opts = spreadsheetImportOptions('NumVariables',numVars,...
                                'VariableNames',varNames,...
                                'VariableTypes',varTypes,...
                                'DataRange', DataRange); 
                            
%% loop over number of companies to get data
for k=1:ncomps

opts.Sheet=S(k).sheet;

T=readtable('Cocoa Supply Chain Figures.xlsx',opts);

%%clean up table

T(isnan(T.HDI),:)=[];

for i=1:size(T,2)
  T{isnan(T{:,i}),i}=0;
end
 
S(k).data=T;

%% make a 'total value' bridge

% figure
% 
% %X=categorical({'Revenue','Costs','N +','N -','S +','S -','Total'});
% %X = reordercats(X,{'Revenue','Costs','N +','N -','S +','S -','Total'});
% X=1:7;
% Y=zeros(7,2);
% 
% Y(1,2)=sum(S(k).data.B);
% Y(2,1)=sum(Y(1,:)) + sum(S(k).data.C);
% Y(2,2)=-sum(S(k).data.C);
% Y(3,1)=Y(2,1);
% Y(3,2)=sum(S(k).data.NB);
% Y(4,1)=sum(Y(3,:)) + sum(S(k).data.NC);
% Y(4,2)=-sum(S(k).data.NC);
% Y(5,1)=Y(4,1);
% Y(5,2)=sum(S(k).data.SB);
% Y(6,1)=sum(Y(5,:)) + sum(S(k).data.SC);
% Y(6,2)=-sum(S(k).data.SC);
% Y(7,1) = Y(1,1);
% Y(7,2) = Y(6,1);
% Y0=min(0,min(min(Y)));
% 
% for m=1:7
%     YY(m) = (-1)^(m+1)*Y(m,2);
% end
% 
% Y(1,1)=-Y0;
% Y(1,2)=sum(S(k).data.B);
% Y(2,1)=sum(Y(1,:)) + sum(S(k).data.C);
% Y(2,2)=-sum(S(k).data.C);
% Y(3,1)=Y(2,1);
% Y(3,2)=sum(S(k).data.NB);
% Y(4,1)=sum(Y(3,:)) + sum(S(k).data.NC);
% Y(4,2)=-sum(S(k).data.NC);
% Y(5,1)=Y(4,1);
% Y(5,2)=sum(S(k).data.SB);
% Y(6,1)=sum(Y(5,:)) + sum(S(k).data.SC);
% Y(6,2)=-sum(S(k).data.SC);
% Y(7,1) = Y(1,1);
% Y(7,2) = Y(6,1)-Y(1,1);
% 
% line([0.0001,8], [Y(1,1) Y(1,1)], 'Color', 'k', 'LineStyle', '-');
% 
% hold on
% 
% b=bar(X,Y,'stacked','FaceColor','flat');
% b(1).BaseLine.Visible = 'off';
% b(2).BaseLine.Visible = 'off';
% 
% b(1).CData(:,:) = 1;
% b(1).EdgeAlpha=0;
% b(1).FaceAlpha = 0;
% b(2).CData(1,:) = cap_color(1,:);
% b(2).CData(2,:) = cap_color(1,:);
% b(2).CData(3,:) = cap_color(3,:);
% b(2).CData(4,:) = cap_color(3,:);
% b(2).CData(5,:) = cap_color(5,:);
% b(2).CData(6,:) = cap_color(5,:);
% b(2).CData(7,:) = cap_color(7,:);
% 
% a=b.Parent;
% 
% plot_settings(a,'Cost or Benefit')
% 
% a.XColor='none';
% 
% xtips1 = b(2).XEndPoints;
% ytips1 = (b(2).YEndPoints+b(1).YEndPoints)/2;
% labels1 = string(YY);
% labels1(labels1=="0")="";
% text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','middle','Color','white')
% 
% hold off
% 
% %% make a 'net value' histogram
% 
% figure
% 
% X=categorical({'Financial','Natural','Social','Net'});
% X = reordercats(X,{'Financial','Natural','Social','Net'});
% Y=zeros(4,1);
% 
% Y(1,1)=sum(S(k).data.B)+ sum(S(k).data.C);
% Y(2,1)=sum(S(k).data.NB) + sum(S(k).data.NC);
% Y(3,1)=sum(S(k).data.SB) + sum(S(k).data.SC);
% Y(4,1)=sum(Y);
% 
% c=bar(X,Y,'FaceColor','flat');
% c.CData(1,:) = cap_color(1,:);
% c.CData(2,:) = cap_color(3,:);
% c.CData(3,:) = cap_color(5,:);
% c.CData(4,:) = cap_color(7,:);
% 
% a=c.Parent;
% 
% plot_settings(a,'Net Cost or Benefit')
% 
% a.XColor='none';
% 
% a.YTickLabels=[];
% xticks = a.XTickLabels(c.YData<0);
% xlabshift = 1;
% xtickspos = a.XTick(c.YData<0);
% for j=1:length(xticks)
%     text(xtickspos(j), xlabshift, xticks{j},'FontSize',10,'HorizontalAlignment','center');
% end
% a.XTickLabels(c.YData<0)={''};
% 
% xtips1 = c.XEndPoints;
% ytips1 = c.YEndPoints/2;
% labels1 = string(c.YData);
% text(xtips1,ytips1,labels1,'HorizontalAlignment','center',...
%     'VerticalAlignment','middle','Color','white')
% 
% %end

%% plots of dissagregated costs and benefits

Y=[];

[X,Y(:,3)]=aggre(S(k).data.HDI,S(k).data.NB);
[~,Y(:,4)]=aggre(S(k).data.HDI,S(k).data.NC);
[~,Y(:,5)]=aggre(S(k).data.HDI,S(k).data.SB);
[~,Y(:,6)]=aggre(S(k).data.HDI,S(k).data.SC);

Y(:,[1,2,7])=0;

% figure
% hold on
% set(gcf,'Renderer','painters');
% 
% Alabel={'Natural Capital Benefits', 'Natural Capital Costs','Social Capital Benefits', 'Social Capital Costs'};
% A=[1 2 3 4];
% 
% %plot a 3d bar
% 
% ymin(k) = min(X)-(1-min(X))*0.5;
% 
% s=line([0.01 0.01],[0,min(X)],[0 0],'LineWidth',3,'Color','white','YLimInclude','off');
% 
% a=s.Parent;
% a.YTick = round(min(X):(max(X)-min(X))/5:max(X),2);
% a.XLim = [0.01 4.99];
% % for i=1:length(a.YTick)
% %   line(a.XLim,[a.YTick(i),a.YTick(i)],[0 0],'LineStyle','-','LineWidth',0.5,'Color',[0.85,0.85,0.85],'XLimInclude','off',...
% %   'YLimInclude','off','ZLimInclude','off')  
% % end
% 
% b=bar3([ymin(k);X],[YY;Y],0.8);
% set(b(1),'FaceColor',cap_color(1,:));
% set(b(2),'FaceColor',cap_color(1,:));
% set(b(3),'FaceColor',cap_color(3,:));
% set(b(4),'FaceColor',cap_color(3,:));
% set(b(5),'FaceColor',cap_color(5,:));
% set(b(6),'FaceColor',cap_color(5,:));
% set(b(7),'FaceColor',cap_color(7,:));
% 
% bnew=surface;
% 
% for m=1:7
% id=find([1;Y(:,m)]==0);
% for i=1:length(id)
%     if ~(id(i)==1)
%     r=(id(i)-1)*6+1;
%     b1c = get(b(m),'cdata');
%     b1c(r:(r+5),1:4) = nan(6,4);
%     set(b(m),'cdata',b1c);
%     b1z = get(b(m),'zdata');
%     b1z(r:(r+5),1:4) = nan(6,4);
%     set(b(m),'zdata',b1z);
%     end
% end
% Xnonzero=X;
% Xnonzero(id-1)=[];
% if ~isempty(Xnonzero)
% x1=b(m).XData(1,2);
% x2=b(m).XData(1,3);
% ymaxm = max(Xnonzero);
% line([x1,x1],[ymin(k) ymaxm],[0 0],'LineStyle',':','Color',[0.5 0.5 0.5],'LineWidth',0.5)
% line([x2,x2],[ymin(k) ymaxm],[0 0],'LineStyle',':','Color',[0.5 0.5 0.5],'LineWidth',0.5)
% end
% bnew=[bnew split_bar(b(m),1)];
% text(m,ymin(k)-0.01,YY(m)/2,string(YY(m)),'HorizontalAlignment','center',...
%     'VerticalAlignment','middle','Color','white')
% end
% 
% delete(b);
% delete(bnew(1));
% bnew(1)=[];
% b=bnew;
% 
% a=b.Parent;
% 
% a.YTick = round(min(X):(max(X)-min(X))/5:max(X),2);
% a.XLim = [0.01 7.99];
% a.ZLim = [min(min([YY;Y])) max(max([YY;Y]))];
% %a.ZTick=unique(Y);
% a.XColor='none';
% a.View=[67.9733834809726 11.1867277080598];
% set(gcf,'Position',[584,69,681,916]);
% 
% plot3_settings(a,'Costs and Benefits')
% 
% 
% a.YTickLabelRotation=-45;
% a.YRuler.Axle.Layer='back';


%% plots for optimal transport in HDI

f(k)=figure;
hold on

%make a histogram by discretizing HDI scale
E=0:0.01:1;  % 100 bins
Xid = discretize(X,E);
XEid=unique(Xid);
YE=zeros(size(E,2),size(Y,2));
for i=1:length(X)
YE(Xid(i),:) = YE(Xid(i),:) + Y(i,:); %histogram of Y  
end
%plot just social
for j=1:length(XEid)
xpatch=[E(XEid(j)),E(XEid(j)),E(XEid(j)+1),E(XEid(j)+1)];
y1patch=[0,YE(XEid(j),6),YE(XEid(j),6),0];
y2patch=[0,YE(XEid(j),5),YE(XEid(j),5),0];
y3patch=[0,-YE(XEid(j),5),-YE(XEid(j),5),0];
p1=patch('XData',xpatch,'YData',y1patch);
p2=patch('XData',xpatch,'YData',y2patch);
p3=patch('XData',xpatch,'YData',y3patch);
p1.EdgeColor=cap_color(6,:);
p1.FaceColor=cap_color(6,:);
p2.EdgeColor=cap_color(5,:);
p2.FaceColor=cap_color(5,:);
p3.EdgeColor=cap_color(5,:);
p3.FaceAlpha = 0;
end

ymin(k) = min(X)-(max(X)-min(X))*0.1;
ymax(k) = max(X) +(max(X)-min(X))*0.1;

% % (method without binning)
% 
% delta=0.0075;
% 
% for i=1:length(X)
% xpatch=[X(i)-delta,X(i)-delta,X(i)+delta,X(i)+delta];
% y1patch=[0,Y(i,6),Y(i,6),0];
% y2patch=[0,Y(i,5),Y(i,5),0];
% y3patch=[0,-Y(i,5),-Y(i,5),0];
% p1=patch('XData',xpatch,'YData',y1patch);
% p2=patch('XData',xpatch,'YData',y2patch);
% p3=patch('XData',xpatch,'YData',y3patch);
% p1.EdgeColor=cap_color(6,:);
% p1.FaceColor=cap_color(6,:);
% p2.EdgeColor=cap_color(5,:);
% p2.FaceColor=cap_color(5,:);
% p3.EdgeColor=cap_color(5,:);
% p3.FaceAlpha = 0;
% end

a=p1.Parent;

plot_settings(a,'Costs and Benefits')

%a.XLabel.String='HDI';
%a.XTick=X;
%a.XTickLabels=string(X);
XLim=a.XLim;
a.XLim=[ymin(k) ymax(k)];
a.XAxis.TickLength=[0.01 0];
a.TickDir='both';

%% plots for optimal transport in HDI and GII

Z=[];

[X,Y2,Z(:,:,3)]=aggre2(S(k).data.HDI,S(k).data.GII,S(k).data.NB);
[~,~,Z(:,:,4)]=aggre2(S(k).data.HDI,S(k).data.GII,S(k).data.NC);
[~,~,Z(:,:,5)]=aggre2(S(k).data.HDI,S(k).data.GII,S(k).data.SB);
[~,~,Z(:,:,6)]=aggre2(S(k).data.HDI,S(k).data.GII,S(k).data.SC);
Y1=-Y2;

Z(:,:,[1,2,7])=0;

g(k)=figure;
hold on
set(gcf,'Renderer','painters');
xmax2(k) = max(X)+ (max(X)-min(X))*0.1;
xmin2(k) = min(X)- (max(X)-min(X))*0.1;
ymax2(k) = max(Y2)+ (max(Y2)-min(Y2))*0.1;
ymin2(k) = -ymax2(k);

%make a histogram by discretizing HDI and GII scale
bins=100;
F=-1:(2/bins):1;  % 100 bins form -1 to 1
% Xid = discretize(X,E);
% XEid=unique(Xid);
% YE=zeros(size(E,2),size(Y,2));
Y2id = discretize(Y2,F);
Y2Fid=unique(Y2id);
ZEF=zeros(size(E,2),size(F,2),size(Z,3));
for i=1:length(X)
    for j=1:length(Y2)
        ZEF(Xid(i),bins+1-Y2id(j),3) = ZEF(Xid(i),bins+1-Y2id(j),3) + Z(i,j,3); %histogram of Z natural benefits (GII-)
        ZEF(Xid(i),bins+1-Y2id(j),5) = ZEF(Xid(i),bins+1-Y2id(j),5) + Z(i,j,5); %histogram of Z social benefits (GII-)
        ZEF(Xid(i),Y2id(j),4) = ZEF(Xid(i),Y2id(j),4) + Z(i,j,4); %histogram of Z natural costs (GII+)
        ZEF(Xid(i),Y2id(j),6) = ZEF(Xid(i),Y2id(j),6) + Z(i,j,6); %histogram of Z social costs (GII+)
    end
end
%plot
for i=1:length(XEid)
    for j=1:length(Y2Fid)
        xp=repmat([E(XEid(i)),E(XEid(i)+1),E(XEid(i)+1),E(XEid(i))],1,2);
        y1p=repmat([F(bins+1-Y2Fid(j)),F(bins+1-Y2Fid(j)),F(bins+1-Y2Fid(j)+1),F(bins+1-Y2Fid(j)+1)],1,2);
        y2p=repmat([F(Y2Fid(j)),F(Y2Fid(j)),F(Y2Fid(j)+1),F(Y2Fid(j)+1)],1,2);
        fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
        if ~(ZEF(XEid(i),Y2Fid(j),6)==0 && ZEF(XEid(i),Y2Fid(j),4)==0)
            z1np=ZEF(XEid(i),Y2Fid(j),4)*[0,0,0,0,1,1,1,1]; % nat costs
            z1sp=ZEF(XEid(i),Y2Fid(j),4)*[1,1,1,1,1,1,1,1]+ ZEF(XEid(i),Y2Fid(j),6)*[0,0,0,0,1,1,1,1]; % add on soc costs           
            vert1n = [xp',y2p',z1np'];
            vert1s = [xp',y2p',z1sp'];
            p1n=patch('Vertices',vert1n,'Faces',fac,'FaceColor','flat');
            p1n.EdgeColor='black';
            p1n.FaceColor=cap_color(4,:);
            p1s=patch('Vertices',vert1s,'Faces',fac,'FaceColor','flat');
            p1s.EdgeColor='black';
            p1s.FaceColor=cap_color(6,:);
        end
        if ~(ZEF(XEid(i),bins+1-Y2Fid(j),5)==0 && ZEF(XEid(i),bins+1-Y2Fid(j),3)==0)
            z2np=ZEF(XEid(i),bins+1-Y2Fid(j),3)*[0,0,0,0,1,1,1,1]; % nat benefits
            z2sp=ZEF(XEid(i),bins+1-Y2Fid(j),3)*[1,1,1,1,1,1,1,1] + ZEF(XEid(i),bins+1-Y2Fid(j),5)*[0,0,0,0,1,1,1,1]; % add on soc benefits          
            vert2n = [xp',y1p',z2np'];
            vert2s = [xp',y1p',z2sp'];
            vert3n = [xp',y1p',-z2np'];
            vert3s = [xp',y1p',-z2sp'];
            p2n=patch('Vertices',vert2n,'Faces',fac,'FaceColor','flat');
            p2n.EdgeColor='black';
            p2n.FaceColor=cap_color(3,:);
            p2s=patch('Vertices',vert2s,'Faces',fac,'FaceColor','flat');
            p2s.EdgeColor='black';
            p2s.FaceColor=cap_color(5,:);
            p3n=patch('Vertices',vert3n,'Faces',fac,'FaceColor','flat');
            p3n.EdgeColor=cap_color(3,:);
            p3n.FaceColor=cap_color(3,:);
            p3n.FaceAlpha = 0;
            p3n.EdgeAlpha=0.5;
            p3n.LineWidth=0.25;
            p3s=patch('Vertices',vert3s,'Faces',fac,'FaceColor','flat');
            p3s.EdgeColor=cap_color(5,:);
            p3s.FaceColor=cap_color(5,:);
            p3s.FaceAlpha = 0;
            p3s.EdgeAlpha=0.5;
            p3s.LineWidth=0.25;
        end
    end
    Ysub=0;
    Ysup=0;
    if any(ZEF(XEid(i),:,3)+ZEF(XEid(i),:,5)>0) %if there any benefits, extend line below Y=0
        lowF = find(ZEF(XEid(i),:,3)+ZEF(XEid(i),:,5)>0,1);
        Ysub = F(lowF+1);
    end
    if any(ZEF(XEid(i),:,4)+ZEF(XEid(i),:,6)<0) %if there any costs, extend line above Y=0
        hiF = find(ZEF(XEid(i),:,4)+ZEF(XEid(i),:,6)<0,1,'last');
        Ysup = F(hiF);
    end
    line(0.5*[E(XEid(i))+E(XEid(i)+1),E(XEid(i))+E(XEid(i)+1)],[Ysub,Ysup],[0 0],'LineStyle','-','LineWidth',1,'Color',[0.75,0.75,0.75],'XLimInclude','off',...
        'YLimInclude','off','ZLimInclude','off')
end

h(k)=figure;

%plot just social
for i=1:length(XEid)
    for j=1:length(Y2Fid)
        xp=repmat([E(XEid(i)),E(XEid(i)+1),E(XEid(i)+1),E(XEid(i))],1,2);
        y1p=repmat([F(bins+1-Y2Fid(j)),F(bins+1-Y2Fid(j)),F(bins+1-Y2Fid(j)+1),F(bins+1-Y2Fid(j)+1)],1,2);
        y2p=repmat([F(Y2Fid(j)),F(Y2Fid(j)),F(Y2Fid(j)+1),F(Y2Fid(j)+1)],1,2);
        fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
        if ~(ZEF(XEid(i),Y2Fid(j),6)==0)
            %z1np=ZEF(XEid(i),Y2Fid(j),4)*[0,0,0,0,1,1,1,1]; % nat costs
            z1sp=ZEF(XEid(i),Y2Fid(j),6)*[0,0,0,0,1,1,1,1]; % add on soc costs           
            %vert1n = [xp',y2p',z1np'];
            vert1s = [xp',y2p',z1sp'];
            %p1n=patch('Vertices',vert1n,'Faces',fac,'FaceColor','flat');
            %p1n.EdgeColor='black';
            %p1n.FaceColor=cap_color(4,:);
            p1s=patch('Vertices',vert1s,'Faces',fac,'FaceColor','flat');
            p1s.EdgeColor='black';
            p1s.FaceColor=cap_color(6,:);
        end
        if ~(ZEF(XEid(i),bins+1-Y2Fid(j),5)==0)
            %z2np=ZEF(XEid(i),bins+1-Y2Fid(j),3)*[0,0,0,0,1,1,1,1]; % nat benefits
            z2sp=ZEF(XEid(i),bins+1-Y2Fid(j),5)*[0,0,0,0,1,1,1,1]; % add on soc benefits          
            %vert2n = [xp',y1p',z2np'];
            vert2s = [xp',y1p',z2sp'];
            %vert3n = [xp',y1p',-z2np'];
            vert3s = [xp',y1p',-z2sp'];
            %p2n=patch('Vertices',vert2n,'Faces',fac,'FaceColor','flat');
            %p2n.EdgeColor='black';
            %p2n.FaceColor=cap_color(3,:);
            p2s=patch('Vertices',vert2s,'Faces',fac,'FaceColor','flat');
            p2s.EdgeColor='black';
            p2s.FaceColor=cap_color(5,:);
            %p3n=patch('Vertices',vert3n,'Faces',fac,'FaceColor','flat');
            %p3n.EdgeColor=cap_color(3,:);
            %p3n.FaceColor=cap_color(3,:);
            %p3n.FaceAlpha = 0;
            %p3n.EdgeAlpha=0.5;
            %p3n.LineWidth=0.25;
            p3s=patch('Vertices',vert3s,'Faces',fac,'FaceColor','flat');
            p3s.EdgeColor=cap_color(5,:);
            p3s.FaceColor=cap_color(5,:);
            p3s.FaceAlpha = 0;
            p3s.EdgeAlpha=0.5;
            p3s.LineWidth=0.25;
        end
    end
    Ysub=0;
    Ysup=0;
    if any(ZEF(XEid(i),:,5)>0) %if there any benefits, extend line below Y=0
        lowF = find(ZEF(XEid(i),:,5)>0,1);
        Ysub = F(lowF+1);
    end
    if any(ZEF(XEid(i),:,6)<0) %if there any costs, extend line above Y=0
        hiF = find(ZEF(XEid(i),:,6)<0,1,'last');
        Ysup = F(hiF);
    end
    line(0.5*[E(XEid(i))+E(XEid(i)+1),E(XEid(i))+E(XEid(i)+1)],[Ysub,Ysup],[0 0],'LineStyle','-','LineWidth',1,'Color',[0.75,0.75,0.75],'XLimInclude','off',...
        'YLimInclude','off','ZLimInclude','off')
end

% old method without binning
%
% for i=1:length(X)
%     for j=1:length(Y)
%         xp=repmat([X(i)-delta,X(i)+delta,X(i)+delta,X(i)-delta],1,2);
%         y1p=repmat([Y(j)-delta,Y(j)-delta,Y(j)+delta,Y(j)+delta],1,2);
%         y2p=repmat([-Y(j)-delta,-Y(j)-delta,-Y(j)+delta,-Y(j)+delta],1,2);
%         fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
%         if ~(Z(i,j,6)==0)
%             z1p=[0,0,0,0,Z(i,j,6),Z(i,j,6), Z(i,j,6),Z(i,j,6)]; %costs
%             vert1 = [xp',y1p',z1p'];
%             p1=patch('Vertices',vert1,'Faces',fac,'FaceColor','flat');
%             p1.EdgeColor='black';
%             p1.FaceColor=cap_color(5,:);
%         end
%         if ~(Z(i,j,5)==0)
%             z2p=[0,0,0,0,Z(i,j,5),Z(i,j,5), Z(i,j,5),Z(i,j,5)]; %benefits
%             z3p=[0,0,0,0,-Z(i,j,5),-Z(i,j,5),-Z(i,j,5),-Z(i,j,5)]; %benefits
%             vert2 = [xp',y2p',z2p'];
%             vert3 = [xp',y2p',z3p'];
%             p2=patch('Vertices',vert2,'Faces',fac,'FaceColor','flat');
%             p3=patch('Vertices',vert3,'Faces',fac,'FaceColor','flat');
%             p2.EdgeColor='black';
%             p2.FaceColor=cap_color(6,:);
%             p3.EdgeColor=cap_color(6,:);
%             p3.FaceColor=cap_color(6,:);
%             p3.FaceAlpha = 0;
%             p3.EdgeAlpha=0.5;
%             p3.LineWidth=0.25;
%         end
%     end
%     Ysub=0;
%     Ysup=0;
%     if any(Z(i,:,5)>0)
%         Ysub = -max(Y(Z(i,:,5)>0));
%     end
%     if any(Z(i,:,6)<0)
%         Ysup = max(Y(Z(i,:,6)<0));
%     end  
%     line([X(i),X(i)],[Ysub,Ysup],[0 0],'LineStyle',':','LineWidth',1,'Color',[0.75,0.75,0.75],'XLimInclude','off',...
%         'YLimInclude','off','ZLimInclude','off')
% end

a=p1n.Parent;

plot3_settings(a,'')

a.XLabel.String='';
a.YLabel.String='';
set(a.Parent,'Position',[482,60,833,924]);
a.View=[-54.6195035808013 20.0334666176277];
a.YTickLabelRotation=30;
a.XTickLabelRotation=-15;

a=p1s.Parent;

plot3_settings(a,'')

a.XLabel.String='';
a.YLabel.String='';
set(a.Parent,'Position',[482,60,833,924]);
a.View=[-54.6195035808013 20.0334666176277];
a.YTickLabelRotation=30;
a.XTickLabelRotation=-15;

%% calculate SES

p=-(YE(XEid,4) + YE(XEid,6)); %natural and social captial COST distribution
q=YE(XEid,3) + YE(XEid,5); %natural and social captial BENEFIT distribution
[i,j]=meshgrid(1:length(E));
cost=E(i)-E(j); %signed cost, p COSTS must be the first entry in optimal transport function
C1=cost(XEid,XEid);
[SES(k),~] = optimal_transport(p,q,C1);

%% calculate SES-G

% convert the histograms of 2-dimensions to 1-dimension
YFid=sort([bins-Y2Fid+1;Y2Fid]);

P=-(ZEF(XEid,YFid,4)+ZEF(XEid,YFid,6)); %2-dimensional histogram of COSTS
Q=ZEF(XEid,YFid,3)+ZEF(XEid,YFid,5); %2-dimensional histogram of BENEFITS

p=P(:);
q=Q(:);

N= length(XEid)*length(YFid);

C2 = zeros(N);
%convert cost function
for m=1:N
    [im,jm]=ind2sub([length(XEid),length(YFid)],m);
    for n=1:N
        [in,jn]=ind2sub([length(XEid),length(YFid)],n);
        C2(m,n)=E(XEid(in)) - E(XEid(im)) + abs(F(YFid(jn)) - F(YFid(jm))); %SES-G   
        %C2(m,n)=E(XEid(in)) - E(XEid(im)); %test SES
    end 
end

[SESG(k),~] = optimal_transport(p,q,C2);

end

%adjust limits for comparable histograms

yminn=min(ymin);
ymaxn=max(ymax);
xminn2=min(xmin2);
xmaxx2=max(xmax2);
ymaxx2=max(ymax2);

for k=1:ncomps
    a=findobj(f(k), 'type', 'axes', '-not', 'tag', 'legend', '-not', 'tag', 'Colorbar');
    rxmn=floor(yminn*20)/20;
    rxmx=ceil(ymaxn*20)/20;
    rxg = (rxmx - rxmn)/5;
    a.XTick = rxmn:rxg:rxmx;
    a.XLim=[rxmn,rxmx];
    
    a=findobj(g(k), 'type', 'axes', '-not', 'tag', 'legend', '-not', 'tag', 'Colorbar');
    rxmn=floor(xminn2*20)/20;
    rxmx=ceil(xmaxx2*20)/20;
    rxg = (rxmx - rxmn)/5;
    rymx=ceil(ymaxx2*20)/20;
    rymn=-rymx;
    ryg = rymx/5;
    a.XTick = rxmn:rxg:rxmx;
    a.YTick = rymn:ryg:rymx;
    a.XLim=[rxmn,rxmx];
    a.YLim=[rymn,rymx];
    
    a=findobj(h(k), 'type', 'axes', '-not', 'tag', 'legend', '-not', 'tag', 'Colorbar');
    a.XTick = rxmn:rxg:rxmx;
    a.YTick = rymn:ryg:rymx;
    a.XLim=[rxmn,rxmx];
    a.YLim=[rymn,rymx];
end


%% subfunctions

    function [X,Y]=aggre(Xdata,Ydata)
    
    X = unique(Xdata);
    Y=zeros(size(X));
    
    for i=1:length(X)
        idx = Xdata==X(i);
        Y(i) = sum(Ydata(idx));    
    end
    
    end
    
    function [X,Y,Z]=aggre2(Xdata,Ydata,Zdata)
    
    [X,~]=aggre(Xdata,Zdata); %unique X = HDI values
    [Y,~]=aggre(Ydata,Zdata); %unique Y = GII values
    
    Z=zeros(length(X),length(Y));
    
    for i=1:length(X)
        for j=1:length(Y)
            idx= Xdata==X(i);
            idy= Ydata==Y(j);
            id=idx & idy; % entries in ZData with the same HDI and GII
            Z(i,j) = sum(Zdata(id));
        end
    end
    
    end

    function plot_settings(ax,str)

    ax.Color='white';
    ax.Parent.Color='white';
    ax.FontSize=10;
    ax.Box='off';
    ax.TickLength=[0 0];
    ax.YGrid='on';
    ax.YMinorGrid='on';
    ax.XAxisLocation='origin';
    ax.YAxisLocation='origin';
    ax.YLabel.String=str;
    ax.YLabel.FontSize=10;
    ax.YLabel.HorizontalAlignment='center';
    ax.YLabel.Rotation=90;
    ax.YLabel.Units='normalized';
    ax.YLabel.Position=[-0.05 0.5];
    ax.YTickLabels=[];

    end
    
    function plot3_settings(ax,str)

    ax.Color='white';
    ax.Parent.Color='white';
    ax.FontSize=10;
    ax.Box='off';
    ax.TickLength=[0.02 0.025];
    
    ax.XRuler.FirstCrossoverValue  = 0; % X crossover with Y axis
    ax.XRuler.SecondCrossoverValue  = 0; % X crossover with Y axis
    ax.YRuler.FirstCrossoverValue  = 0; % Y crossover with X axis
    ax.YRuler.SecondCrossoverValue  = 0; % X crossover with Y axis
    ax.ZRuler.FirstCrossoverValue  = 0; % Z crossover with X axis
    ax.ZRuler.SecondCrossoverValue = ax.YTick(1); % Z crossover with Y axis
    ax.YGrid='off';   
    ax.ZGrid='off';
    ax.ZLabel.String=str;
    ax.ZLabel.FontSize=10;
    ax.ZLabel.HorizontalAlignment='center';
    end

    function bnew=split_bar(b,s)
    
    x0 = b.XData(1:(s*6),:);
    y0 = b.YData(1:(s*6),:);
    z0 = b.ZData(1:(s*6),:);
    xb = b.XData((s*6+1):end,:);
    yb = b.YData((s*6+1):end,:);
    zb = b.ZData((s*6+1):end,:);
   
    idx0 = [0;find(all(isnan(x0),2))];
    idxb = [0;find(all(isnan(xb),2))];
    
    bnew=surface;
    
    for ii = 1:length(idx0)-1
        bnew=[bnew surface(x0(idx0(ii)+1:idx0(ii+1)-1,:),...
                         y0(idx0(ii)+1:idx0(ii+1)-1,:),...
                         z0(idx0(ii)+1:idx0(ii+1)-1,:),...
                         'FaceColor',b.FaceColor,'FaceAlpha',0.3,'EdgeAlpha',0.3,'AlignVertexCenters','on')];
    end
    
    for ii = 1:length(idxb)-1
        bnew=[bnew surface(xb(idxb(ii)+1:idxb(ii+1)-1,:),...
                         yb(idxb(ii)+1:idxb(ii+1)-1,:),...
                         zb(idxb(ii)+1:idxb(ii+1)-1,:),...
                         'FaceColor',b.FaceColor,'FaceAlpha',1,'AlignVertexCenters','on')];
    end
    
    delete(bnew(1))
    bnew(1)=[];
    
    end
    
    function [ot,pi] = optimal_transport(p,q,cost)
    %
    % p a positive histogram on R with N bins (N x 1 column vector)    
    % q a positive histogram on R with N bins (N x 1 column vector)
    % cost = NxN matrix specifying cost to move unit mass from bin n to bin m
    % p and q have the same total mass 
    %
    % Optimal transport using Sinkhorn-Knopp (thank to Dirk at
    % https://regularize.wordpress.com/2015/09/17/calculating-transport-plans-with-sinkhorn-knopp/)

    N=length(p);
    
    %solving dual problem for transformation matrix pi
    
    D=cost';
    f=D(:);  %turn \sum_{ij} c_{ij} pi_{ij} = \sum_{ij} c_{ij}' pi_{ij}'  into a linear problem (solution x is pi'(:))

    A1=blkdiagrep1(ones(1,N)); %constraint pi * ones(N,1) \leq p is equivalent to blkdiag(ones(1,N)) * pi'(:) \leq p
    A2=blkdiagrep2(ones(1,N)); %constraint pi' * ones(N,1) \geq q is equivalent to repmat(eyes(N),[1,N]) * pi'(:) \geq q
  
    A=[A1;-A2];
    b=[p;-q];
    lb = zeros(size(f));
    
    %solve
    
    x=linprog(f,A,b,[],[],lb,[]);
    
    %optimal transformation
    pi = reshape(x,size(cost))';
    
    %optimal cost
    ot = f'*x;
       
        function A=blkdiagrep1(y)
           %modify blockdiag for a repeat
           n=length(y);
           A=zeros(n,n*n);
           for j=1:n
              A(j,((j-1)*n+1):j*n)=y;
           end
        end
    
        function A=blkdiagrep2(y)
           %modify blockdiag for a repeat
           n=length(y);
           A=repmat(diag(y),[1,n]);
        end
    
    end
    
