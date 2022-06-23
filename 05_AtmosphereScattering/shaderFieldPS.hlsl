

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


// ライトバッファ
struct LIGHT
{
    float4 Direction;
    float4 Diffuse;
    float4 Ambient;
};

cbuffer LightBuffer : register(b1)
{
    LIGHT Light;
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
    float light = saturate(0.5 - dot(normal, Light.Direction.xyz) * 0.5);
    outDiffuse *= light;
    
    // 木目
    float color = fbm2(inTexCoord * 0.2, 2);
    color = sin(color * 200) * 0.5 + 0.5;
    float3 cgreen = float3(0.2, 0.7, 0.1);
    float3 cbeige = float3(0.9, 0.7, 0.4);
    // 線形補間
    outDiffuse.rgb = cgreen * color + cbeige * (1.0 - color);
    
    // 雪の表現
    float snowFog = -(inWorldPosition.y) * 1.0f;
    snowFog = saturate(snowFog);
    
    if(inWorldPosition.y > 5)
    {
        float3 snowColor = 1.0 + sin(fbm2(inTexCoord * 10, 5));
        outDiffuse.rgb += snowColor * (1.0 - snowFog) + float3(0.7, 0.7, 0.7) * snowFog;
    }
    
    // コントラストの調整
    if (color > 0.5)
    {
        outDiffuse.rgb = 1 / (1 + exp(-2 * (outDiffuse.rgb - 0.5)));
    }
       
    
    // 水中の高さフォグを計算
    float waterFog = -(inWorldPosition.y) * 1.0;
    waterFog = saturate(waterFog);
   
    outDiffuse.rgb = outDiffuse.rgb * (1.0 - waterFog) + float3(0.0, 0.1, 0.1) * waterFog;
    
    outDiffuse.a = 1.0;
}
