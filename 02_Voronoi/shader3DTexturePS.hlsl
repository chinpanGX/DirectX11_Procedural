

#include "shaderNoise.hlsl"

Texture2D		g_Texture : register(t0);
SamplerState	g_SamplerState : register(s0);


// �萔�o�b�t�@
cbuffer ConstatntBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;

    float4 CameraPosition;
}

//=============================================================================
// �s�N�Z���V�F�[�_
//=============================================================================
void main(  in float4 inPosition		: SV_POSITION,
            in float4 inWorldPosition   : POSITION0,
			in float4 inLocalPosition   : POSITION1,
			in float4 inNormal			: NORMAL0,
			in float4 inDiffuse		    : COLOR0,
			in float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    /*
    outDiffuse.rgb = 1.0;
    
    
    
    //���C�e�B���O
    float3 lightDir = float3(1.0, -1.0, 1.0);
    lightDir = normalize(lightDir);
    
    float light = 0.5 - dot(inNormal.xyz, lightDir) * 0.5;
    outDiffuse.rgb *= light;
    */
    
    outDiffuse.rgb = voronoi2(inTexCoord * 50);
	outDiffuse.a = 1.0;
  
}
