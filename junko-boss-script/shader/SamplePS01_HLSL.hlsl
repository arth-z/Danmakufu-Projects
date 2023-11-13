//================================================================
//Texture
sampler sampler0_ : register(s0);

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
PS_OUTPUT PsMonotone( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	//�e�N�X�`���̐F
	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	//���_�f�B�t�[�Y�F
	float4 colorDiffuse = In.diffuse;

	//����
	float4 color = colorTexture * colorDiffuse;

	//���m�g�[���̌v�Z
	Out.color.rgb = ( color.r + color.g + color.b ) * 0.3333f;
	Out.color.a = color.a;

	return Out;
}


//================================================================
//--------------------------------
//technique
technique TecMonotone
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsMonotone();
	}
}

