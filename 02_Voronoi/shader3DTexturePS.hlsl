#include "shaderHeader.hlsli"
#include "shaderNoise.hlsl"

Texture2D		g_Texture : register(t0);
SamplerState	g_SamplerState : register(s0);

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
        
    if (Parameter.x > 0)
    {
        float color = fbm3(inLocalPosition.xyz, 4);    
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
    else if (Parameter.y > 0)
    {
        float color = fbm3(inWorldPosition.xyz, 3);
        color = (sin(color * 100) * 0.5 + 0.5);
        float3 cwhite = float3(1.0, 1.0, 1.0) + 0.5;
        float3 cgray = float3(0.5, 0.5, 0.5);
    
        // 線形補間
        outDiffuse.rgb = cwhite * color + cgray * (1.0 - color);
        
        //ライティング
        float3 lightDir = float3(1.0, -1.0, 1.0);
        lightDir = normalize(lightDir);
    
        float light = 0.5 - dot(inNormal.xyz, lightDir) * 0.5;
        outDiffuse.rgb *= light;
   
        outDiffuse.a = 0.99;  
    }
    else
    {
        inLocalPosition.xy += Parameter.z;
        float color = fbm3(inLocalPosition.xyz, 3);
        color = sin(color * 50) * 0.5 + 0.5;
        float3 cwhite = float3(0.5, 1.0, 1.0);     
        float3 cblue = float3(0.1, 0.9, 0.9);
        
        // 線形補間
        float3 color3 = cwhite * color + cblue * (1.0 - color);
         
        outDiffuse.rgb = sin(color3 * 15) + 1;
        outDiffuse.gb = color3;
        
        //ライティング
        float3 lightDir = float3(1.0, -1.0, 1.0);
        lightDir = normalize(lightDir);
        
        float light = 0.5 - dot(inNormal.xyz, lightDir) * 0.5;
        outDiffuse.rgb *= light;
   
        outDiffuse.a = 1.0;
    }
}
