

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
    float4 Parameter;

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
    
    float animeOffset = Parameter.x * 0.2;
    inTexCoord.y += Parameter.x;
    float vecoffset = 0.002;
    // 法線ベクトルを求める
    float dz = fbm2((inTexCoord - float2(0.0, vecoffset)) * 0.5 + fbm2(inTexCoord + Parameter.x * 0.2, 2), 5, animeOffset) * 0.2 - fbm2((inTexCoord + float2(0.0, vecoffset)) * 0.5 + fbm2(inTexCoord + Parameter.x * 0.2, 2), 5, animeOffset) * 0.2;
    float dx = fbm2((inTexCoord - float2(vecoffset, 0.0)) * 0.5 + fbm2(inTexCoord + Parameter.x * 0.2, 2), 5, animeOffset) * 0.2 - fbm2((inTexCoord + float2(vecoffset, 0.0)) * 0.5 + fbm2(inTexCoord + Parameter.x * 0.2, 2), 5, animeOffset) * 0.2;
    float3 normal = cross(float3(0, dz, vecoffset * 2), float3(vecoffset * 2, -dx, 0));
    
    normal = normalize(normal);
    
    float3 eyev = inWorldPosition.xyz - CameraPosition.xyz;
    eyev = normalize(eyev);
    
    // フレネルの近似式
    float fresnel = saturate(1.0 + dot(eyev, normal));
    fresnel = 0.05 + (1.0 - 0.05) * pow(fresnel, 5);
    
     // レイリー散乱
    float3 vy = float3(0, 1, 0);
    
    float atm = saturate(1.0 - dot(-Light.Direction.xyz, vy));
    float3 rcolor = 1.0 - atm * 1.0;
    
    float ld = 0.5 - dot(Light.Direction.xyz, eyev) * 0.5;
    
    float3 baseColor = float3(0.0, 0.55, 0.85) - atm * ld * 1.0;
   
    outDiffuse.rgb = baseColor * (1.0 - fresnel) + float3(0.9, 0.95, 1.0) * fresnel;

    outDiffuse.a = fresnel;
}
