#include "main.h"
#include "scene.h"
#include "manager.h"
#include "input.h"
#include "renderer.h"
#include "field.h"
#include "polygon.h"
#include "model.h"

Scene*	g_Scene;

void Manager::Init()
{

	Renderer::Init();
	Input::Init();

	g_Scene = new Scene();
	g_Scene->Init();

}

void Manager::Uninit()
{

	g_Scene->Uninit();
	delete g_Scene;

	Input::Uninit();
	Renderer::Uninit();

}

void Manager::Update()
{

	Input::Update();

	g_Scene->Update();

}

void Manager::Draw()
{

	Renderer::Begin();

	g_Scene->Draw();

	Renderer::End();

}

Scene * Manager::GetScene()
{
	return g_Scene;
}
