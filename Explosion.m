classdef Explosion < GameObject
   
    properties (SetAccess = public)
       lifeTicks;
    end
    
    properties (Constant)
       LIFE_BASE = 50; % minimum number of ticks that the bullet survives before being destroyed
       LIFE_EXTRA = 150; % extra number of ticks that the bullet can survive before being destroyed
    end
    
    methods
        function boom = Explosion()
            
            boom.type = GameObject.TYPE_EXPLOSION;
            boom.lifeTicks = Explosion.LIFE_BASE + rand(1)*Explosion.LIFE_EXTRA;
            
            boom.mesh = 10*[2,3,1,0,-1,-3,-2,2;...
                0,3,2,4,2,3,0,0];
            boom.collisionRadius = -1;
            
        end
        function Update( boom, FIGURE_WIDTH, FIGURE_HEIGHT )
            newPos = [boom.mesh(1,:) + boom.pos(1); boom.mesh(2,:) + boom.pos(2) ];
            %boom.pos
            set(boom.visual, 'XData', newPos(1,:), 'YData', newPos(2,:));
            
            % decrement life
            boom.lifeTicks = boom.lifeTicks - 1;
            if boom.lifeTicks <= 0
                boom.destroyAtLoopEnd = true;
            end
            
        end
    end % methods
end % classdef