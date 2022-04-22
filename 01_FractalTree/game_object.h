#pragma once

#include <list>
#include "main.h"
#include "renderer.h"


class GameObject
{

protected:

	DirectX::XMFLOAT3					m_Position;
	DirectX::XMFLOAT3					m_Rotation;
	DirectX::XMFLOAT3					m_Scale;

public:

	DirectX::XMFLOAT3 GetPosition(){ return m_Position; }
	DirectX::XMFLOAT3 GetRotation(){ return m_Rotation; }
	DirectX::XMFLOAT3 GetScale(){ return m_Scale; }

	void SetPosition( DirectX::XMFLOAT3 Position ){ m_Position = Position; }
	void SetRotation( DirectX::XMFLOAT3 Rotation ){ m_Rotation = Rotation; }
	void SetScale( DirectX::XMFLOAT3 Scale ){ m_Scale = Scale; }



public:

	GameObject(){}

	virtual ~GameObject()
	{
	}

	virtual void Init()
	{

	}

	virtual void Uninit()
	{
	}


	virtual void Update()
	{
	}


	virtual void Draw()
	{
	}



};