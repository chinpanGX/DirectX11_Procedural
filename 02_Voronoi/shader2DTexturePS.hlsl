
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
    
    // ボロノイ図
    //outDiffuse.rgb = voronoi2(inTexCoord);
    
    // ホワイトノイズ
    //outDiffuse.rgb = random2D(inTexCoord);
    
    // バリューノイズ
    //outDiffuse.rgb = valueNoise2(inTexCoord);
    
    // パーリンノイズ
    //outDiffuse.rgb = (perlinNoise2(inTexCoord) + 1.0) * 0.5;
    
    // フラクタルパーリンノイズ
    //outDiffuse.rgb = (fbm2(inTexCoord, 3) + 1.0) * 0.3;
    
    
    // 応用編
    // なんか綺麗なやつ
    #if 1
    float noise = (fbm2(inTexCoord, 3));
    outDiffuse.r = (sin(noise * 30) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.g = (sin(noise * 40) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.b = (sin(noise * 50) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.rgb += voronoi2(inTexCoord);
    
    // 紫のかっこいい
    #else
    float noise = (fbm2(inTexCoord, 3) + 1.0) * 0.5;
    outDiffuse.r = pow((noise + 1.0) * 0.5, 2) + voronoi2(inTexCoord);
    outDiffuse.g = 0; //step(noise, 0.5);
    outDiffuse.b = step(noise, 0.5) + voronoi2(inTexCoord);
    
    #endif

    outDiffuse.a = 1.0;
}
