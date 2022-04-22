#pragma once

#include <list>
#include "main.h"

#include "game_object.h"
#include "model.h"
#include "texture.h"

#include "camera.h"
#include "field.h"
#include "tree.h"
#include "polygon.h"

class CScene
{
protected:
	std::list<GameObject*>	m_GameObject;

public:
	CScene(){}
	virtual ~CScene(){}


	virtual void Init()
	{
		AddGameObject<Camera>();
		AddGameObject<Field>();
		AddGameObject<Tree>();
		//AddGameObject<Polygon>();
	}

	virtual void Uninit()
	{
		for (GameObject* object : m_GameObject)
		{
			object->Uninit();
			delete object;
		}

		m_GameObject.clear();
	}


	virtual void Update()
	{
		for( GameObject* object : m_GameObject )
			object->Update();
	}


	virtual void Draw()
	{
		for (GameObject* object : m_GameObject)
			object->Draw();
	}


	template <typename T>
	T* AddGameObject()
	{
		T* gameObject = new T();
		gameObject->Init();
		m_GameObject.push_back(gameObject);

		return gameObject;
	}

};