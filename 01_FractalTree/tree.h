#pragma once
#include <vector>
#include "Leaf.h"

class Tree : public GameObject
{
private:
	std::vector<Leaf*> m_LeafList;
	Model* m_Model;
	int		m_Seed;

public:
	void Init()override;
	void Uninit()override;
	void Update()override;
	void Draw()override;
	void DrawChild(const DirectX::XMMATRIX& Parent, float Scale);
};