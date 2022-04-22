
#include "main.h"
#include "renderer.h"
#include "game_object.h"
#include "camera.h"





void Camera::Init()
{

	m_Position = DirectX::XMFLOAT3( 0.0f, 9.0f, -10.0f );
	m_Rotation = DirectX::XMFLOAT3( 0.5f, 0.0f, 0.0f );


	m_Viewport.left = 0;
	m_Viewport.top = 0;
	m_Viewport.right = SCREEN_WIDTH;
	m_Viewport.bottom = SCREEN_HEIGHT;

}


void Camera::Uninit()
{


}


void Camera::Update()
{


}



void Camera::Draw()
{

	DirectX::XMMATRIX	m_ViewMatrix;
	DirectX::XMMATRIX	m_InvViewMatrix;
	DirectX::XMMATRIX	m_ProjectionMatrix;



	// ビューポート設定
	D3D11_VIEWPORT dxViewport;
	dxViewport.Width = (float)(m_Viewport.right - m_Viewport.left);
	dxViewport.Height = (float)(m_Viewport.bottom - m_Viewport.top);
	dxViewport.MinDepth = 0.0f;
	dxViewport.MaxDepth = 1.0f;
	dxViewport.TopLeftX = (float)m_Viewport.left;
	dxViewport.TopLeftY = (float)m_Viewport.top;

	Renderer::GetDeviceContext()->RSSetViewports(1, &dxViewport);



	// ビューマトリクス設定
	m_InvViewMatrix = DirectX::XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	m_InvViewMatrix *= DirectX::XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);

	DirectX::XMVECTOR det;
	m_ViewMatrix = DirectX::XMMatrixInverse(&det, m_InvViewMatrix);

	Renderer::SetViewMatrix(&m_ViewMatrix);



	// プロジェクションマトリクス設定
	m_ProjectionMatrix = DirectX::XMMatrixPerspectiveFovLH(1.0f, dxViewport.Width / dxViewport.Height, 1.0f, 1000.0f);

	Renderer::SetProjectionMatrix(&m_ProjectionMatrix);



}

