classdef Bullet < GameObject
   
    properties (SetAccess = public)
       lifeTicks; % how many ticks are left in its life
       theta;
       owner=[];
       sp;
    end
    
    properties (Constant)
       BULLET_LIFE = 100; % number of ticks bullet exists
       BULLET_SPEED = 90; % how much faster than you the bullets fly [pix/tick]
    end
     
    methods
        function B = Bullet(theta,owner)
            B.theta=theta;
            B.owner=owner;
            B.type = GameObject.TYPE_BULLET;
            B.sp=B.pos;
            B.mesh =5*[-2,2,2.8,2,-2,-2;...
        0,0,1,2,2,0];
            B.collisionRadius = 3;
            
            B.lifeTicks = Bullet.BULLET_LIFE;
            
        end
        function Update( B, FIGURE_WIDTH, FIGURE_HEIGHT )
            
            % move the state forward
            
            B.pos(1) = B.pos(1) + 5;
            eval=B.pos-B.sp;
            B.pos(2) = Traj(B,eval(1))+B.sp(2);
            %B.rot=theta;
            %B.rot = atan(B.pos(2)/B.pos(2));
            B.rot=-atan((Traj(B,eval(1)+0.5)-Traj(B,eval(1)))/(0.5));
            % looparound effect
            if B.pos(1) < 0
                B.destroyAtLoopEnd=true;
            end
            if B.pos(1) > FIGURE_WIDTH
                B.destroyAtLoopEnd=true;
            end
            if B.pos(2) < 0
                B.destroyAtLoopEnd=true;
            end
            if B.pos(2) > FIGURE_HEIGHT
                B.destroyAtLoopEnd=true;
            end
            
            % set the visual
            c = cos(B.rot);
            s = sin(B.rot);
            R = [c,s;-s,c];
            rotMesh = R*B.mesh;
            newPos = [rotMesh(1,:) + B.pos(1); rotMesh(2,:) + B.pos(2) ];
            set(B.visual, 'XData', newPos(1,:), 'YData', newPos(2,:));
            
            % life count
            B.lifeTicks = B.lifeTicks - 1;
            if B.lifeTicks <= 0
                B.destroyAtLoopEnd = true;
            end
            
        end
        function OnCollidesWith( B, target )
            % destroy if it didn't hit a bullet
            if target.type ~= GameObject.TYPE_BULLET
                B.destroyAtLoopEnd = true;
            end
        end
        function val=Traj(B,x)
			val=x*tan(B.theta)-B.GRAVITY*x*x/((norm(B.vel)^2) *(cos(B.theta)^2) *2);
		end
    end % methods
end % classdef