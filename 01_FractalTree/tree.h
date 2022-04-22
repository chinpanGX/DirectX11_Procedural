#pragma once


class Tree : public GameObject
{
private:
	Model* m_Model;
	int		m_Seed;

public:
	void Init()override;
	void Uninit()override;
	void Update()override;
	void Draw()override;
	void DrawChild(DirectX::XMMATRIX Parent, float Scale);
};