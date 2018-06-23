classdef ArrowShapedDio
    %ARROWSHAPEDDIO contour of a simple arrowshaped dio
    %   All coordinates of corners are predifined.
    % methodology: So, one creates an object of this class. There are 3 
    % important, in particular, areas: right rectangle, left rectangle and cone
    % area. Basically if particles travels around the area of a diode it
    % alright. Once it comes to diode's edge, we're concerned about keeping it
    % inside, reflecting it properly off an edge
    
    properties(GetAccess = public, SetAccess = private)
        coneAng;
        neck = 0.1;
        XlengthL = 1.23;
        XlengthR = 0.5;
    end
    
    properties(Access = private)
        Boundary = [];
        RightPart = [];
        ConePart = [];
        LeftRectangle = [];
        Lwidth = 1.1;
        Rwidth = 1.1;
        cone = 1;
    end
    
    methods
        function obj = ArrowShapedDio()
            % Constructor. Constructs arrays of certain areas of adiode and
            % defines an angle of a cone part.
           obj.Boundary =  [-obj.XlengthL -obj.XlengthL -obj.cone 0 0 obj.XlengthR obj.XlengthR 0 0 -obj.cone -obj.XlengthL;...
               obj.Lwidth -obj.Lwidth -obj.Lwidth -obj.neck/2 -obj.Rwidth -obj.Rwidth obj.Rwidth obj.Rwidth obj.neck/2 obj.Lwidth obj.Lwidth];
           obj.ConePart = [-obj.cone 0 0 -obj.cone -obj.cone;...
               -obj.Lwidth -obj.neck/2 obj.neck/2 obj.Lwidth -obj.Lwidth];
           obj.LeftRectangle = [-obj.XlengthL -obj.cone -obj.cone -obj.XlengthL -obj.XlengthL;...
               -obj.Lwidth -obj.Lwidth obj.Lwidth obj.Lwidth -obj.Lwidth];
           obj.RightPart = [0 obj.XlengthR obj.XlengthR 0 0;...
               -obj.Rwidth -obj.Rwidth obj.Rwidth obj.Rwidth -obj.Rwidth];
           obj.coneAng = [(atan((obj.Lwidth - obj.neck / 2) / obj.cone)) (pi - atan((obj.Lwidth - obj.neck / 2) / obj.cone))];
        end
        function S = DrawDio(obj)
            S = plot(obj.Boundary(1,:), obj.Boundary(2,:));
        end
        function S = DrawDioAx(obj, axes)
            S = plot(obj.Boundary(1,:), obj.Boundary(2,:),'parent', axes,'color','blue');
        end
        function outs = AllDrops(obj, X, Y)
            in = inpolygon(X,Y,obj.Boundary(1,:), obj.Boundary(2,:));
            outs = ~in;
        end
        function outs = LeftDrops(obj, X, Y)
            in = inpolygon(X,Y,obj.LeftPart(1,:), obj.LeftPart(2,:));
            outs = find(~in);
        end
        function outs = RightDrops(obj, X, Y)
            in = inpolygon(X,Y,obj.RightPart(1,:), obj.RightPart(2,:));
            outs = find(~in);
        end
        function f = fillDemo(obj, ax)         
          f = fill(obj.Boundary(1,:), obj.Boundary(2,:),[0.3 0.3 0.3],'parent',ax);
          axis(ax, [-1.5 1.5 -1.5 1.5]);              
        end
        function [outs, outsX, outsY, outsCo, outsR] = DropsSpec1(obj, X, Y, fe)
            outs = obj.AllDrops(X, Y);
            epsi = 10^-15;
            outsX = (X(outs) < -obj.XlengthL | X(outs) > obj.XlengthR);
            outsY = (abs(Y(outs)) > obj.Lwidth | abs(Y(outs)) > obj.Rwidth);
            outsCo = (X(outs) > -obj.cone & X(outs) < 0) & (fe.X(outs) < -epsi);
            outsR = (X(outs) < 0) & (fe.X(outs) >= -epsi);
        end
        function A = Area(obj)
            A = polyarea(obj.Boundary(1,:), obj.Boundary(2,:)) / 10 ^ 8; % cm squared;
        end
    end   
end

