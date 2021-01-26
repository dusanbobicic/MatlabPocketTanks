function [] = PocketTanks()

close all
clear all
clc
%------CONSTANTS------
%--------MAIN---------
FPS = 20; % Number of frames per second
FIGURE_WIDTH = 800; % [pix]
FIGURE_HEIGHT = 600; % [pix]
 
% colors
FIGURE_COLOR = [0.0, 0.0, 0.0]; % background color

% DERIVED ========================================
FRAME_DELAY = 1/FPS; % Delay between animation frames [sec].


% boolean flags
quitGame = false; % guard for main loop. when true, program ends


% other
fig = []; % main program figure
mainAxis = []; %reference to the main axis

gameObj = [];

% set up the main figure and axis for the program
% run once at start of program
function CreateFigure()
    % ScreenSize is a four-element vector: [left, bottom, width, height]:
    scrsz = get(0,'ScreenSize');
    % put figure in the middle of the screen
    fig = figure( 'Position', [(scrsz(3)-FIGURE_WIDTH)/2, ...
                               (scrsz(4)-FIGURE_HEIGHT)/2, ...
                               FIGURE_WIDTH, ...
                               FIGURE_HEIGHT], ...
                  'Name', 'PocketTanks', 'MenuBar', 'none', 'Toolbar', 'none' );
              
    % custom close function.
    set(fig,'CloseRequestFcn',@my_closefcn);

    % make custom mouse pointer
    pointer = NaN(16, 16);
    % pointer(4, 1:7) = 2;
    % pointer(1:7, 4) = 2;
    % pointer(4, 4) = 1;
    pointer(4, 4) = 2;
    set(fig, 'Pointer', 'Custom');
    set(fig, 'PointerShapeHotSpot', [4, 4]);
    set(fig, 'PointerShapeCData', pointer);
    
    %register keydown and keyup listeners
    set(fig,'KeyPressFcn',@keyDownListener)
    set(fig, 'KeyReleaseFcn', @keyUpListener);
    set(fig,'WindowButtonDownFcn', @mouseDownListener);
%     set(fig,'WindowButtonUpFcn', @mouseUpListener);
%     set(fig,'WindowButtonMotionFcn', @mouseMoveListener);

    % figure can't be resized
    set(fig, 'Resize', 'off');

    mainAxis = axes( 'Parent', fig, 'Units', 'pixels', ...
              'Position', [ 0, 0, FIGURE_WIDTH, FIGURE_HEIGHT ], ...
              'xlim', [0 FIGURE_WIDTH], 'ylim', [0, FIGURE_HEIGHT], ...
              'DataAspectRatio', [1, 1, 1] );
    axis manual; %axis wont be resized

    %set color for the court, hide axis ticks.
    set(mainAxis, 'color', FIGURE_COLOR, 'YTick', [], 'XTick', []);

    hold on;
end
%****************INITIALIZE***********
function Init()
    gameObj = Game(FIGURE_WIDTH, FIGURE_HEIGHT);
end
%***********MOUSE LISTENER************
function mouseDownListener(hObject,~)
pos=get(hObject,'CurrentPoint')
gameObj.mousePosition=pos;
end
%***************KEZ LISTENERS*********
% redefinition of CloseRequestFcn
% so don't get stuck in loop if close window while paused
% probably don't want to modify this.
function my_closefcn(src, event)
    paused = false; %this is the only modification to the default definition
    quitGame = true; % well, and this
    if isempty(gcbf)
        if length(dbstack) == 1
            warning('MATLAB:closereq', ...
            'Calling closereq from the command line is now obsolete, use close instead');
        end
        close force
    else
        if (isa(gcbf,'ui.figure'))
            % Convert GBT1.5 figure to a double.
            delete(double(gcbf));
        else
            delete(gcbf);
        end
    end
end
function keyDownListener( src, event )
    switch event.Key
        case 'space'
            gameObj.pressedSPACE = true;
        case 'escape'
            quitGame = true;
            fprintf('Closing due to escape key press\n');
    end
end

function keyUpListener( src, event )
    switch event.Key
        case 'space'
            gameObj.pressedSPACE = false;
    end
end

%**********END KEY LISTENERS*************
CreateFigure();
Init();
gameObj.Reset();
timer = now();
while ~quitGame
    gameObj.Update();    
    secToWait = FRAME_DELAY - (now() - timer)/86400;
    if secToWait > 0
        pause( secToWait ); % freeze program for each frame
    end
    timer = now();
    
end

if ishandle(fig)
    close(fig);
end

end