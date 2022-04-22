
#include "main.h"
#include "manager.h"
#include "input.h"
#include "renderer.h"
#include "scene.h"
#include "field.h"
#include "polygon.h"
#include "model.h"

CScene*	g_Scene;


void CManager::Init()
{

	Renderer::Init();
	CInput::Init();

	g_Scene = new CScene();
	g_Scene->Init();

}

void CManager::Uninit()
{

	g_Scene->Uninit();
	delete g_Scene;

	CInput::Uninit();
	Renderer::Uninit();

}

void CManager::Update()
{

	CInput::Update();

	g_Scene->Update();

}

void CManager::Draw()
{

	Renderer::Begin();

	g_Scene->Draw();

	Renderer::End();

}
