

#include "main.h"
#include "input.h"
#include "renderer.h"
#include "game_object.h"
#include "model.h"
#include "texture.h"
#include "tree.h"




void CTree::Init()
{
	m_Position = XMFLOAT3(0.0f, 0.0f, 0.0f);
	m_Rotation = XMFLOAT3(0.0f, 0.0f, 0.0f);
	m_Scale = XMFLOAT3(0.7f, 0.7f, 0.7f);


	m_Model = new CModel();
	m_Model->Load("data/MODEL/branch.obj");

	m_Seed = 0;
}


void CTree::Uninit()
{

	m_Model->Unload();

}


void CTree::Update()
{

	m_Rotation.y += 0.01f;


	if (CInput::GetKeyTrigger('1'))
		m_Seed++;
	if (CInput::GetKeyTrigger('2'))
		m_Seed--;

}

void CTree::Draw()
{

	srand(m_Seed);

	// マトリクス設定
	XMMATRIX world;
	world = XMMatrixScaling(m_Scale.x, m_Scale.y, m_Scale.z);
	world *= XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	world *= XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);
	CRenderer::SetWorldMatrix(&world);

	m_Model->Draw();

	// 枝を描画する
	DrawChild(world, 1.0f);
}



//再帰的に枝描画/////////////////////////////////////////////////
void CTree::DrawChild(XMMATRIX Parent, float Scale)
{
	// 大きさが0.5f以下になったら、再帰処理をやめる
	if (Scale < 0.5f)
	{
		return;
	}

	// 分割する分ループする
	for (int i = 0; i < 3; i++)
	{
		// 回転の乱数
		float x, z;
		x = (float)rand() / RAND_MAX * 1.0f - 0.5f;
		z = (float)rand() / RAND_MAX * 1.0f - 0.5f;

		// 大きさの補正値の乱数
		float offset = (float)rand() / RAND_MAX * 1.0f - 0.5f;


		XMMATRIX world;
		world = XMMatrixScaling(Scale, Scale + offset, Scale);
		world *= XMMatrixRotationRollPitchYaw(x, 0.0f, z);
		world *= XMMatrixTranslation(0.0f, 2.0f, 0.0f); // Yが2.0fなのは、先端から枝を生やすため
		world *= Parent;
		CRenderer::SetWorldMatrix(&world);

		m_Model->Draw();

		DrawChild(world, Scale * 0.9f);

	}
}


