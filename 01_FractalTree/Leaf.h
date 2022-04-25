#pragma once
#include "game_object.h"

class Leaf : public GameObject
{
private:
	ID3D11Buffer*	m_VertexBuffer = NULL;
public:
	void Init()override;
	void Uninit()override;
	void Update()override;
	void Draw()override;
	void Draw(const DirectX::XMMATRIX& World);
	void SetTransform();
};

