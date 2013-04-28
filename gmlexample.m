% Step1: reading Data from the file
MaxIter = 100; % boosting iterations

% Step2: splitting data to training and control set
TrainData   = tt;
TrainLabels = precomp_data.labels;

%ControlData   = Data(:,2:2:end);
%ControlLabels = Labels(2:2:end);

% Step3: constructing weak learner
weak_learner = tree_node_w(3); % pass the number of tree splits to the constructor

% Step4: training with Gentle AdaBoost
[RLearners RWeights] = RealAdaBoost(weak_learner, TrainData, TrainLabels, MaxIter);

% Step5: training with Modest AdaBoost
[MLearners MWeights] = ModestAdaBoost(weak_learner, TrainData, TrainLabels, MaxIter);

% Step6: evaluating on control set
%ResultR = sign(Classify(RLearners, RWeights, ControlData));

%ResultM = sign(Classify(MLearners, MWeights, ControlData));

% Step7: calculating error
%ErrorR  = sum(ControlLabels ~= ResultR) / length(ControlLabels)

%ErrorM  = sum(ControlLabels ~= ResultM) / length(ControlLabels)