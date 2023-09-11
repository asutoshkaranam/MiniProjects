%{
*
@author: Asutosh Karanam
*
*
%}

% Clear the console and start the simulation on a fresh screen
clear;
clc;
%Take the User-Input for the # of iterations of Monte-carlo Simulation
n = input("Enter the N value\n");
fprintf("Running for %d iterations\n",n);

%Initialize the variables to store the actual number of choices that can be categorized.
single_pair = 0;
double_pair = 0;
three_of_a_kind = 0;
four_of_a_kind = 0;
itr = 1; % Iterator Variable to count the number of iterations

% Run the loop for N iterations
while (itr<=n)
    fprintf("Iteration Number --------------------- %d\n",itr);

%      Generate the random permutation of 5 cards between 1 and 20
%         Ace – Card Indices 1,6,11,16;
%         2 – Card Indices 2,7,12,17;
%         3 – Card Indices 3,8,13,18;
%         4 – Card Indices 4,9,14,19;
%         5 – Card Indices 5,10,15,20;
%     
    choice = randperm(20,5); 
    fprintf('choice: [%s]\n', join(string(choice), ',')); % Print the hands generated
    heatMap = [0,0,0,0,0]; %Map to track the number of each cards generated
    i=1;

    % Build the map array
    while (i<=5)
    	a = mod(choice(i),5);
    	heatMap(a+1) = heatMap(a+1) + 1;
    	i= i+1;
    end
    fprintf('heatMap: [%s]\n', join(string(heatMap), ','));

    %Take the maximum value in the list to determine the category
    maximum = max(heatMap);
    if (maximum > 2) 
        if (maximum == 4) % Max value 4 indicates that some card occurred 4 times in the distribution
            %four-of-a-kind
            four_of_a_kind = four_of_a_kind+1;
            fprintf('Current Four of a kind: %d \n', four_of_a_kind);
        elseif (maximum == 3) % Max of 3 indicates that some card occurred 3 times in the distribution
            %Check and remove the outcome if it's full house - EXCEPTION
            if (ismember(2,heatMap))
                fprintf('Full-House shouldnt be considered as three of a kind \n');
            else
                %Three-of-a-Kind
                three_of_a_kind = three_of_a_kind+1;
                fprintf('Current Three of a kind: %d \n', three_of_a_kind);
            end
        end
    else
        % Max of 2 indicates that some card is in pairs in the distribution
        cnt=sum(heatMap==2); % Count the number of pairs
        if (cnt == 2) % If 2 pairs exist, then it’s a double pair; else it’a single pair
            %Double-Pair
            double_pair = double_pair+1;
            fprintf('Current Double pairs: %d \n', double_pair);
        elseif (cnt == 1)
            %Single-Pair
            single_pair = single_pair+1;
            fprintf('Current Single pairs: %d \n', single_pair);
        end
    end
    itr = itr+1;
end
% Print the probabilities of all categories till 5th decimal place
fprintf('Probability of Single pairs: %.5f \n', single_pair/n);
fprintf('Probability of Double pairs: %.5f \n', double_pair/n);
fprintf('Probability of Three of a kind: %.5f \n', three_of_a_kind/n);
fprintf('Probability of Four of a kind: %.5f \n', four_of_a_kind/n);
