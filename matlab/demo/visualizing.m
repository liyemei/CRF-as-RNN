clc;
clear;
model = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\deploy.prototxt';%ģ��  
weights = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\bvlc_reference_caffenet.caffemodel';%����  
net=caffe.Net(model,'test');%����    
names=net.blob_names; %����ÿһ�������
net.copy_from(weights); %�õ�ѵ���õ�Ȩ�ز���  
net %��ʾnet�Ľṹ  
d = load('C:\caffe\caffe-master\matlab\+caffe\imagenet\ilsvrc_2012_mean.mat');  %��ֵ�ļ�
mean_data = d.mean_data;  
%��ɫͼ����BGR�洢����matlab�ж�ȡ��˳��һ����RGB�����Զ���ֻè��Ҫ�������´���
im = imread('cat.jpg');%��ȡͼƬ  
im_data = im(:, :, [3, 2, 1]);  %matlab����RGB��ȡͼƬ��
IMAGE_DIM = 256;%ͼ��Ҫresize�Ĵ�С������resizeΪͼ����С���Ǹ�ά��  
CROPPED_DIM = 227;%������Ҫ��һ��ͼƬcrops��ʮ�飬����softmpencv��BGR��������Ҫת��˳��Ϊopencv�����ʽ  
im_data = permute(im_data, [2, 1, 3]);  % ԭʼͼ��m*n*channels,����permuteΪn*m*channels��С  
im_data = single(im_data);  % ǿ��ת������Ϊsingle����  
im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % ���Բ�ֵresizeͼ��  

 im_data = im_data - mean_data;  % ���ֵ  
crops_data = zeros(CROPPED_DIM, CROPPED_DIM, 3, 10, 'single');%ע��˴�����Ϊprototxt�������СΪ��*��*ͨ����*10  
indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;%���ʮ��ÿһ���С��ԭʼͼ���С��࣬����crops  
%���������ν�һ��ͼƬcrops��ʮ��  
n = 1;  
%�˴�����forѭ��������1��indices�����ǵ�һ��ȡindices(1)��Ȼ����indices(2)��ÿһ��ѭ������  
%�ֱ��ȡͼƬ�ĸ��Ǵ�СΪCROPPED_DIM*CROPPED_DIM��ͼƬ  
for i = indices  
    for j = indices  
        crops_data(:, :, :, n) = im_data(i:i+CROPPED_DIM-1, j:j+CROPPED_DIM-1, :);%�����ĸ��ǵ�cropdata��1 2 3 4  
        crops_data(:, :, :, n+5) = crops_data(end:-1:1, :, :, n);%��ת180����һ�Σ������ĸ��ǵķ�תcropdata��6 7 8 9  
        n = n + 1;  
    end  
end  
center = floor(indices(2) / 2) + 1;  
%������Ϊcrop_data���ϽǶ��㣬��ȡCROPPED_DIM*CROPPED_DIM�Ŀ�  
crops_data(:,:,:,5) = ...  
    im_data(center:center+CROPPED_DIM-1,center:center+CROPPED_DIM-1,:);  
%��forѭ������һ������ת180�㣬����߽緭ת  
crops_data(:,:,:,10) = crops_data(end:-1:1, :, :, 5);  
                             
cat_map=zeros(CROPPED_DIM*2,CROPPED_DIM*5,3);%��������չʾ  
cat_num=0;  
for i=0:1  
    for j=0:4  
        cat_num=cat_num+1  
        cat_map(CROPPED_DIM*i+1:(i+1)*CROPPED_DIM,CROPPED_DIM*j+1:(j+1)*CROPPED_DIM,:)=crops_data(:,:,:,cat_num);  
    end  
end  
imshow(uint8(cat_map))
%ǰ�����
res=net.forward({crops_data});  
prob=res{1};  
prob1 = mean(prob, 2);  
[~, maxlabel] = max(prob1);
%weight_partvisual(net,1,1)  %�����ò�����ʾ������weight_partvisual( net,layer_num ,channels_num )  
                               %  layer_num�ǵڼ�������㣬 channels_num ��ʾ 
                                 %  ��ʾ�ڼ���ͨ���ľ���ˣ�ȡֵ��ΧΪ ��0����һ�������ͼ����
%weight_fullvisual( net,1  )  %3��ͨ����
mapnum=3;%�ڼ����feature���������  
crop_num=1;%�ڼ���crop������ͼ���������  
feature_partvisual( net,mapnum,crop_num ) 

%mapnum=2;%�ڼ����feature���������  
%feature_fullvisual( net,mapnum )
%K>> A=net.blobs('pool5').get_data(); 
%C=net.layers('fc6').params(1).get_data();  