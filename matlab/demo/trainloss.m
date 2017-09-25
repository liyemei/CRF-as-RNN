clear;
clc;
solver=caffe.Solver('C:\caffe\caffe-master\examples\mnist\lenet_solver.prototxt'); %Э���ļ�����·��
%solver.solve()
iter=solver.iter()
train_net=solver.net
test_net=solver.test_nets(1)
close all;
hold on%��ͼ�õ� 
iter_ = solver.iter();%��ȡ��������
while iter_<10000
    solver.step(1);%һ��һ������
    iter_ = solver.iter();    %�õ���������
    loss=solver.net.blobs('loss').get_data();%ȡѵ������loss  
    if iter_==1
        loss_init = loss;
    else if(mod(iter_,1)==0)  %ÿ1�λ���һ����ʧ
        y_l=[loss_init loss];
        x_l=[iter_-1, iter_];     
        plot(x_l, y_l, 'r-');
        drawnow
        loss_init = loss;
        end
    end

    if mod(iter_, 100) == 0   %100��ȡһ��accuray
        accuracy=solver.test_nets.blobs('accuracy').get_data();%ȡ��֤����accuracy       
        if iter_/100 == 1
            accuracy_init = accuracy;
        else 
            x_l=[iter_-100, iter_];
            y_a=[accuracy_init accuracy];
            plot(x_l, y_a,'g-');
            drawnow
            accuracy_init=accuracy;
        end
    end
end
