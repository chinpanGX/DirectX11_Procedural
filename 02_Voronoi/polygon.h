#pragma once


#include "shader.h"


class CPolygon : public CGameObject
{
private:

	ID3D11Buffer*	m_VertexBuffer = NULL;
	CShader*		m_Shader;
	XMFLOAT4 m_Parameter;
	int m_Count = 0;
public:
	void Init();
	void Uninit();
	void Update();
	void Draw();


};