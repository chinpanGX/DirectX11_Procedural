#pragma once
#include "game_object.h"
class Dome : public CGameObject
{
private:
	class CModel* m_Model;
	class CShader* m_Shader;
	XMFLOAT4 m_Parameter;

public:
	void Init();
	void Uninit();
	void Update();
	void Draw();
};

