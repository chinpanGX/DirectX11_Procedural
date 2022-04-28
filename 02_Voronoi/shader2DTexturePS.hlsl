
#include "shaderNoise.hlsl"


Texture2D		g_Texture : register(t0);
SamplerState	g_SamplerState : register(s0);



//=============================================================================
// �s�N�Z���V�F�[�_
//=============================================================================
void main( in  float4 inPosition		: SV_POSITION,
			in  float4 inNormal			: NORMAL0,
			in  float4 inDiffuse		: COLOR0,
			in  float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    // �X�g���C�v�͗l
    // fmod�@= x/y �̗]���Ԃ�
    // floor = �e�X�N�`�����W�𐮐��ŕԂ�
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0), 2);
    
    // �`�F�b�N��
    //outDiffuse.rgb = fmod(floor(inTexCoord.x * 2.0) + floor(inTexCoord.y * 2.0), 2);
    
    // �g��
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0 + sin(inTexCoord.x)), 2);
    
    // �i�j�R���H
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0) + sin(inTexCoord.x), 2);
    
    outDiffuse.rgb = voronoi2(inTexCoord);
    
    outDiffuse.a = 1.0;
}
