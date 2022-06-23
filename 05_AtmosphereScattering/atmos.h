#pragma once


class CAtmos : public CGameObject
{
private:
	static CAtmos* m_Instance;

	ID3D11Buffer*	m_VertexBuffer = NULL;
	ID3D11Buffer*	m_IndexBuffer = NULL;
	CTexture*		m_Texture = NULL;

	CShader*		m_Shader;

	float			m_Time;


	static const int SKY_X = 32;
	static const int SKY_Z = 32;

	VERTEX_3D m_Vertex[SKY_X * SKY_Z];


	float			m_LightRotation;
	LIGHT m_Light;

public:
	CAtmos() { m_Instance = this; }
	static CAtmos* GetInstance() { return m_Instance; }

	void Init();
	void Uninit();
	void Update();
	void Draw();

	LIGHT GetLight() const { return m_Light; }
};