#pragma once

#include "shader.h"

// マテリアル構造体
struct MODEL_MATERIAL
{
	char						Name[256];
	MATERIAL					Material;
	char						TextureName[256];
};

// 描画サブセット構造体
struct SUBSET
{
	unsigned short	StartIndex;
	unsigned short	IndexNum;
	MODEL_MATERIAL	Material;
};

// モデル構造体
struct MODEL
{
	VERTEX_3D		*VertexArray;
	unsigned short	VertexNum;
	unsigned short	*IndexArray;
	unsigned short	IndexNum;
	SUBSET			*SubsetArray;
	unsigned short	SubsetNum;
};



class CModel
{
private:

	ID3D11Buffer*	m_VertexBuffer;
	ID3D11Buffer*	m_IndexBuffer;

	DX11_SUBSET*	m_SubsetArray;
	unsigned short	m_SubsetNum;

	void LoadObj( const char *FileName, MODEL *Model );
	void LoadMaterial( const char *FileName, MODEL_MATERIAL **MaterialArray, unsigned short *MaterialNum );


	CShader*		m_Shader;


public:
	void Draw();	
	void Load( const char *FileName );
	void Unload();
};