function markov=f(final, walls, f, c)
    s = f*c; % N estados
    
    term_states = ["s"+final];
    for w=1:s
        if(ismember(w,walls))
            term_states = [term_states, "s"+w];
        end
    end
    MDP = createMDP(s,["left"; "right"; "up"; "down"]);
    MDP.TerminalStates = term_states;

    for i=1:s
        % Terminal state
        if(i == final) 
            MDP.T(i,i,1) = 1;
            MDP.T(i,i,2) = 1;
            MDP.T(i,i,3) = 1;
            MDP.T(i,i,4) = 1;
            MDP.R(i,i,1) = 0;
            MDP.R(i,i,2) = 0;
            MDP.R(i,i,3) = 0;
            MDP.R(i,i,4) = 0;
        % Wall state
        elseif(ismember(i,walls))  
            MDP.T(i,i,1) = 1;
            MDP.T(i,i,2) = 1;
            MDP.T(i,i,3) = 1;
            MDP.T(i,i,4) = 1;
            MDP.R(i,i,1) = 0;
            MDP.R(i,i,2) = 0;
            MDP.R(i,i,3) = 0;
            MDP.R(i,i,4) = 0;
        else
            % RIGHT: Transition and Reward
            if(ismember(i+1,walls))
                MDP.T(i,i+1,2) = 1;
                MDP.R(i,i+1,2) = -1000000;
            else
                MDP.T(i,i+1,2) = 1;
                if(i+1 == final)
                    MDP.R(i,i+1,2) = 100;
                else
                    MDP.R(i,i+1,2) = -1;
                end
            end

           % LEFT: Transition and Reward
            if(ismember(i-1, walls))
                MDP.T(i,i-1,1) = 1;
                MDP.R(i,i-1,1) = -1000000;     
            else
                MDP.T(i,i-1,1) = 1;
                if(i-1 == final)
                    MDP.R(i,i-1,1) = 100;
                else
                    MDP.R(i,i-1,1) = -1;
                end
            end 

           % DOWN: Transition and Reward
            if(ismember(i+c, walls))
                MDP.T(i,i+c,4) = 1;
                MDP.R(i,i+c,4) = -1000000;
            else
                MDP.T(i,i+c,4) = 1;
                if(i+c == final)
                    MDP.R(i,i+c,4) = 100;
                else
                    MDP.R(i,i+c,4) = -1;
                end
            end

           % UP: Transition and Reward
            if(ismember(i-c,walls))
                MDP.T(i,i-c,3) = 1;
                MDP.R(i,i-c,3) = -1000000;
            else
                MDP.T(i,i-c,3) = 1;
                if(i-c == final)
                    MDP.R(i,i-c,3) = 100;
                else
                    MDP.R(i,i-c,3) = -1;
                end
            end

        end
    end
    markov=MDP;
end