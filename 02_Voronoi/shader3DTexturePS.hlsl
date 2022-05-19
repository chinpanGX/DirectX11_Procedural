

#include "shaderNoise.hlsl"

Texture2D		g_Texture : register(t0);
SamplerState	g_SamplerState : register(s0);


// 定数バッファ
cbuffer ConstatntBuffer : register(b0)
{
    matrix World;
    matrix View;
    matrix Projection;

    float4 CameraPosition;
}

//=============================================================================
// ピクセルシェーダ
//=============================================================================
void main(  in float4 inPosition		: SV_POSITION,
            in float4 inWorldPosition   : POSITION0,
			in float4 inLocalPosition   : POSITION1,
			in float4 inNormal			: NORMAL0,
			in float4 inDiffuse		    : COLOR0,
			in float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    
    //outDiffuse.rgb = voronoi2(inTexCoord * 50);
    
    float color = fbm2(inTexCoord * 5.0, 2);
    color = (sin(color * 50) * 0.5 + 0.5);
    float3 cbrown = float3(0.7, 0.2, 0.1);
    float3 cbeige = float3(0.9, 0.7, 0.4);
    // 線形補間
    outDiffuse.rgb = cbrown * color + cbeige * (1.0 - color);
    
    
    //ライティング
    float3 lightDir = float3(1.0, -1.0, 1.0);
    lightDir = normalize(lightDir);
    
    float light = 0.5 - dot(inNormal.xyz, lightDir) * 0.5;
    outDiffuse.rgb *= light;
   
    outDiffuse.a = 1.0;
  
}
