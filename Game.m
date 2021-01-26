classdef Game < handle
     properties (SetAccess = public)
        player = [];
        enemy=[];
        gameObjectList = [];
        explosionList=[];
        %sound
        y,Fs;
        sPlayer;
        %mousePosition
        mousePosition=[];
        %thetaMouse
        theta=1.57;
        % key presses
        pressedSPACE = false;
        
        %size
        fieldWidth; % [pix]
        fieldHeight; % [pix]
     end
     methods
    function obj = Game( figWidth, figHeight )
        obj.fieldWidth = figWidth;
        obj.fieldHeight = figHeight;
        %obj.velocityMessage = text( 100, figHeight - 30, '0', 'Color', 'w', 'FontSize', 30, 'FontWeight', 'light' );
        
        
        % ugly audio code. Matlab was definitely NOT meant for this
       
    end
    
    %MAIN GAME LOGIC
    function Update(obj)
        if obj.pressedSPACE
            obj.PlayerFireBullet();
       else
            obj.player.ResetGun();
        end
        
        for GO = obj.gameObjectList
            GO.Update( obj.fieldWidth, obj.fieldHeight );
        end
        for GO = obj.explosionList
            GO.Update( obj.fieldWidth, obj.fieldHeight );
        end
        i = 1;
        while i <= length(obj.gameObjectList)
            if obj.gameObjectList(i).destroyAtLoopEnd
                obj.gameObjectList(i).Cleanup();
                obj.gameObjectList = [obj.gameObjectList(1:i-1), obj.gameObjectList(i+1:end)];
            end
            i = i + 1;
        end
        while i <= length(obj.explosionList)
            if obj.explosionList(i).destroyAtLoopEnd
                obj.explosionList(i).Cleanup();
                obj.explosionList = [obj.explosionList(1:i-1), obj.explosionList(i+1:end)];
            end
            i = i + 1;
        end
        obj.CheckForCollisions();
    end
    
    %MISC LOGIC
    function Reset( obj )
        for GO = obj.gameObjectList
            delete(GO.visual);
        end
        obj.gameObjectList = [];
        if ~isempty(obj.player)
            obj.player.Cleanup();
            obj.player = [];
        end
        obj.SpawnPlayer( [100; 50] );
        obj.SpawnEmemy( [400; 50] );
        obj.pressedSPACE = false;      
    end
    
    
    function SpawnPlayer( obj, pos )
        obj.player = Tank( obj ,true);
        obj.player.pos = pos;
        obj.gameObjectList = [obj.gameObjectList, obj.player];
    end
    function SpawnEmemy( obj, pos )
        obj.enemy = Tank( obj,false );
        obj.enemy.pos = pos;
        obj.enemy.rot = -1;
        obj.enemy.mesh(1,:)=-1*obj.enemy.mesh(1,:);
        obj.gameObjectList = [obj.gameObjectList, obj.enemy];
    end
    function SpawnExplosion( obj, sourcePos)
            boom = Explosion();
            boom.pos = sourcePos;
            obj.explosionList = [obj.explosionList, boom];
    end
    function PlaySound(obj,filePath)
        [obj.y, obj.Fs] = audioread(filePath);
                 obj.sPlayer = audioplayer(obj.y, obj.Fs);
                 play( obj.sPlayer);
    end
    function retval = PlayerFireBullet( obj, T )
        retval = false;
        if ~obj.player.fired
            % create the bullet object
            obj.theta=atan(obj.mousePosition(2)/obj.mousePosition(1));
            bullet = Bullet(obj.theta,obj.player);
            bullet.pos = obj.player.pos +30 * [cos(obj.theta); sin(obj.theta)];
            bullet.vel = obj.player.vel+Bullet.BULLET_SPEED * [cos(obj.theta);sin(obj.theta)];
            bullet.rot = obj.theta;

            obj.gameObjectList(end+1) = bullet;

            obj.player.fired = true;
            retval = true;
        end
    end
    function CheckForCollisions( obj )
        for i = 1:length(obj.gameObjectList)
            objA = obj.gameObjectList(i);
            if objA.collisionRadius ~= -1
                for j = i+1:length(obj.gameObjectList)
                    objB = obj.gameObjectList(j);
                    if objB.collisionRadius ~= -1 && norm( objA.pos - objB.pos ) < objA.collisionRadius + objB.collisionRadius
                        objA.OnCollidesWith( objB );
                        objB.OnCollidesWith( objA );
                    end
                end
            end
        end
    end
    end
end