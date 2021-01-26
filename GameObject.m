classdef GameObject < matlab.mixin.Heterogeneous & handle
    properties (SetAccess = public)
        %BASIC
        type;
        destroyAtLoopEnd;
        %VISUAL
        mesh; %list of points [x;y] that defines 
        visual; %plot used to draw the object
        
        %STATE
        pos; % 2-element position vector [pix]
        vel; % 2-element velocity vector [pix/tick]
        rot; % 1-element rotation quantity (CCW positive) [rad]
        omg; % 1-element rotational velocity (CCW positive) [rad/tick]
        % COLLISION
       collisionRadius; % radius for the collision sphere [pix]
    end
    properties (Constant)
       TYPE_NONE = 0;
       TYPE_PLAYER = 2;
       TYPE_BULLET = 3;
       TYPE_EXPLOSION = 5;
       GRAVITY=10;
   end
    methods
        function GO = GameObject()
            
            GO.type = GameObject.TYPE_NONE;
            GO.destroyAtLoopEnd = false;
            
            GO.pos = [0; 0];
            GO.vel = [0; 0];
            GO.rot = 0;
            GO.omg = 0;
            
            GO.collisionRadius = 1.0;
            
            GO.visual = plot(NaN,NaN, '-w');
            GO.mesh = [];
            
        end
        function Cleanup( GO )
            delete(GO.visual);
        end
        function Update( GO, FIGURE_WIDTH, FIGURE_HEIGHT )
            % do nothing
        end
        function OnCollidesWith( GO, target )
            % do nothing
        end
        
    end %methods
end %classdef