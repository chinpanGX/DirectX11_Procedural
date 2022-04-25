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

	// �}�g���N�X�ݒ�
	DirectX::XMMATRIX world;
	world = DirectX::XMMatrixScaling(m_Scale.x, m_Scale.y, m_Scale.z);
	world *= DirectX::XMMatrixRotationRollPitchYaw(m_Rotation.x, m_Rotation.y, m_Rotation.z);
	world *= DirectX::XMMatrixTranslation(m_Position.x, m_Position.y, m_Position.z);
	Renderer::SetWorldMatrix(&world);

	m_Model->Draw();

	// �}��`�悷��
	DrawChild(world, 1.0f);

}



//�ċA�I�Ɏ}�`��/////////////////////////////////////////////////
void Tree::DrawChild(const DirectX::XMMATRIX& Parent, float Scale)
{
	// �傫����0.5f�ȉ��ɂȂ�����A�ċA��������߂�
	if (Scale < 0.5f)
	{
		return;
	}

	DirectX::XMMATRIX world;

	for (int i = 0; i < 3; i++)
	{
		// ��]�̗���
		float x, z;
		x = (float)rand() / RAND_MAX * 1.0f - 0.5f;
		z = (float)rand() / RAND_MAX * 1.0f - 0.5f;

		// �傫���̕␳�l�̗���
		//float offset = (float)rand() / RAND_MAX * 1.0f - 0.5f;
		float offset = (float)Random::Rand_R(1, 5) * 0.05f;

		world = DirectX::XMMatrixScaling(Scale, Scale + offset, Scale);
		world *= DirectX::XMMatrixRotationRollPitchYaw(x, 0.0f, z);
		world *= DirectX::XMMatrixTranslation(0.0f, 2.0f, 0.0f); // Y��2.0f�Ȃ̂́A��[����}�𐶂₷����
		world *= Parent;
		Renderer::SetWorldMatrix(&world);

		m_Model->Draw();

		DrawChild(world, Scale * 0.9f);
	}

	for (int i = 0; i < m_LeafList.size(); i++)
	{
		m_LeafList[i]->Draw(world);
	}
}
