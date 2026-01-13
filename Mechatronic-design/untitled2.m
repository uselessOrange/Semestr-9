n = 201;        % matrix size
alpha = 15;     % angle in degrees

% Coordinate grid
[x, y] = meshgrid(1:n, 1:n);

% Move origin to bottom-left corner
X = x - 1;
Y = y - 1;

% Convert angle
alpha_rad = deg2rad(alpha);

% Triangle condition
inside_triangle = ...
    (Y >= 0) & ...
    (X >= 0) & ...
    (Y <= X * tan(alpha_rad));

% Create mask
M = ones(n);
M(inside_triangle) = 0;

% Display
imagesc(M)
axis equal tight
colormap(gray)
title('Triangle with apex at bottom-left corner')
