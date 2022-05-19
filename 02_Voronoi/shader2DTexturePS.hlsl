
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
    #if 0
    float noise = (fbm2(inTexCoord, 3));
    outDiffuse.r = (sin(noise * 30) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.g = (sin(noise * 40) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.b = (sin(noise * 50) + (voronoi2(inTexCoord) + 1.0 * 0.5)) * 0.5;
    outDiffuse.rgb += voronoi2(inTexCoord);
    #else 
    
    // 紫のかっこいい
    float noise = (fbm2(inTexCoord, 3) + 1.0) * 0.5;
    outDiffuse.r = pow((noise + 1.0) * 0.5, 2) + voronoi2(inTexCoord);
    outDiffuse.g = 0; //step(noise, 0.5);
    outDiffuse.b = step(noise, 0.5) + voronoi2(inTexCoord);
    #endif

    #if 0
    // 白黒
    float color = fbm2(inTexCoord * 0.5, 3) * 0.5 + 0.5;
    outDiffuse.rbg = sin(color * 50.0);
    #endif
    
    
    // 木目
    #if 1
    float color = fbm2(inTexCoord * 0.2, 2);
    color = (sin(color * 200) * 0.5 + 0.5);
    //color = 1 / 1 + exp((color * 200) * 0.5 + 0.5);
    float3 cbrown = float3(0.7, 0.2, 0.1);
    float3 cbeige = float3(0.9, 0.7, 0.4);
    // 線形補間
    outDiffuse.rgb = cbrown * color + cbeige * (1.0 - color);
    
    // コントラスト
    //if (color > 0.5)
    //{
    //    outDiffuse.rgb = 1 / (1 + exp(-10 * (outDiffuse.rgb - 0.5)));
    //}
    
    #endif
    outDiffuse.a = 1.0;
}
