%�ο�http://www.aichengxu.com/view/2422137  
clear  
clc  
  
im = imread('cat.jpg');%��ȡͼƬ  
figure;imshow(im);%��ʾͼƬ  
[scores, maxlabel] = classification_demo(im, 0);%��ȡ�÷ֵڶ�������0ΪCPU��1ΪGPU  
maxlabel %�鿴����ǩ��˭  
figure;plot(scores);%�����÷����  
axis([0, 999, -0.1, 0.5]);%�����᷶Χ  
grid on %������  
  
fid = fopen('synset_words.txt', 'r');  
i=0;  
while ~feof(fid)  
    i=i+1;  
    lin = fgetl(fid);  
    lin = strtrim(lin);  
    if(i==maxlabel)  
        fprintf('the label of %d is %s\n',i,lin)  
        break  
    end  
end  