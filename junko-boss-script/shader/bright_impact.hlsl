//================================================================
//Texture
sampler sampler0_ : register(s0);

float customR_;
float customG_; 
float customB_; 

//================================================================
//--------------------------------
struct PS_INPUT
{
	float4 diffuse : COLOR0;  
	float2 texCoord : TEXCOORD0; 
	float2 vPos : VPOS; 
};

//--------------------------------
struct PS_OUTPUT
{
    float4 color : COLOR0; 
};

PS_OUTPUT PsSaturateRed( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	float4 colorDiffuse = In.diffuse;

	float4 color = colorTexture * colorDiffuse;

	Out.color.r = color.r * 2.5f;
    Out.color.g = color.g * 1.4f;
    Out.color.b = color.b * 1.4f;
	Out.color.a = color.a;

	return Out;
}

PS_OUTPUT PsSaturateBlue( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	float4 colorDiffuse = In.diffuse;

	float4 color = colorTexture * colorDiffuse;

	Out.color.r = color.r * 1.4f;
    Out.color.g = color.g * 1.4f;
    Out.color.b = color.b * 2.0f;
	Out.color.a = color.a;

	return Out;
}

PS_OUTPUT PsSaturatePurple( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	float4 colorDiffuse = In.diffuse;

	float4 color = colorTexture * colorDiffuse;

	Out.color.r = color.r * 2.0f;
    Out.color.g = color.g * 1.4f;
    Out.color.b = color.b * 2.0f;
	Out.color.a = color.a;

	return Out;
}

PS_OUTPUT PsSaturateCustom( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float4 colorTexture = tex2D(sampler0_, In.texCoord);

	float4 colorDiffuse = In.diffuse;

	float4 color = colorTexture * colorDiffuse;

	Out.color.r = color.r * customR_;
    Out.color.g = color.g * customG_;
    Out.color.b = color.b * customB_;
	Out.color.a = color.a;

	return Out;
}


//================================================================
//--------------------------------
//technique
technique TecSaturateRed
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsSaturateRed();
	}
}

technique TecSaturateBlue
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsSaturateBlue();
	}
}

technique TecSaturatePurple
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsSaturatePurple();
	}
}

technique TecSaturateCustom
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsSaturateCustom();
	}
}