% ���룺Filepath (String) Ϊ�����ļ�·��
% �����Image_final [m*n (double)] Ϊ��ԭͼ����Ϊ�ڰ�ͼ��
% �������ܣ���·����Ӧ�ļ����й������䳤���룬��ԭ��ͼ��
function Image_final = Huffman_decode( Filepath)

% ��ȡ�ļ�
File = fopen( Filepath,'r');    % �Զ�ģʽ���ļ�
Code = fread( File,'*uint8');   % ��uint8�����ļ�����
fclose( File);


% ��ȡ�ļ�ͷ�õ�ͼ����Ϣ
Code_info = double( Code(1:6));     % ����ȡǰ6����
head_length = Code_info(1)*256 + Code_info(2);  % �õ��ļ�ͷ����
Image_H =  Code_info(3)*256 + Code_info(4);     % �õ�ͼ��߶�
Image_W =  Code_info(5)*256 + Code_info(6);     % �õ�ͼ����


% ���ļ�ͷ�л�ȡ�����
Code_table = Code( 7: head_length); % �����ļ�ͷ������ȡ����������Ϣ
Uint_table = repmat( uint8(0), 1, length( Code_table)*8);
for index = 0: length( Code_table)-1
    Uint_table( index*8 + (1:8)) = bitget( Code_table(index+1),(8:-1:1));
end             % �������byte��λչ��Ϊbit����

% ���ɽ����
Table_inverse = uint8([]);  % ��������
point = 1;        % ����ָ��
value = uint8(1); % ���������ֵ
while point < length( Code_table)
    len = double( Code_table( point));      % ��ȡ��ǰֵ��Ӧ���ֵĳ���
    table = Uint_table( point*8+1: point*8+len);    % �������ֳ�����ȡ����
    index = double( [1,table]) * (2.^(len:-1:0))';  % �������ֵõ����������
    Table_inverse( index) = value;          % ��������Ӧλ�ø�ֵ
    
    point = point + ceil( len/8) + 1;   % ָ��ƽ��
    value = value + 1;                  % ֵ�Լ�
end

% �ӱ��������л�ȡͼ��
Code_image = Code( head_length+1: end); % ��ȡ��������
Uint_image = repmat( uint8(0), 1, length( Code_image)*8);
for index = 0: length( Code_image)-1
    Uint_image( index*8 + (1:8)) = bitget( Code_image(index+1),(8:-1:1));
end             % ��ͼ��byte��λչ��Ϊbit����

Image = repmat( uint8(0), 1, Image_H*Image_W);  % ����ͼ��һά����
im_point = 1;   % ����ָ��
code_value = 1; % ��������ֵ
for bit_point = 1: length( Uint_image)
    if im_point > Image_H*Image_W
        break   % ���ͼ��������������˳�
    end
    code_value = code_value * 2 + double( Uint_image( bit_point));
            % ��һλbit���ӵ����ֺ���
    im_value = Table_inverse( code_value);  % �ӽ�����ȡ����������Ӧ��ֵ
    if im_value ~= 0
        Image( im_point) = im_value - 1;
        im_point = im_point + 1;
        code_value = 1;
        % �����Ϊ0��������ֶ�ȡ��ϣ���ֵ��䵽ͼ����󣬲�����ָ�������
    end
        % ���Ϊ0�������ȡbit
end

Image_final = reshape( Image, Image_H, Image_W);    % ��һάͼ�θ��ݳ����ά��
