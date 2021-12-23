function draw(position, reward, f, walls)

clf();
hold on;

axis([0 (f + 2) 0 (f + 2)]);
axis square

j = 1;
i = 1;
value = 1;
env = [];

for value = 1:(f*f)
    env(j, i) = value;
    if i == f
        i = 1;
        j = j + 1;
    else
        i = i + 1;
    end
end


stem(0:f + 1);
ax = gca;
ax.YDir = 'reverse';

% pacman position in coordinates
[row, col] = find(env == position);

% reward position in coordinates
[rrow, rcol] = find(env == reward);

% GRID
for i = 1:f + 1
   plot([i, i], [f + 1, 1], 'LineWidth', 2, 'Color',[0.9, 0.9, 0.9]);
   plot([1, f + 1], [i, i], 'LineWidth', 2, 'Color',[0.9, 0.9, 0.9]);
end

% WALLS REPRESENTATION
for i = 1:length(walls)
    [x, y] = find(env == walls(i));
    fill([y, y, y + 1 , y + 1], [x, x + 1, x + 1, x], [0.5, 0.5, 0.5]);
end

% REWARD
plot(rcol + 0.5, rrow + 0.5, 'o', 'LineWidth', 2.5, 'Color','red');

% SNAKE
plot(col + 0.5, row + 0.5, 'o', 'LineWidth', 2.5, 'Color','green');

drawnow;

end