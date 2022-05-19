#include "shaderHeader.hlsli"

//=============================================================================
// ���_�V�F�[�_
//=============================================================================
void main( in  float4 inPosition		: POSITION0,
			in  float4 inNormal			: NORMAL0,
			in  float4 inDiffuse		: COLOR0,
			in  float2 inTexCoord		: TEXCOORD0,
			
			out float4 outPosition		: SV_POSITION,
			out float4 outNormal		: NORMAL0,
			out float4 outDiffuse		: COLOR0,
			out float2 outTexCoord		: TEXCOORD0 )
{
	matrix wvp;
	wvp = mul(World, View);
	wvp = mul(wvp, Projection);

	outPosition = mul(inPosition, wvp);

	outDiffuse = inDiffuse;

	outTexCoord = inTexCoord;
}

