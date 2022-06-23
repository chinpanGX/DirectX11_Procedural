

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
void main(in float4 inPosition : SV_POSITION,
            in float4 inWorldPosition : POSITION0,
			in float4 inNormal : NORMAL0,
			in float4 inDiffuse : COLOR0,
			in float2 inTexCoord : TEXCOORD0,

			out float4 outDiffuse : SV_Target)
{
    float3 diffuse = 0.0f;
    
    // カメラからスカイドームまでの距離を計算し、大気の距離を求める
    float dist = distance(inWorldPosition.xyz, CameraPosition.xyz);
    
    // 視線ベクトルを計算し、正規化する
    float3 eye = inWorldPosition.xyz - CameraPosition.xyz;
    eye = normalize(eye);
   
    // ミー散乱
    float m = saturate(-dot(Light.Direction.xyz, eye));
    m = pow(m, 50); // 太陽光の広がりを求める
    diffuse += m * dist * 0.003;
    
    // レイリー散乱
    float3 vy = float3(0, 1, 0);
    // レイリー散乱によって起こる減衰率
    const float3 attenuaterate = float3(0.5, 0.8, 1.0);
    
    float atm = saturate(1.0 - dot(-Light.Direction.xyz, vy));
    float3 rcolor = 1.0 - attenuaterate * atm * 1.0;

    float ld = 0.5 - dot(Light.Direction.xyz, eye) * 0.5;
    diffuse += rcolor * dist * ld * attenuaterate * 0.004;
    
    outDiffuse.rgb = diffuse;
    outDiffuse.a = 1;
}
