clc;
clear;
model = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\deploy.prototxt';%ģ��  
weights = 'C:\caffe\caffe-master\models\bvlc_reference_caffenet\bvlc_reference_caffenet.caffemodel';%����  
net=caffe.Net(model,'train');%���� 
net.copy_from(weights); %�õ�ѵ���õ�Ȩ�ز��� 
names=net.blob_names; %����ÿһ�������
namess=net.layer_names;
%weight_fullvisual( net,2 )  %3��ͨ����
weight_partvisual(net,2,48) 
