function  dioMotion
%DIOMOTION Summary of this function goes here
%   Detailed explanation goes here
global N dio timeStep fig BOX0
global shift DoThatVar H           MFP fe 
DoThatVar = 1;
shift = 0;
close(fig);
stepsStab = 2000;
CreateArrayRes();
dio = ArrowShapedDio();
fe = fermions(N, dio);
MFP = 0.2;
timeStep = MFP / 10 ^ 12;
H = waitbar(0, 'Wait (Stabilisation)...');
for ind = 1:stepsStab
    % ~Stabilisation
   fe = FewStepsOne(fe, dio, MFP); 
   waitbar(ind / stepsStab, H);
end
% figX = figure('Position',[250 100 500 500]);
% BOX0 = axes('Parent', figX, 'Units','pixels' ,'Position', [0 0 500 500],'color',[1 1 1]);
while DoThatVar
     fe = FewStepsTwo(fe, dio, MFP);
end
end

function CreateArrayRes()
global arrayRes Voltage
global cells cols
global indCo indCe
cols = 21;
cells = 1000;
arrayRes = zeros(cells, cols);
indCo = 0;
indCe = cells + 1;
Voltage = -1.5:0.3:1.5;
Voltage = -Voltage; % Reversed start;
% Voltage = zeros(1,cols);
% for ind = 1:floor(cols / 2)
%     Voltage(ind) = 10 ^ -ind;
%     Voltage(cols + 1 - ind) = -Voltage(ind);
% end
end

function fe = FewStepsTwo(obj, dio, MFP)
    global shift BOX0
    %
%     shift = 0;
    %
    steps = 5;
    r = MFP / steps;
    sum = 0;
    for jay = 1:steps
       obj = obj.StepDio(r * (0.8*ones(1, obj.N) +  0.25*ones(1, obj.N).*rand(1, obj.N)), dio, shift / steps);
       sum = sum + obj.outof(1,2) - obj.outof(1,1);
%        p = drawFeAx(obj, BOX0);
%        hold on;
%        d = DrawDioAx(dio, BOX0);
%        pause(0.001);
%        delete(d);
%        delete(p);
    end
    ResultSaver(sum);
    obj = obj.angleRot();
    fe = obj;
end

function fe = FewStepsSt(obj, dio, MFP)
    global shift 
    steps = 5;
    r = MFP / steps;
    sum = 0;
    for jay = 1:steps
       obj = obj.StepDio(r * (0.8*ones(1, obj.N) +  0.25*ones(1, obj.N).*rand(1, obj.N)), dio, shift / steps);
       sum = sum + obj.outof(1,2) - obj.outof(1,1);

    end
    obj = obj.angleRot();
    fe = obj;
end

function fe = FewStepsOne(obj, dio, MFP)
    steps = 5;
    r = MFP / steps;
    for jay = 1:steps
       obj = obj.StepDio(r * rand(1, obj.N), dio, 0);
    end
    obj = obj.angleRot();
    fe = obj;
end

function ResultSaver(N)
global arrayRes timeStep H
global cells cols           MFP fe dio
global indCo indCe
elementaryCharge = -1.6 * 10 ^ -19;
if indCe <= cells
    arrayRes(indCe, indCo) = N * elementaryCharge / timeStep;
    indCe = indCe + 1;
    return;
else
    indCo = indCo + 1;
    waitbar((indCo - 1) / cols, H, 'Preparing results...'); % displayng progress;
    indCe = 1;
    if indCo > cols
        delete(H);
        SaveArray();
        return;
    end
    DriftManager(indCo);
    HB = waitbar(0, '(Stabilisation)...');
    for ind = 1:500
     fe = FewStepsSt(fe, dio, MFP);
     waitbar(ind / 500, HB)
    end
     close(HB);
     delete(HB);
end
end

function SaveArray()
global arrayRes DoThatVar
global dio Voltage
DoThatVar = 0;
figX = figure('Position',[250 100 1100 500]);
BOX1 = axes('Parent', figX, 'Units','pixels' ,'Position', [0 0 500 500],'color',[1 1 1]);
BOX2 = axes('Parent', figX, 'Units','pixels' ,'Position', [600 50 450 400],'color',[1 1 1]);
DrawDioAx(dio, BOX1);
axis equal
errorbar(-Voltage, mean(arrayRes), std(arrayRes),'parent',BOX2);
grid on
xlabel('Voltage, V') % x-axis label
ylabel('Current, A') % y-axis label
save nameMe arrayRes dio Voltage;
end

function DriftManager(index)
global shift Voltage timeStep dio
mobility = 0.5; % x10 000 cm^2/(V*s)
length = (dio.XlengthL + dio.XlengthR) * 10^(-6);
coefMicroM = 10 ^ 6;
shift = Voltage(index) * timeStep * mobility * coefMicroM / length ;
end
