% This package contains code for the "CRF-RNN" semantic image segmentation method, published in the 
% ICCV 2015 paper Conditional Random Fields as Recurrent Neural Networks. Our software is built on 
% top of the Caffe deep learning library.
% 
% Contact:
% Shuai Zheng (szheng@robots.ox.ac.uk), Sadeep Jayasumana (sadeep@robots.ox.ac.uk), Bernardino Romera-Paredes (bernard@robots.ox.ac.uk)
%
% Supervisor: 
% Philip Torr (philip.torr@eng.ox.ac.uk)
%
% For more information about CRF-RNN please vist the project website http://crfasrnn.torr.vision.
%

%caffe_path = '../caffe-crfrnn/';

model_def_file = 'TVG_CRFRNN_COCO_VOC.prototxt';
model_file = 'TVG_CRFRNN_COCO_VOC.caffemodel';
phase = 'test';
use_gpu = 1; % Set this to 0 if you don't have a GPU.

if exist(model_file, 'file') ~= 2
    error('You need a network model file. Please download our default model by running ./download_trained_model.sh');
end



%addpath(fullfile(caffe_path, 'matlab/caffe'));


if exist('use_gpu', 'var') && use_gpu
  caffe.set_mode_gpu();
  gpu_id = 0;  % we will use the first gpu in this demo
  caffe.set_device(gpu_id);
else
  caffe.set_mode_cpu();
end


%caffe('reset');
%caffe('set_device', 0); % Change here if you have a powerful GPU in different device, nvidia-smi will help you check the device information.

%tvg_matcaffe_init(use_gpu, model_def_file, model_file);

net = caffe.Net(model_def_file, model_file, phase);


im = imread('input.jpg');

[h, w, d] = size(im);

if (d ~= 3)
   error('Error! Wrong depth.\n');
end

if (h > 500 || w > 500)
   error('Error! Wrong image size.\n');
end

prepared_im = tvg_prepare_image_fixed(im);

inputData = {prepared_im};


%scores = caffe('forward', inputData);   
scores = net.forward(inputData);


Q = scores{1};        
        
[dumb, pred] = max(Q, [], 3);
pred = pred';
pred = pred(1:h, 1:w);

load map.mat
imwrite(pred, map, 'output.png', 'png');    
