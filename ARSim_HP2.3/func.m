
%%% example of 2D navigation with potential fields
%%% CS148 -- Building Intelligent Robots
%%% Author: Chad Jenkins  (cjenkins@cs.brown.edu)
%%%         Yuri Malitsky (ynm@cs.brown.edu)
%%%
%%% call as function with 2 arguments:
%%% gen_field: switch variable for preset examples (1-12)
%%% image_quality: qualilty of display (0,1)
%%%
%%% Internal Variables:
%%% x: current "robot" position
%%% s: struct of attractor positions 
%%% r: struct of repellor positions
%%%
%%% attractors and repellors have fields: 
%%%    x (position), w (weight), and k (shape, 1:cone, 2:exponential)

function [ output_args ] = func( gen_field, image_quality )

if (~exist('gen_field'))
    gen_field = 1;
end
if (~exist('image_quality'))
    image_quality = 1;
end

hold off;

% set a configuration of attractors/repellors
%gen_field = 11;
switch gen_field
case 1 % attract to location
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.1; s(1).k = 1;
case 2 % attract to position between two attractors
   x = [9 1];
   s(1).x = [1 5]; s(1).w = 0.1; s(1).k = 1;
   s(2).x = [1 1]; s(2).w = 0.1; s(2).k = 1;
case 3 % attract to position between two attractors, different initial pos
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.1; s(1).k = 1;
   s(2).x = [1 1]; s(2).w = 0.1; s(2).k = 1;
case 4 % attract to location around obstacle
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.1; s(1).k = 1;
   r(1).x = [8 8]; r(1).w = 0.08; r(1).k = 1;
case 5 % divergent case
   x = [9 9];
   s(1).x = [3 5]; s(1).w = 0.1; s(1).k = 1;
   r(1).x = [7 9]; r(1).w = 0.11; r(1).k = 1;
case 6 % navigate between two obstacles, cone repellors
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.03; r(1).k = 1; 
   r(2).x = [6 9]; r(2).w = 0.03; r(2).k = 1;
case 7 % navigate around three obstacles, cone repellors
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.03; r(1).k = 1; 
   r(2).x = [6 8]; r(2).w = 0.03; r(2).k = 1;
   r(3).x = [2 8]; r(3).w = 0.03; r(3).k = 1; 
case 8 % navigate between three obstacles, exponential repellors
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.5; r(1).k = 2; 
   r(2).x = [6 8]; r(2).w = 0.5; r(2).k = 2;
   r(3).x = [2 8]; r(3).w = 0.5; r(3).k = 2; 
case 9 % navigate between three obstacles, exponential repellors, too small weights
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.2; r(1).k = 2; 
   r(2).x = [6 8]; r(2).w = 0.2; r(2).k = 2;
   r(3).x = [2 8]; r(3).w = 0.2; r(3).k = 2; 
case 10 % navigate between three obstacles, exponential repellors, small weights
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.3; r(1).k = 2; 
   r(2).x = [6 8]; r(2).w = 0.3; r(2).k = 2;
   r(3).x = [2 8]; r(3).w = 0.3; r(3).k = 2; 
case 11 % navigate between three obstacles, exponential repellors, large weights
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [3 5]; r(1).w = 0.6; r(1).k = 2; 
   r(2).x = [6 8]; r(2).w = 0.6; r(2).k = 2;
   r(3).x = [2 8]; r(3).w = 0.6; r(3).k = 2; 
case 12 % local minima
   x = [9 9];
   s(1).x = [1 5]; s(1).w = 0.11; s(1).k = 1;
   r(1).x = [5 5]; r(1).w = 0.6; r(1).k = 2; 
   r(2).x = [2 6.5]; r(2).w = 0.8; r(2).k = 2;
   r(3).x = [4 9]; r(3).w = 0.6; r(3).k = 2; 
end



