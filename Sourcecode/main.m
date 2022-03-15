% clear all;
% �������
I = rgb2gray(imread( '0x0002.png'));		% ��ȡͼ��
Filepath = 'Huffman_image.bin';         % �洢�ļ�·��

% ����
[ Code, Info] = Huffman_code( I, Filepath);
% ����
J = Huffman_decode( Filepath);

% ��ͼ
figure(1);
subplot(1,3,1);imshow(I);title('ԭʼͼ��');
subplot(1,3,2);imhist(I);title('ԭʼͼ��ֱ��ͼ');
subplot(1,3,3);imshow(J);title('����ͼ��');

% ��ʾ������Ϣ
disp( ['ƽ���볤Ϊ: Lavg = ',num2str( Info.ACLength)]);
disp( ['��Ϣ��Ϊ:   H(u) = ',num2str( Info.Entorpy)]);
disp( ['����Ч��Ϊ: �� =   ',num2str( Info.CodeRate)]);
disp( ['ѹ����Ϊ:   C =    ',num2str( Info.CompRate)]);