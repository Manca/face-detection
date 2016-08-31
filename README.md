Face Detection using Viola-Jones detector
==============

To use the application you should have GML AdaBoost Toolbox[1] installed on your machine. 
The main module is function main which is used to start the application. 

The first thing to do before running the application is to adjust the line:

    addpath('I:\Work\Face Detection\Project\GML_AdaBoost_Matlab_Toolbox_0.3');

with your GML AdaBoost installation path.

The application has two modes: "training" and "running". The first one allows you to train your own classifiers using
the set of positive (images with faces only) and negative (images that do not contain face) samples.

For this application I used MIT set of training samples[2]. Positive samples should be in "mit\train\face" directory,
while the negative ones are expected in "mit\train\non-face".

When the training is finished you'll have 4 new files: "posFeatures.mat", "negFeatures.mat", "learners.mat" and 
"weights.mat". Once the system is trained, you can run the application on your own input sample.

To do that, just edit the line:

      testimg = imread('testImgs\profile.jpg');

with your testing image. Now you should see your face detected. It's important to note that the detection success rate
directly depends on the amount of training samples. The more samples the system is trained with, the better the detection
ratio and lower number of false positives.

And one final note, the application displayes few face candidates (using the green rectangle). You should merge them
together if you want to get the one that's the most precise.

---

[1] http://graphics.cs.msu.ru/ru/science/research/machinelearning/adaboosttoolbox

[2] http://cbcl.mit.edu/projects/cbcl/software-datasets/FaceData2.html
