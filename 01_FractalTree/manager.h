#pragma once
#include "scene.h"

class Manager
{
public:
	static void Init();
	static void Uninit();
	static void Update();
	static void Draw();
	static Scene* GetScene();
};