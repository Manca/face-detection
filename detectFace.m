function detected = detectFace(learners, tezine, subImgWnd)
% detected = detectFace(learners, tezine, subImgWnd
%
% Funkcija koja vrsi detekciju lica na zadatom potprozoru
%
% learners  - niz klasifikatora
% tezine    - niz njihovih tezina
% subImgWnd - potprozor nad kojim se vrsi analiza
%
% detected  - 1, ili 0 u zavisnosti da li je detektovano lice ili nije
%

totalLearners = size(learners,2);

for i=1:totalLearners
    dimtrsign = get_dim_and_tr(learners{i});
    totalWeak = length(dimtrsign)/3;
    
    for k=1:totalWeak
        dim(i,k) = dimtrsign(3*(k-1)+1);
        thresh(i,k) = dimtrsign(3*(k-1)+2);
        sign(i,k) = dimtrsign(3*(k-1)+3);
    end
end
% totalMatrix = horzcat(dim, thresh, sign);
% totalMatrix = sortrows(totalMatrix, 3); % sort by weights (first two cols are reserved for dim)
% 
% dim = totalMatrix(:, 1:2);
% thresh = totalMatrix(:, 3:4);
% sign = totalMatrix(:, 5:6);

final_prediction = 0;

for i=1:totalLearners
    hypothesis = predict(dim(i,:), thresh(i,:), sign(i,:), subImgWnd);
%     if (~hypothesis)
%         detected = 0;
%         return;
%     end
    final_prediction = final_prediction + tezine(i)*hypothesis; 
end
if final_prediction > 0
    detected = 1;
    return
else
    detected = 0;
    return
end


end

function predictSign = predict(dim, thresh, sign, subWindow)
    featuresInfo = load('featuresInfo.mat');
    for i=1:size(dim,2)
     if (dim(i) ~= 0)
         getOneFeatureInfo = featuresInfo.featuresInfo(dim(i),:);
         oneFeatureThresh = CalcHaarFeature(subWindow, getOneFeatureInfo(1), getOneFeatureInfo(2), getOneFeatureInfo(3), getOneFeatureInfo(4), getOneFeatureInfo(5));
        if (sign(i) * oneFeatureThresh <= (sign(i) * thresh(i)))
            predictSign = 0;
            return
        end
     end
    end
    predictSign = 1;
    return
end
