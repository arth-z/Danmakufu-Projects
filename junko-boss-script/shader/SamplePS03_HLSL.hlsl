
//================================================================
//���ݒ�l
//Texture
sampler sampler0_ : register(s0);

//--------------------------------
//�䂪�ݐ����p�p�����[�^
static const float RENDER_WIDTH = 1024; //�����_�����O�e�N�X�`���̕�
static const float RENDER_HEIGHT = 1024; //�����_�����O�e�N�X�`���̍���

float frame_; //�t���[����
float enemyX_; //�G�̈ʒuX
float enemyY_; //�G�̈ʒuY
float waveRadius_; //�G�t�F�N�g�̔��a


//================================================================
//--------------------------------
//�s�N�Z���V�F�[�_���͒l
struct PS_INPUT
{
	float4 diffuse : COLOR0;  //�f�B�t���[�Y�F
	float2 texCoord : TEXCOORD0; //�e�N�X�`�����W
	float2 vPos : VPOS; //�`�����W
};

//--------------------------------
//�s�N�Z���V�F�[�_�o�͒l
struct PS_OUTPUT
{
    float4 color : COLOR0; //�o�͐F
};


//================================================================
// �V�F�[�_
//--------------------------------
//�s�N�Z���V�F�[�_
PS_OUTPUT PsWave( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	//--------------------------------
	//��炬��v�Z
	float dist2 = pow(In.vPos.x-enemyX_ ,2) + pow(In.vPos.y-enemyY_ ,2);
	float dist = sqrt(dist2);
	float sinTheta = (In.vPos.y - enemyY_) / dist;
	float cosTheta = (In.vPos.x - enemyX_) / dist;

	//�c�ݍ쐬�p��sin�Ɏg�p����p�x�p�����[�^
	float angle = In.vPos.y - enemyY_ + In.vPos.x - enemyX_ + frame_;
	angle = radians(angle);

	//�Y���s�N�Z���̘c�݂̔��a��v�Z
	//�G�t�F�N�g���a��1/16��ő�̘c�ݕ��Ƃ���
	float waveRadius = waveRadius_ + waveRadius_/16 * (-1 + sin(angle));

	//���S���狗���������قǉe�������������
	float powerRatio = (waveRadius - dist) / waveRadius;
	if(powerRatio < 0){powerRatio = 0;}

	//�F����擾����ʒu�̃o�C�A�X�l
	float biasRadius = waveRadius * powerRatio;
	float biasX = biasRadius * cosTheta;
	float biasY = biasRadius * sinTheta;

	//�e�N�X�`���̐F����擾����ʒu
	float2 texUV;
	texUV.x = -biasX / RENDER_WIDTH + In.texCoord.x;
	texUV.y = -biasY / RENDER_HEIGHT + In.texCoord.y;


	//--------------------------------
	//�e�N�X�`���̐F
	float4 colorTexture = tex2D(sampler0_, texUV);

	//���_�f�B�t�[�Y�F
	float4 colorDiffuse = In.diffuse;

	//����
	float4 color = colorTexture * colorDiffuse;

	//�F��Ԃ��ۂ��ω�������
	if(powerRatio > 0)
	{
		color.g = color.g * (1 - powerRatio);
		color.b = color.b * (1 - powerRatio);
	}

	Out.color = color;

	return Out;
}


//================================================================
//--------------------------------
//technique
technique TecWave
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsWave();
	}
}

