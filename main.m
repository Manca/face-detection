function [] = main()
%                 - FINAL PROJECT -
%                   
%            FACE DETECTION USING VIOLA-JONES DETECTOR
%
%       Nenad Mancevic, July 2012.
%       The Faculty of Electronic Engineering Nis (c) 2012.
%-------------------------------------------------------------------------

clear all
addpath('I:\Work\Face Detection\Project\GML_AdaBoost_Matlab_Toolbox_0.3');
% some initialization values
posImages = 150;
negImages = 200;
totalImages = 350;
totalNoOfFeatures = 35802;

positiveFeatures = zeros(posImages, totalNoOfFeatures);
negativeFeatures = zeros(negImages, totalNoOfFeatures);

% 1. Load training set
% if it's not precomputed, precompute it and save it for later use
if (exist('posFeatures.mat', 'file') == 0)
    for k=1:posImages
        if (k < 10)
            str = strcat('mit\train\face\face0000', int2str(k), '.pgm');
        elseif (k < 100)
            str = strcat('mit\train\face\face000', int2str(k), '.pgm');
        elseif (k < 1000)
            str = strcat('mit\train\face\face00', int2str(k), '.pgm');
        elseif (k < 10000)
            str = strcat('mit\train\face\face0', int2str(k), '.pgm');            
        end
        currImg = imread(str);
        if (mod(k,100)==0)
            fprintf('Extracting features from positive image: %d\n', k);
        end
% 2. Extract features out of it
        positiveFeatures(k, :) = extractFeatures(currImg);
    % we can turn on mode in extractFeatures to extract all features' info
    % in terms of x,y position, size, type, and so on - useful for
    % detection later
    %   save featuresInfo.mat featuresInfo     
    end
    save posFeaturesBig.mat positiveFeatures
else
    positiveFeatures = load('posFeatures.mat');
end

% same for negative features
if (exist('negFeatures.mat', 'file') == 0)
j=1;
    while j <= negImages
        if (j < 10)
            str = strcat('mit\train\non-face\B1_0000', int2str(j), '.pgm');
        elseif (j < 100)
            str = strcat('mit\train\non-face\B1_000', int2str(j), '.pgm');
        elseif (j < 1000)
            str = strcat('mit\train\non-face\B1_00', int2str(j), '.pgm');
        elseif (j < 10000)
            str = strcat('mit\train\non-face\B1_0', int2str(j), '.pgm');            
        end
        if (exist(str))
            currImg = imread(str);            
            if (mod(j,100)==0)
                fprintf('Extracting features from negative image: %d\n', j);
            end
            negativeFeatures(k, :) = extractFeatures(currImg);
            j=j+1;
        end
    end
    save negFeaturesBig.mat negativeFeatures
else
    negativeFeatures = load('negFeatures.mat');
end

% 3. Train the classifiers using the features
weak_learner = tree_node_w(3); % our weak learners

all_features = [positiveFeatures.positiveFeatures; negativeFeatures.negativeFeatures];
labels(1:posImages) = 1;
labels(posImages+1:totalImages) = -1;

all_features = all_features';
% learning algorithm wants Features X NoImages instead od ImagesXFeatures

if (exist('learners.mat')==0 & exist('weights.mat')==0)
  fprintf('Training starts...');
  c=clock;
  fprintf('Current time: %d:%d:%1.f\n', c(4), c(5), c(6));
  [learners weights] = RealAdaBoost(weak_learner, all_features, labels, 100);
  save learnersBig.mat learners
  save weightsBig.mat weights
  fprintf('Training finishes...');
  e=clock;
  fprintf('Current time: %d:%d:%1.f\n', e(4), e(5), e(6)); 
else
  fprintf('Classifiers already trained. Loading...');
  learners = load('learners.mat');
  weights = load('weights.mat');
end
  
% 4. Load testing set
testimg = imread('testImgs\profile.jpg');
testimg2 = rgb2gray(testimg);     % convert to grayscale
resized = imresize(testimg2,1/8); % resize it for faster processing
n = size(resized, 1);
m = size(resized, 2);
% 5. Process images, using learned classifiers
imshow(testimg);
count = 0;
for y=2:1:m-18
      for x=2:1:y
       % x
       % y
        count = count+1;
        subimg = resized(x:x+19-1,y:y+19-1);
        if (detectFace(learners.learners, weights.weights, subimg) == 1)     
      %  winFeatures = extractFeatures(subimg);
      %  if (Classify(learners.learners, weights.weights, winFeatures) > 1) %(detectFace(learners.learners, weights.weights, winFeatures) == 1)
            rectangle('Position', 8*[y x 19 19], 'EdgeColor', 'g');
        end
      end
end
fprintf('Total number of iterations: %d\n', count);
end
