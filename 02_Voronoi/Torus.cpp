#include "game_object.h"
#include "model.h"
#include "Torus.h"
#include "camera.h"

void Torus::Init()
{
	m_Position = XMFLOAT3(-1.5f, -0.8f, 0.0f);
	m_Rotation = XMFLOAT3(0.0f, 0.0f, 0.0f);
	m_Scale = XMFLOAT3(0.8f, 0.8f, 0.8f);


	//Load("data/MODEL/cube.obj");
	//Load("data/MODEL/sphere_smooth.obj");
	m_Model = new CModel();
	m_Model->Load("data/MODEL/torus.obj");


	m_Shader = new CShader();
	m_Shader->Init("shader3DTextureVS.cso", "shader3DTexturePS.cso");

}


void Torus::Uninit()
{
	m_Shader->Uninit();
	delete m_Shader;

	m_Model->Unload();
	delete m_Model;

}


void Torus::Update()
{

	m_Rotation.y += 0.02f;
	m_Rotation.x += 0.02f;

}

void Torus::Draw()
{

	// マトリクス設定
	XMMATRIX world;
	world = XMMatrixScaling(m_Scale.x, m_Scale.y, m_Scale.z);
	world *= XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	world *= XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);

	XMFLOAT4X4 worldf;
	DirectX::XMStoreFloat4x4(&worldf, world);

	m_Shader->SetWorldMatrix(&worldf);


	CCamera* camera = CCamera::GetInstance();
	m_Shader->SetViewMatrix(&camera->GetViewMatrix());
	m_Shader->SetProjectionMatrix(&camera->GetProjectionMatrix());
	m_Shader->SetCameraPosition(&camera->GetPosition());

	
	XMFLOAT4 parameter;
	parameter.x = 1.0f;

	m_Shader->SetPrameter(parameter);
	m_Shader->Set();

	m_Model->Draw();
}

