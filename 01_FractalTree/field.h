#pragma once


class Field final : public GameObject
{
private:
	ID3D11Buffer*	m_VertexBuffer = NULL;
	Texture*		m_Texture = NULL;

public:
	void Init()override;
	void Uninit()override;
	void Update()override;
	void Draw()override;
};