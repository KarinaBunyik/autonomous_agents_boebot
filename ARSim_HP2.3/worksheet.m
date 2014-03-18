

potentialFieldFormula = @(x,y,xp,yp, alpha, beta, gamma) ...
    alpha*exp( -((x-xp)/beta)^2  -((y-yp)/gamma)^2);
potentialFieldDiffFormulaX = @(x,y,xp,yp, alpha, beta, gamma) ...
    (2 * alpha * (x-xp)) / (beta * exp(((y-yp)/gamma)^2 )) * exp(((x-xp)/beta)^2 );
potentialFieldDiffFormulaY = @(x,y,xp,yp, alpha, beta, gamma) ...
    (2 * alpha * (y-yp)) / (gamma * exp(((y-yp)/gamma)^2 )) * exp(((x-xp)/beta)^2 );

potentialFieldWallN = [0 1.9 1 0.1 5];%[xp, yp, alpha, beta, gamma]

syms x;
syms y;
syms alpha;
syms beta;
syms gamma;
syms xp;
syms yp;
potentialWallNx = diff(potentialFieldFormula( ...
    x, y, xp, yp, alpha, ...
    beta, gamma), x)
potentialWallNy = diff(potentialFieldFormula( ...
    x, y, xp,yp, alpha, ...
    beta, gamma), y)
