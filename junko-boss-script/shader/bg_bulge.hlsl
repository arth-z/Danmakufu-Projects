

sampler sampler0_ : register(s0);

static const float RENDER_WIDTH = 1024; 
static const float RENDER_HEIGHT = 1024;

float frame_; 
float centerX_;
float centerY_; 
float pinchRadius_; 

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


PS_OUTPUT PsBulge( PS_INPUT In ) : COLOR0
{
	PS_OUTPUT Out;

	float2 resolution = (RENDER_WIDTH, RENDER_HEIGHT); // get the center-points
	float2 center = (centerX_, centerY_);

    float2 p = In.vPos.xy / resolution.xy - 0.5;
    
    // Convert Cartesian coordinates to polar coordinates
    float r = length(p);
    float a = atan2(p.y, p.x);
    
    // Distort the polar coordinates
    r = sqrt(r) * 2.0; // bulge effect
					 // take a sqrt to pinch
  
    // Convert polar coordinates back to Cartesian coordinates
    p = r * float2(cos(a), sin(a));
    
	// set output
	float4 colorTexture = tex2D(sampler0_, p + 0.5);
	float4 colorDiffuse = In.diffuse;
	float4 color = colorTexture * colorDiffuse;

	Out.color = color;


	// return output
	return Out;
}


//================================================================
//--------------------------------
//technique
technique TecBulge
{
	pass P0
	{
		PixelShader = compile ps_3_0 PsBulge();
	}
}

