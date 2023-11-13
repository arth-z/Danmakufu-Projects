//================================================================
//���ݒ�l
//Texture
sampler sampler0_ : register(s0);

//--------------------------------
//�}�X�N�p�e�N�X�`��
//��ʕ�(�}�X�N�e�N�X�`���T�C�Y)
const float SCREEN_WIDTH = 640;
const float SCREEN_HEIGHT = 480;
texture textureMask_;
sampler samplerMask_ = sampler_state
{ 
	Texture = <textureMask_>;
};


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
PS_OUTPUT PsMask( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	//�e�N�X�`���̐F
	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	//���_�f�B�t�[�Y�F
	float4 colorDiffuse = In.diffuse;

	//����
	float4 color = colorTexture * colorDiffuse;
	Out.color = color;
	if(color.a > 0)
	{
		//--------------------------------
		//�}�X�N�p�̃e�N�X�`������F������擾
		//UV�ł̈ʒu�͉摜�t�@�C���̉����ƍ�������̊���
		//�Ⴆ�΁A640x480�̉摜�̈ʒu(320,240)��UV�ł�0.5,0.5�ɂȂ�B
		float2 maskUV;

		//�`��悩��}�X�N�p�e�N�X�`���̈ʒu��v�Z
		maskUV.x = In.vPos.x / SCREEN_WIDTH;
		maskUV.y = In.vPos.y / SCREEN_HEIGHT;
		float4 colorMask = tex2D(samplerMask_, maskUV);

		//�}�X�N��RGB�l��o�͌��ʂ̃��l�Ƃ��č�������
		Out.color.a = ( colorMask.r + colorMask.g + colorMask.b ) * 0.3333f * color.a;
	}


	return Out;
}


//================================================================
//--------------------------------
//technique
technique TecMask
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsMask();
	}
}

