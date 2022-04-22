#pragma once


class Tree : public GameObject
{
private:
	Model* m_Model;
	int		m_Seed;

public:
	void Init();
	void Uninit();
	void Update();
	void Draw();
	void DrawChild(XMMATRIX Parent, float Scale);
};