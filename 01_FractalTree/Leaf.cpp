#include "Leaf.h"
#include "Random.h"

void Leaf::Init()
{
	VERTEX_3D vertex[4];

	vertex[0].Position = DirectX::XMFLOAT3(-1.0f, 1.0f, 0.0f);
	vertex[0].Normal = DirectX::XMFLOAT3(0.0f, 1.0f, 0.0f);
	vertex[0].Diffuse = DirectX::XMFLOAT4(0.0f, 0.8f, 0.2f, 1.0f);
	vertex[0].TexCoord = DirectX::XMFLOAT2(0.0f, 0.0f);

	vertex[1].Position = DirectX::XMFLOAT3(1.0f, 1.0f, 0.0f);
	vertex[1].Normal = DirectX::XMFLOAT3(0.0f, 1.0f, 0.0f);
	vertex[1].Diffuse = DirectX::XMFLOAT4(0.0f, 0.8f, 0.2f, 1.0f);
	vertex[1].TexCoord = DirectX::XMFLOAT2(10.0f, 0.0f);

	vertex[2].Position = DirectX::XMFLOAT3(-1.0f, -1.0f, 0.0f);
	vertex[2].Normal = DirectX::XMFLOAT3(0.0f, 1.0f, 0.0f);
	vertex[2].Diffuse = DirectX::XMFLOAT4(0.0f, 0.8f, 0.2f, 1.0f);
	vertex[2].TexCoord = DirectX::XMFLOAT2(0.0f, 10.0f);

	vertex[3].Position = DirectX::XMFLOAT3(1.0f, -1.0f, 0.0f);
	vertex[3].Normal = DirectX::XMFLOAT3(0.0f, 1.0f, 0.0f);
	vertex[3].Diffuse = DirectX::XMFLOAT4(0.0f, 0.8f, 0.2f, 1.0f);
	vertex[3].TexCoord = DirectX::XMFLOAT2(10.0f, 10.0f);

	
	D3D11_BUFFER_DESC bd;
	ZeroMemory( &bd, sizeof(bd) );
	bd.Usage = D3D11_USAGE_DEFAULT;
	bd.ByteWidth = sizeof( VERTEX_3D ) * 4;
	bd.BindFlags = D3D11_BIND_VERTEX_BUFFER;
	bd.CPUAccessFlags = 0;

	D3D11_SUBRESOURCE_DATA sd;
	ZeroMemory(&sd, sizeof(sd));
	sd.pSysMem = vertex;

	Renderer::GetDevice()->CreateBuffer(&bd, &sd, &m_VertexBuffer);

	SetTransform();
}

void Leaf::Uninit()
{
	m_VertexBuffer->Release();
}

void Leaf::Update()
{
}

void Leaf::Draw()
{
	
}

void Leaf::Draw(const DirectX::XMMATRIX& World)
{
	// 頂点バッファ設定
	UINT stride = sizeof(VERTEX_3D);
	UINT offset = 0;
	Renderer::GetDeviceContext()->IASetVertexBuffers(0, 1, &m_VertexBuffer, &stride, &offset);

	// テクスチャ設定
	//Renderer::SetTexture(NULL);

	// マトリクス設定
	DirectX::XMMATRIX world;
	world = DirectX::XMMatrixScaling(m_Scale.x, m_Scale.y, m_Scale.z);
	world *= DirectX::XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	world *= DirectX::XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);
	world *= World;
	Renderer::SetWorldMatrix(&world);

	// プリミティブトポロジ設定
	Renderer::GetDeviceContext()->IASetPrimitiveTopology(D3D11_PRIMITIVE_TOPOLOGY_TRIANGLESTRIP);

	// ポリゴン描画
	Renderer::GetDeviceContext()->Draw(4, 0);
}

void Leaf::SetTransform()
{
	m_Position = DirectX::XMFLOAT3(0.0f, 2.0f, 0.0f);

	// デグリー角を乱数で出す
	int x = Random::Rand_R(0, 180);
	int y = Random::Rand_R(0, 180);

	// デグリー角をラジアン角へ変換
	m_Rotation = DirectX::XMFLOAT3(x * 3.14f / 180.0f, y * 3.14f / 180.0f, 0.0f);

	m_Scale = DirectX::XMFLOAT3(1.0f, 1.0f, 1.0f);
}
