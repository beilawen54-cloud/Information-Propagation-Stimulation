% Define the graph
names = {'Ella', 'Amy', 'Charlie', 'David', 'Eva', 'Jack', 'Hector', 'Jones', 'Gibbs', 'Elizabeth', 'Turner', 'Tia', 'Angelica'};
s = [1 1 2 2 3 4 5 6 6 7 8 8 9 10 11 12 13 13];
t = [2 3 4 5 4 5 1 7 8 9 10 11 12 13 1 2 6 7];
G = digraph(s, t, [], names);

% Build weighted adjacency matrix A
A = adjacency(G, 'weighted');

% Spectral radius of A using eigs (for non-symmetric or sparse matrices)
rho = max(abs(eigs(A, 1)));  % largest magnitude eigenvalue
disp(['Spectral radius of A: ', num2str(rho)]);

% Set damping factor alpha and injection vector b
alpha = 0.85;
n = numnodes(G);
b = zeros(n, 1);
b(1) = 1;  % Assume Belle is the initial source of information

% Simulate damped linear model: x_{k+1} = alpha*A*x_k + (1-alpha)*b
x = b;
numSteps = 30;
X_hist = zeros(n, numSteps + 1);
X_hist(:, 1) = x;

for k = 1:numSteps
    x = alpha * A * x + (1 - alpha) * b;
    X_hist(:, k + 1) = x;
end

% --- Animate the graph ---
figure;
p = plot(G, ...
         'Layout', 'force', ...
         'NodeLabel', names, ...
         'MarkerSize', 10, ...
         'EdgeColor', [0.7 0.7 0.7], ...
         'LineWidth', 1.2);

colormap(jet);
colorbar;
axis off;
title('Information Propagation Over Time');

for k = 1:(numSteps + 1)
    p.NodeCData = X_hist(:, k);
    title(sprintf('Time Step %d', k - 1));
    drawnow;
    pause(0.2);
end

% --- Optional: plot influence convergence ---
figure;
plot(0:numSteps, X_hist', 'LineWidth', 2);
legend(names, 'Location', 'eastoutside');
xlabel('Time Step');
ylabel('Influence Value');
title('Node Influence Over Time');
grid on;
