

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
    float4 Parameter;

}

// ���C�g�o�b�t�@
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
// �s�N�Z���V�F�[�_
//=============================================================================
void main( in  float4 inPosition		: SV_POSITION,
            in float4 inWorldPosition   : POSITION0,
			in  float4 inNormal			: NORMAL0,
			in  float4 inDiffuse		: COLOR0,
			in  float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    float animeOffset = Parameter.x * 0.2;
    inTexCoord.x += Parameter.x * 0.04;
    inTexCoord.y += Parameter.x * 0.02;
   
    float3 cloudColor = float3(1, 1, 1);
    float3 skyColor = float3(0.0, 0.5, 0.85);
    // �h���C�����[�s���O���e�N�X�`�����W���m�C�Y�ł��炷
    float noise = step(fbm2(inTexCoord + fbm2(inTexCoord + Parameter.x * 0.02, 2), 5) + 0.2, 0.1);
    noise = saturate(noise);
    outDiffuse.a = noise;
    
    // ���`���
    outDiffuse.rgb = cloudColor * noise + skyColor * (1.0 - noise);
    
    // �t�H�O
    float dist = distance(inWorldPosition.xyz, CameraPosition.xyz) * 0.01;
    outDiffuse.rgb = cloudColor * dist + outDiffuse.rgb * (1.0 - dist);
    dist = saturate(dist);
    
    outDiffuse.a *= 1.0 - dist;
}
