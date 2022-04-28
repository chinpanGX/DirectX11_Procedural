
#include "shaderNoise.hlsl"


Texture2D		g_Texture : register(t0);
SamplerState	g_SamplerState : register(s0);



//=============================================================================
// ピクセルシェーダ
//=============================================================================
void main( in  float4 inPosition		: SV_POSITION,
			in  float4 inNormal			: NORMAL0,
			in  float4 inDiffuse		: COLOR0,
			in  float2 inTexCoord		: TEXCOORD0,

			out float4 outDiffuse		: SV_Target )
{
    // ストライプ模様
    // fmod　= x/y の余りを返す
    // floor = テスクチャ座標を整数で返す
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0), 2);
    
    // チェック柄
    //outDiffuse.rgb = fmod(floor(inTexCoord.x * 2.0) + floor(inTexCoord.y * 2.0), 2);
    
    // 波線
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0 + sin(inTexCoord.x)), 2);
    
    // ナニコレ？
    //outDiffuse.rgb = fmod(floor(inTexCoord.y * 2.0) + sin(inTexCoord.x), 2);
    
    outDiffuse.rgb = voronoi2(inTexCoord);
    
    outDiffuse.a = 1.0;
}
