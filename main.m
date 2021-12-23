clear all; close all; clc;

f = 8; % N filas
c = 8; % N columnas
s = f*c; % N estados
MAX = 5; % N de experimentos por mapa
count = 1; % Experimento actual

obs = [];
goals = [];
walls = [];

for j=1:s
    if(j <= c)
        walls = [walls,j];
    elseif(mod(j,c) == 0)
        walls = [walls,j];
    elseif(mod(j-1,c) == 0)
        walls = [walls,j];
    elseif(j > s-c)
        walls = [walls,j];
    end
end
%{
n = 0;
while (n < c)
    rand_wall = randi(s);
    if(ismember(rand_wall,walls) == 0)
        walls = [walls,rand_wall];
        n = n+1;
    end
end
%}

init = 1;
while (ismember(init, walls))
    init = randi(s);
end

while count <= MAX
    % Initialize the values
    final = 1;
    
    while (ismember(final, walls) || final == init)
        final = randi(s);
    end
    
    disp("Map["+count+"]: Init --> "+init+" Final --> "+final+" (Training...)")
    
    % Generate Markov process
    MDP = markovProcess(final, walls, f, c);
    
    % Environment
    env = rlMDPEnv(MDP);
    env.ResetFcn = @() init;
    
    % Q-Learning
    qTable = rlTable(getObservationInfo(env),getActionInfo(env));
    qRepresentation = rlQValueRepresentation(qTable,getObservationInfo(env),getActionInfo(env));
    qRepresentation.Options.LearnRate = 1;

    % Agent
    agentOpts = rlQAgentOptions;
    agentOpts.EpsilonGreedyExploration.Epsilon = 0.01;
    qAgent = rlQAgent(qRepresentation,agentOpts);
    
    % Training
    trainOpts = rlTrainingOptions;
    trainOpts.MaxEpisodes = 200;
    trainOpts.StopTrainingCriteria = "EpisodeCount";
    trainOpts.Plots = "none";
    trainStats = train(qAgent,env,trainOpts);
    
    % Results
    simulation = sim(qAgent,env);
    observations = simulation.Observation.MDPObservations.Data;
    reward = simulation.Reward.Data;
    actions = simulation.Action.MDPActions.Data;
    
    % Update the values
    goals = [goals, final];
    init = final;
    for i = 1:length(observations)
        obs = [obs, observations(1,1,i)];
    end    
    count = count + 1;
end

% Display
i_g = 1;
for i = 1:length(obs)
    draw(obs(i), goals(i_g), f, walls)
    if obs(i) == goals(i_g)
        i_g = i_g + 1;
    end
    pause(0.5)
end