

sampler sampler0_ : register(s0);

static const float RENDER_WIDTH = 1024; 
static const float RENDER_HEIGHT = 1024;

float frame_; 
float enemyX_;
float enemyY_; 
float waveRadius_; 

struct PS_INPUT
{
	float4 diffuse : COLOR0;  
	float2 texCoord : TEXCOORD0; 
	float2 vPos : VPOS; 
};

struct PS_OUTPUT
{
    float4 color : COLOR0; 
};


PS_OUTPUT PsWave( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float dist2 = pow(In.vPos.x-enemyX_ ,2) + pow(In.vPos.y-enemyY_ ,2);
	float dist = sqrt(dist2);
	float sinTheta = (In.vPos.y - enemyY_) / dist;
	float cosTheta = (In.vPos.x - enemyX_) / dist;

	float angle = In.vPos.y - enemyY_ + In.vPos.x - enemyX_ + frame_;
	angle = radians(angle);

	float waveRadius = waveRadius_ + waveRadius_/16 * (-1 + sin(angle));

	float powerRatio = (waveRadius - dist) / waveRadius;
	if(powerRatio < 0){powerRatio = 0;}

	float biasRadius = waveRadius * powerRatio;
	float biasX = biasRadius * cosTheta;
	float biasY = biasRadius * sinTheta;

	float2 texUV;
	texUV.x = -biasX / RENDER_WIDTH + In.texCoord.x;
	texUV.y = -biasY / RENDER_HEIGHT + In.texCoord.y;

	float4 colorTexture = tex2D(sampler0_, texUV);

	float4 colorDiffuse = In.diffuse;

	float4 color = colorTexture * colorDiffuse;

	if(powerRatio > 0)
	{
		color.g = color.g * (1 - powerRatio);
		color.b = color.b * (1 - powerRatio);
	}

	color.a=1;
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

