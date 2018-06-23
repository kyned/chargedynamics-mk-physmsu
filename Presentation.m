ass_ = arrayRes;
vlt_ = Voltage;
% ass_ = arrayRes(:,2:length(Voltage)-1);
% vlt_ = Voltage(2:length(Voltage)-1);

ass_(:,floor(length(vlt_) / 2) + 1) = zeros(length(ass_),1);

% Voltage = -Voltage;
figX = figure('Position',[250 100 1100 500]);
BOX1 = axes('Parent', figX, 'Units','pixels' ,'Position', [0 0 500 500],'color',[1 1 1]);
BOX2 = axes('Parent', figX, 'Units','pixels' ,'Position', [600 50 450 400],'color',[1 1 1]);
fillDemo(dio, BOX1);
axis equal
errorbar(-vlt_, mean(ass_), std(ass_),'parent',BOX2);
grid on
xlabel('Напряжение, В') % x-axis label
ylabel('Ток, A') % y-axis label