#pragma once
#include "game_object.h"

class Torus : public CGameObject
{
private:
	class CModel* m_Model;
	class CShader* m_Shader;
public:
	void Init();
	void Uninit();
	void Update();
	void Draw();
};

