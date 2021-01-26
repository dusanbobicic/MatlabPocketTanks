classdef Tank < GameObject
    properties (SetAccess = public)
        FIGURE_WIDTH = 800; % [pix]
FIGURE_HEIGHT = 600; % [pix]
        fired;
        isThrusting; % whether the thrusting animation should be shown
        main;
        face;
        plyr;
    end
    methods
        function T = Tank( main,plyr)
            T.plyr=plyr;
            T.type = GameObject.TYPE_PLAYER;
            T.mesh = [0,20,32,32,20,12,12,40,40,12,12,-4,-4,-20,-32,-32,-20,0;...
        0, 0, 4, 12, 16, 16,18,18,20,20,24,24,16,16,12,4,0,0];
            T.collisionRadius = 40;
            T.main = main;
            T.face=1;
            T.fired = false;
                      
        end
        function Update( T, FIGURE_WIDTH, FIGURE_HEIGHT )
            
            % move the state forward
            %T.pos = T.pos + T.vel;
            % set the ship visual
            newPos = [T.mesh(1,:) + T.pos(1); T.mesh(2,:) + T.pos(2) ];
            set(T.visual, 'XData', newPos(1,:), 'YData', newPos(2,:));
        end
        function Cleanup( T )
            Cleanup@GameObject( T );
        end
        function ResetGun( T )
            T.fired = false;
        end
        function OnCollidesWith( T, target )
             if target.type == GameObject.TYPE_BULLET
                 if(~(target.owner==T))
                 if(T.plyr)
                tankText = text( T.FIGURE_WIDTH / 2, T.FIGURE_HEIGHT * 0.75, 'GAME OVER', ...
                'FontSize', 50, 'Color', 'w', 'HorizontalAlignment', 'Center' );
                 else
                      tankText = text( T.FIGURE_WIDTH / 2, T.FIGURE_HEIGHT * 0.75, 'SRECNI PRAZNICI', ...
                'FontSize', 50, 'Color', 'w', 'HorizontalAlignment', 'Center' );
                 end
                 
                 T.main.SpawnExplosion(T.pos);
                 T.main.PlaySound('bang.wav');
                 
                 T.destroyAtLoopEnd = true;
                 end
             end
        end
    end %methods
end %classdef
