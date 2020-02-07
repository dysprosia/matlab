function fixfig(figNum)

%FIXFIG Modify display of figures
%
% This function modifies the display of standard figures.  It is based on
% a great MATLAB blog post by Loren Shure
% http://blogs.mathworks.com/loren/2007/12/11/making-pretty-graphs/
%
% Input (optional):
% figNum - Vector of figure numbers to process.  Will default to the
% current figure
%
% Usage:
% fixfig([1 2 4])
% This will apply the formatting to figures 1, 2 and 4
%

% D. Brown, ARL/PSU, dcb19@psu.edu
% C. Smith - Conversion from script to function form

if ~exist('figNum','var')
    figNum = gcf;
end

% Get the axes handles, legend handle, and the colorbar handle
h = findobj(figNum,'type','axes','-not','tag','legend','-not','tag','Colorbar');
%hLegend = findobj(figNum,'type','axes','-and','tag','legend');
hLegend = findobj(figNum,'tag','legend');
%hColorbar = findobj(figNum,'type','axes','-and','tag','Colorbar');
hColorbar = findobj(figNum,'tag','Colorbar');

% loop may be used to loop through subplot handles for these specific items
for n = 1:length(h)
   
    % set units of tick labels to normalized. adjusting fontsize here must
    % adjust starting point for normalization as a figure is resized
    set(h(n),'FontUnits','normalized','fontsize',0.06);
    set(get(h(n),'xlabel'),'FontUnits','normalized','fontsize',0.08,'interpreter','latex');
    set(get(h(n),'ylabel'),'FontUnits','normalized','fontsize',0.08,'interpreter','latex');
    set(get(h(n),'zlabel'),'FontUnits','normalized','fontsize',0.08,'interpreter','latex');
    set(get(h(n),'title'),'FontUnits','normalized','fontsize',0.08,'interpreter','latex');

end

% modify all handles at once in the case of a subplot
% set font name if not using latex as interpreter
%set(h, 'FontName','Helvetica');
set(h,...
    'Box','off', ...
    'TickDir','out',...
    'TickLength',[0.02 0.02],...
    'XMinorTick','on',...
    'YMinorTick','on',...
    'LineWidth',1,...
    'TickLabel','latex'); 

if ~isempty(hLegend)
    
    % seems to work better not setting a font size and simply using
    % normalized units
    set(hLegend,'FontUnits','normalized','interpreter','latex');
    %set(hLegend,'FontSize',12,'interpreter','latex');

    % set font name if not using latex as interpreter
    %set(hLegend, 'FontName','TimesNewRoman');
    
end

if ~isempty(hColorbar)
    
        % set font name if not using latex as interpreter
        %set(hColorbar,'FontName','Helvetica');
        
        % default 'Units' already set to normalized and 'FontSize' seems
        % close to xy tick labels size if we leave at default 
        set(hColorbar,'TickLabelInterpreter','latex','TickDir','out');
        
        hColorbarLabel=get(hColorbar,'YLabel');
        % set font name if not using latex as interpreter
        %set(hColorbarLabel,'FontName','Helvetica')
        set(hColorbarLabel,'interpreter','latex');
        set(hColorbarLabel,'FontUnits','normalized','FontSize',0.04);
end

% % 20160124:  Code added by D. Cook to provide upper and right-side of figure
% % box without tick marks.
% hold on
% 
% plot([1 1]*max(get(gca,'XLim')),get(gca,'YLim'),'k','LineWidth',1.0)  % Right side of box
% 
% % Adding the line to the top of the plot box depends on the direction of
% % the y-axis (that is, "axis xy" vs. "axis ij")
% switch upper(get(gca,'Ydir'))
%     case 'NORMAL'
%         plot(get(gca,'XLim'),[1 1]*max(get(gca,'YLim')),'k','LineWidth',1.0)  % Top of box
%     otherwise
%         plot(get(gca,'XLim'),[1 1]*min(get(gca,'YLim')),'k','LineWidth',1.0)  % Top of box
% end
