function [  ] = feature_partvisual( net,mapnum,crop_num ) 
%��һ�������ָ���ĵ�crop_num��ͼ���ڵ�map_num����п��ӻ���ע�⣬��һ���ֵĿ��ӻ������ػ����
names=net.blob_names;  
featuremap=net.blobs(names{mapnum}).get_data();%��ȡָ���������ͼ  
[m_size,n_size,num,crop]=size(featuremap);%��ȡ����ͼ��С����*��*����˸���*ͨ����  
row=ceil(sqrt(num));%����  
col=row;%����  
feature_map=zeros(m_size*row,n_size*col);  
cout_map=1;  
for i=0:row-1  
    for j=0:col-1  
        if cout_map<=num  
            feature_map(i*m_size+1:(i+1)*m_size,j*n_size+1:(j+1)*n_size)=(mapminmax(featuremap(:,:,cout_map,crop_num),0,1)*255)';  
            cout_map=cout_map+1;  
        end  
    end  
end  
imshow(uint8(feature_map))  
str=strcat('feature map num:',num2str(cout_map-1));  
title(str)  
end  