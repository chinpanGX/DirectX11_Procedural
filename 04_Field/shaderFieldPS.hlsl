

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
void main( in  float4 inPosition		: SV_POSITION,
            in float4 inWorldPosition   : POSITION0,
			in  float4 inNormal			: NORMAL0,
			in  float4 inDiffuse		: COLOR0,
			in  float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    //outDiffuse.rgb = fbm2(inTexCoord, 3) * 0.5 + 0.5;
    
    float vecoffset = 0.002;
    
    // 法線ベクトルを求める
    float dx = fbm2((inTexCoord - float2(vecoffset, 0.0)) * 0.05, 10) * 10.0 - fbm2((inTexCoord + float2(vecoffset, 0.0)) * 0.05, 10) * 10.0;
    float dz = fbm2((inTexCoord - float2(0.0, vecoffset)) * 0.05, 10) * 10.0 - fbm2((inTexCoord + float2(0.0, vecoffset)) * 0.05, 10) * 10.0;
    
    float3 normal = cross(float3(0, dz, vecoffset * 2), float3(vecoffset * 2, -dx, 0));
    normal = normalize(normal.xyz);
    
    //ライティング
    float3 lightDir = float3(1.0, -1.0, 1.0);
    lightDir = normalize(lightDir);
    
    float light = saturate(0.5 - dot(normal, lightDir) * 0.5);
    outDiffuse *= light;
    /*
    float noise = (fbm2(inTexCoord * 0.5, 3));
    outDiffuse.r = (sin(noise * 30) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.g = (sin(noise * 40) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.b = (sin(noise * 50) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.rgb += voronoi2(inTexCoord * 0.5);
    outDiffuse.a = 1.0;
    */
    // 木目
    float color = fbm2(inTexCoord * 0.2, 2);
    color = (sin(color * 200) * 0.5 + 0.5);
    //color = 1 / 1 + exp((color * 200) * 0.5 + 0.5);
    float3 cbrown = float3(0.7, 0.2, 0.1);
    float3 cbeige = float3(0.9, 0.7, 0.4);
    // 線形補間
    outDiffuse.rgb = cbrown * color + cbeige * (1.0 - color);
    
       // フォグ
    float dist = distance(inWorldPosition.xyz, CameraPosition.xyz) * 0.01;
    outDiffuse.rgb = float3(0.2, 0.2, 0.2) * dist + outDiffuse.rgb * (1.0 - dist);
    
    // コントラスト
    if (color > 0.5)
    {
        outDiffuse.rgb = 1 / (1 + exp(-2 * (outDiffuse.rgb - 0.5)));
    }
    outDiffuse.a = 1.0;
}
