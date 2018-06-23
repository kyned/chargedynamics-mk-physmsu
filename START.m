function START
global fig N
fig = figure();
N = 1000;
ar = get(fig,'Position');
uicontrol('style','pushbutton','Position',[80 60 (5 * ar(3) / 7) (2 * ar(4) / 7)],...
    'String','Start calculation', 'FontSize', 20,'CallBack','dioMotion');
end
