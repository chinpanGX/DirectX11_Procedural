#pragma once
#include "main.h"
#include "renderer.h"
#include <string>

class Texture
{
private:
	ID3D11Texture2D*			m_Texture;
	ID3D11ShaderResourceView*	m_ShaderResourceView;

public:
	void Load(std::string FileName);
	void Unload();
	ID3D11ShaderResourceView* GetShaderResourceView() const 
	{ 
		return m_ShaderResourceView; 
	}
};