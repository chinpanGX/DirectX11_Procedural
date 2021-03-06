#include "main.h"
#include "input.h"
#include "renderer.h"
#include "game_object.h"
#include "model.h"
#include "texture.h"
#include "scene.h"
#include "manager.h"
#include "Leaf.h"
#include "tree.h"
#include "Random.h"

static int Branch = 0;

void Tree::Init()
{
	m_Position = DirectX::XMFLOAT3(0.0f, 0.0f, 0.0f);
	m_Rotation = DirectX::XMFLOAT3(0.0f, 0.0f, 0.0f);
	m_Scale = DirectX::XMFLOAT3(0.7f, 0.7f, 0.7f);


	m_Model = new Model();
	m_Model->Load("data/MODEL/branch.obj");

	m_Seed = 0;

	for (int i = 0; i < 5; i++)
	{
		m_LeafList.emplace_back(Manager::GetScene()->AddGameObject<Leaf>());
	}
}


void Tree::Uninit()
{
	m_Model->Unload();
}


void Tree::Update()
{

	m_Rotation.y += 0.01f;


	if (Input::GetKeyTrigger('1'))
	{
		m_Seed++;
		for (int i = 0; i < m_LeafList.size(); i++)
		{
			m_LeafList[i]->SetTransform();
		}
	}
	if (Input::GetKeyTrigger('2'))
	{
		m_Seed--;
		for (int i = 0; i < m_LeafList.size(); i++)
		{
			m_LeafList[i]->SetTransform();
		}
	}

}

void Tree::Draw()
{

	srand(m_Seed);

	// マトリクス設定
	DirectX::XMMATRIX world;
	world = DirectX::XMMatrixScaling(m_Scale.x, m_Scale.y, m_Scale.z);
	world *= DirectX::XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	world *= DirectX::XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);
	Renderer::SetWorldMatrix(&world);

	m_Model->Draw();

	// 枝を描画する
	DrawChild(world, 1.0f);

}



//再帰的に枝描画/////////////////////////////////////////////////
void Tree::DrawChild(const DirectX::XMMATRIX& Parent, float Scale)
{
	// 大きさが0.5f以下になったら、再帰処理をやめる
	if (Scale < 0.5f)
	{
		return;
	}

	DirectX::XMMATRIX world;

	for (int i = 0; i < 3; i++)
	{
		// 回転の乱数
		float x, z;
		x = (float)rand() / RAND_MAX * 1.0f - 0.5f;
		z = (float)rand() / RAND_MAX * 1.0f - 0.5f;

		// 大きさの補正値の乱数
		//float offset = (float)rand() / RAND_MAX * 1.0f - 0.5f;
		float offset = (float)Random::Rand_R(1, 5) * 0.05f;

		// 行列計算
		world = DirectX::XMMatrixScaling(Scale, Scale + offset, Scale);
		world *= DirectX::XMMatrixRotationRollPitchYaw(x, 0.0f, z);
		world *= DirectX::XMMatrixTranslation(0.0f, 2.0f, 0.0f); // Yが2.0fなのは、先端から枝を生やすため
		world *= Parent;
		Renderer::SetWorldMatrix(&world);

		m_Model->Draw();

		DrawChild(world, Scale * 0.9f);
	}

	// 葉っぱの描画
	for (int i = 0; i < m_LeafList.size(); i++)
	{
		m_LeafList[i]->Draw(world);
	}
}
