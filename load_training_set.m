% function to read training examples into binary_imgs array
% before reading samples are resampled to 22x22 pixels and converted to 
% grayscale
function [binary_imgs] = load_training_set(faces)

for i=1:size(faces,2)
    tmp_img = imread(faces{i}.fileName);
    tmp_img = imresize(tmp_img, 1/4);
    tmp_img = rgb2gray(tmp_img);
    
    binary_imgs(i) = {tmp_img};
    
end

end