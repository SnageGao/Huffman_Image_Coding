% ���룺Image [m*n (double)] ΪĿ��ͼ����Ϊ�ڰ�ͼ��
%       Filepath (String) Ϊ�����ļ�����·��
% �����Code [](uint8) Ϊ�������������������Ϊuint8������
%       Info (struct) Ϊ����õ��ı����ָ�������ֵ�ṹ��
% �������ܣ��������ͼ����й������䳤����ѹ������������д��·���ļ���
%           �����ر������ܷ��������
function [ Code, Info] = Huffman_code( Image, Filepath)
[ H, W] = size(Image);


% ����ֱ��ͼ������
hist = imhist(Image) / (H*W);           % ����ͼ��ĸ���ֱ��ͼ
[ proba, index] = sort( hist);          % �����С�������򲢷�������λ��
Array_index = index( proba~=0 );
Array_proba = proba( proba~=0 );        % �������еķ���ֵ��������
Array_index = num2cell( Array_index);   % ������ת��ΪԪ������


% ��������
Table = cell( 256, 1);                  % ��������
while length( Array_proba)>1    % ����ѭ����ֱ������ֱ���������Ϊһ����
    index1 = Array_index{1};            
    index2 = Array_index{2};            % ��õ�ǰ�ĸ���������С����������Ԫ��
    Table( index1) = cellfun(@(x) [x,uint8(0)], Table(index1), 'UniformOutput',false);
    Table( index2) = cellfun(@(x) [x,uint8(1)], Table(index2), 'UniformOutput',false);
            % �ֱ�������������Ԫ����ÿ��Ԫ�ض�Ӧ�ı������к�߼��ϡ�1����0��
    
    Array_proba = [sum(Array_proba(1:2));Array_proba(3:end)];
    Array_index = {[index1,index2],Array_index{3:end}};
            % ����С������������ӣ�����Ӧ�����ϲ���һ��Ԫ����
    
    [ Array_proba, order] = sort( Array_proba);
    Array_index = Array_index( order);
            % �Դ�����������������
end
Table = cellfun(@(x) x(end:-1:1), Table, 'UniformOutput', false);
        % ���õ��ı������з�ת������ǰ׺��


% �����滻
Code_uint8 = [];
for Pixel = Image(:)    % ��ͼ��һά����Ȼ����һ�滻
    Code_uint8 = [ Code_uint8, Table{ Pixel+1}];
end
Code_str = getbytes( Code_uint8);   % �����ɵ�bit���ϲ���Ϊbyte��uint8������


% �����ļ�ͷ
Code_table = [];
Table_length = zeros(1,256);
for index = 1:256           % ������������ļ�ͷ����ʽΪ [ ����1���� ����1][ ����2���� ����2]����
    Table_length( index) = length( Table{ index});
    value = getbytes( Table{ index});
    Code_table = [Code_table, uint8( Table_length(index)), value];
end
length_head = uint16( length( Code_table)+6);   % �����ļ�ͷ�ĳ���
Code_info = uint8([ bitshift(length_head,-8), mod(length_head,256)]);
Code_H = uint8([ bitshift(H,-8), mod(H,256)]);
Code_W = uint8([ bitshift(W,-8), mod(W,256)]);  % �����ȡ�ͼƬ�ĳ�����Ϣת��Ϊ6��uint8
Code_head = [ Code_info, Code_H, Code_W, Code_table];   % �ļ�ͷ�ϲ�


% �ϲ����벢д���ļ�
Code = [Code_head, Code_str];   % ���ļ�ͷ�ͱ������ݺϲ�
File = fopen( Filepath,'w');    % ��дģʽ��������ļ�
fwrite( File, Code, 'uint8');   % ��uint8����ʽд���ļ�
fclose( File);


% �����������
Info.ACLength = Table_length * hist;    % ����ƽ���볤
Info.Entorpy = -log2( proba( proba~=0 )')* proba( proba~=0 );    % ������Ϣ��
Info.CodeRate = Info.Entorpy / Info.ACLength;    % �������Ч��
Info.CompRate = Info.ACLength / 8;      % ����ѹ����





% ���룺Uint [] (uint8) Ϊbit���У�ÿһ����Ϊ1����0
% �����String [] (uint8) Ϊbyte���У�ÿһ������ΧΪ0~255
% �������ܣ��������bit�����ܼ�����ÿ8�����ϳ�һ����������byte���С�
function String = getbytes( Uint)

bit_num = length( Uint);        % ����bit���г���
byte_num = ceil( bit_num / 8);  % ����byte���г���
Uint = [Uint, uint8(ones(1,byte_num*8-bit_num))];   % ��bit���г��Ȳ�Ϊ8��������
String = [];
for point = 0: byte_num-1       % ����ѭ��
    charac = uint8(0);
    for bit = 1: 8          % ȡ��8��������ǰ��˳��ϳ�һ����
        index = point*8 + bit;
        flag = bitshift( Uint(index), 8-bit, 'uint8');
        charac = bitor( charac, flag, 'uint8');
    end
    String( point+1) = charac;  % ���������������
end
