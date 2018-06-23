classdef fermions
    %FERMIONS Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(GetAccess = public, SetAccess = private)
       X = [];
       Y = [];
       N;
       PHIs = [];
       outof = [0 0];
    end
    
    methods
        function obj = fermions(amount, dio)
            % draft
            obj.N = amount;
            %obj.X = zeros(1, amount);
            obj.Y = zeros(1, amount);
            obj.PHIs = 2 * pi * rand(1, amount);
            %[lenL, lenR]= dio.LengthD();
            Nl = round(dio.XlengthL / (dio.XlengthL + dio.XlengthR) * amount);
            iX = [(-dio.XlengthL * rand(1, Nl)) (dio.XlengthR * rand(1, amount - Nl))];
            obj.X = iX(randperm(amount));
            %obj.PHIs = pi/4 * rand(1, amount);
        end
        function fe = drawFeAx(obj, axes)
            fe = plot(obj.X, obj.Y,'ko','markersize',1, 'parent', axes);
        end
        function outs = whosOUT(obj, dio)
           outs = dio.AllDrops(obj.X, obj.Y);
        end
        function obj = StepDio(obj, r, dio, shift)
            iX = obj.X + r .* cos(obj.PHIs) + shift * ones(1, obj.N);
            iY = obj.Y + r .* sin(obj.PHIs);
            obj.outof = [(sum(iX < -dio.XlengthL)) (sum(iX > dio.XlengthR))];
            [outsl, outsX, outsY, outsCo, outsR] = dio.DropsSpec1(iX, iY, obj);
            obj.X(~outsl) = iX(~outsl);
            obj.Y(~outsl) = iY(~outsl);
            outs = find(outsl);
            %% section on angles
            PHI = obj.PHIs;
            PHI(outs(outsX)) = pi - obj.PHIs(outs(outsX));
            PHI(outs(outsR)) = pi - obj.PHIs(outs(outsR));
            PHI(outs(outsY)) = -obj.PHIs(outs(outsY));
            
            outsC = outs(outsCo);
            ups = obj.Y(outsC) > 0;
            PHI(outsC(ups)) = 2 * dio.coneAng(1,2) - obj.PHIs(outsC(ups)); 
            PHI(outsC(~ups)) = 2 * dio.coneAng(1,1) - obj.PHIs(outsC(~ups)); 
            
            obj.PHIs = PHI;
        end
        function obj = angleRot(obj)
            direct = [ones(1, floor(obj.N/2)) zeros(1, ceil(obj.N/2))];
            obj.PHIs = (pi * direct(randperm(obj.N))) + ((pi / 2) * ones(1, obj.N) - pi * rand(1, obj.N));
            %obj.PHIs = 2 * pi * rand(1, obj.N);
        end
    end
    
end

