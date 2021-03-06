#pragma once

// 頂点構造体
struct VERTEX_3D
{
    DirectX::XMFLOAT3 Position;
    DirectX::XMFLOAT3 Normal;
    DirectX::XMFLOAT4 Diffuse;
    DirectX::XMFLOAT2 TexCoord;
};


// 色構造体
struct COLOR
{
	COLOR(){}
	COLOR( float _r, float _g, float _b, float _a )
	{
		r = _r;
		g = _g;
		b = _b;
		a = _a;
	}

	float r;
	float g;
	float b;
	float a;
};

// マテリアル構造体
struct MATERIAL
{
	COLOR		Ambient;
	COLOR		Diffuse;
	COLOR		Specular;
	COLOR		Emission;
	float		Shininess;
	float		Dummy[3];//16bit境界用
};




// マテリアル構造体
struct DX11_MODEL_MATERIAL
{
	MATERIAL		Material;
	class Texture*	Texture;
};


// 描画サブセット構造体
struct DX11_SUBSET
{
	unsigned short	StartIndex;
	unsigned short	IndexNum;
	DX11_MODEL_MATERIAL	Material;
};

struct LIGHT
{
	DirectX::XMFLOAT4	Direction;
	COLOR		Diffuse;
	COLOR		Ambient;
};


class VertexBuffer;
class IndexBuffer;
class Texture;


class Renderer
{
private:
	static D3D_FEATURE_LEVEL       m_FeatureLevel;

	static ID3D11Device*           m_D3DDevice;
	static ID3D11DeviceContext*    m_ImmediateContext;
	static IDXGISwapChain*         m_SwapChain;
	static ID3D11RenderTargetView* m_RenderTargetView;
	static ID3D11DepthStencilView* m_DepthStencilView;



	static ID3D11VertexShader*     m_VertexShader;
	static ID3D11PixelShader*      m_PixelShader;
	static ID3D11InputLayout*      m_VertexLayout;
	static ID3D11Buffer*			m_WorldBuffer;
	static ID3D11Buffer*			m_ViewBuffer;
	static ID3D11Buffer*			m_ProjectionBuffer;
	static ID3D11Buffer*			m_MaterialBuffer;
	static ID3D11Buffer*			m_LightBuffer;

	static ID3D11DepthStencilState* m_DepthStateEnable;
	static ID3D11DepthStencilState* m_DepthStateDisable;


public:
	static void Init();
	static void Uninit();
	static void Begin();
	static void End();

	static void SetDepthEnable(bool Enable);
	static void SetWorldViewProjection2D();
	static void SetWorldMatrix(DirectX::XMMATRIX * WorldMatrix);
	static void SetViewMatrix(DirectX::XMMATRIX * ViewMatrix);
	static void SetProjectionMatrix(DirectX::XMMATRIX * ProjectionMatrix);
	static void SetMaterial(MATERIAL Material);
	static void SetLight(LIGHT Light);
	static void SetVertexBuffers(ID3D11Buffer* VertexBuffer);
	static void SetIndexBuffer(ID3D11Buffer* IndexBuffer);
	static void SetTexture(Texture* Texture);
	static void DrawIndexed(unsigned int IndexCount, unsigned int StartIndexLocation, int BaseVertexLocation);

	static ID3D11Device* GetDevice() 
	{
		return m_D3DDevice; 
	}
	static ID3D11DeviceContext* GetDeviceContext()
	{ 
		return m_ImmediateContext; 
	}
};
