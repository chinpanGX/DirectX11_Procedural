
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
    
    // �{���m�C�}
    //outDiffuse.rgb = voronoi2(inTexCoord);
    
    // �z���C�g�m�C�Y
    //outDiffuse.rgb = random2D(inTexCoord);
    
    // �o�����[�m�C�Y
    //outDiffuse.rgb = valueNoise2(inTexCoord);
    
    // �p�[�����m�C�Y
    //outDiffuse.rgb = (perlinNoise2(inTexCoord) + 1.0) * 0.5;
    
    // �t���N�^���p�[�����m�C�Y
    //outDiffuse.rgb = (fbm2(inTexCoord, 3) + 1.0) * 0.3;
    
    
    // ���p��
    // �Ȃ��Y��Ȃ��
    #if 0
    float noise = (fbm2(inTexCoord, 3));
    outDiffuse.r = (sin(noise * 30) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.g = (sin(noise * 40) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.b = (sin(noise * 50) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.rgb += voronoi2(inTexCoord);
    #else 
    
    // ���̂���������
    float noise = (fbm2(inTexCoord, 3) + 1.0) * 0.5;
    outDiffuse.r = pow((noise + 1.0) * 0.5, 2) + voronoi2(inTexCoord);
    outDiffuse.g = 0; //step(noise, 0.5);
    outDiffuse.b = step(noise, 0.5) + voronoi2(inTexCoord);
    #endif

    #if 0
    // ����
    float color = fbm2(inTexCoord * 0.5, 3) * 0.5 + 0.5;
    outDiffuse.rbg = sin(color * 50.0);
    #endif
    
    
    // �ؖ�
    #if 1
    float color = fbm2(inTexCoord * 0.2, 2);
    color = (sin(color * 200) * 0.5 + 0.5);
    //color = 1 / 1 + exp((color * 200) * 0.5 + 0.5);
    float3 cbrown = float3(0.7, 0.2, 0.1);
    float3 cbeige = float3(0.9, 0.7, 0.4);
    // ���`���
    outDiffuse.rgb = cbrown * color + cbeige * (1.0 - color);
    
    // �R���g���X�g
    //if (color > 0.5)
    //{
    //    outDiffuse.rgb = 1 / (1 + exp(-10 * (outDiffuse.rgb - 0.5)));
    //}
    
    #endif
    outDiffuse.a = 1.0;
}