% display attractor/repellor configuration
Z = [];
minZ = 0;
scale = 10;
for i=1:100
    for j=1:100
        pos = [j/scale i/scale];
        z = 0;
        
        % if a sink node exists, add its strength to the Z
        if (exist('s'))
            % scan over all sink nodes
            for p = 1:size(s,2)
                if (s(p).k == 1) 
                    z = z + s(p).w * ( norm(s(p).x - pos) );
                elseif (s(p).k == 2)
                    z = z + exp(-norm((s(p).x-pos))/s(p).w);
                end
            end
        end
        
        % scan over all repellor nodes, and add their strengths to Z
        if (exist('r'))
            for p = 1:size(r,2)
                if (r(p).k == 1) 
                    z = z - r(p).w * ( norm(r(p).x - pos) );
                elseif (r(p).k == 2)
                    z = z + exp(-norm((pos-r(p).x))/r(p).w);
                end
            end
        end
        
        Z(i,j) = z;
        
        if z < minZ
           minZ = z; 
        end
    end
end


surfc(Z);
hold on;


% Display plot 2
plot3(x(1,1)*scale,x(1,2)*scale, minZ, 'k.','MarkerSize',20);
plot3(x(1,1)*scale, x(1,2)*scale, Z(round(x(1,2)*scale), round(x(1,1)*scale))+.07,'k.','MarkerSize',100);
path = x;
if (exist('s'))
   for i = 1:size(s,2)
      plot3(s(i).x(1,1)*scale,s(i).x(1,2)*scale,minZ,'b.','MarkerSize',20);
   end
end
if (exist('r'))
   for i = 1:size(r,2)
      plot3(r(i).x(1,1)*scale,r(i).x(1,2)*scale,minZ,'r.','MarkerSize',20);
   end
end


% iteration loop: update robot position over time
for t = 1:1000
   
   % initialize vector accumulator
   dx = [0 0];

   % accumulate vector sum over attractors
   if (exist('s'))
      for i = 1:size(s,2)
         if (s(i).k == 1) 
            dx = dx + s(i).w*(s(i).x-x)/norm((s(i).x-x));
         elseif (s(i).k == 2)
            dx = dx + (s(i).x-x)*exp(-norm((s(i).x-x))/s(i).w);
         end
      end
   end

   % accumulate vector sum over repellors
   if (exist('r'))
      for i = 1:size(r,2)
         if (r(i).k == 1) 
            dx = dx + r(i).w*(x-r(i).x)/norm((x-r(i).x));
         elseif (r(i).k == 2)
            dx = dx + (x-r(i).x)*exp(-norm((x-r(i).x))/r(i).w);
         end
      end
   end

   % integrate change in robot position over time (dx means dx/dt) as 
   x = x + dx;
   path = [path; x];

   % update display 
   if image_quality == 0
        plot3(x(1,1)*scale,x(1,2)*scale,minZ,'k.');
        plot3(path(t,1)*scale, path(t,2)*scale, Z(round(path(t,2)*scale), round(path(t,1)*scale))+.07,'k.','MarkerSize',100);
        plot3(x(1,1)*scale, x(1,2)*scale, Z(round(x(1,2)*scale), round(x(1,1)*scale))+.06,'w.','MarkerSize',97);
   else
        hold off;
        surfc(Z);
        hold on;
        
        if (exist('s'))
            for i = 1:size(s,2)
                plot3(s(i).x(1,1)*scale,s(i).x(1,2)*scale,minZ,'b.','MarkerSize',20);
            end
        end
        if (exist('r'))
            for i = 1:size(r,2)
                plot3(r(i).x(1,1)*scale,r(i).x(1,2)*scale,minZ,'r.','MarkerSize',20);
            end
        end
        
        for i = 1:size(path,1)
            plot3(path(i,1)*scale,path(i,2)*scale,minZ,'k.');
            plot3(path(i,1)*scale, path(i,2)*scale, Z(round(path(i,2)*scale), round(path(i,1)*scale))+.01,'k.','MarkerSize',20);
        end
        
        plot3(x(1,1)*scale,x(1,2)*scale,minZ,'k.');
        plot3(x(1,1)*scale, x(1,2)*scale, Z(round(x(1,2)*scale), round(x(1,1)*scale))+.04,'k.','MarkerSize',100);
   end
   title(sprintf('Iteration: %d',t));
   refresh;
   drawnow;
   
   % pause at a some point in time
   %if (mod(t,500) == 0) input('continue'); end

end




    