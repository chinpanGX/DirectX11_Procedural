#pragma once

class Camera : public GameObject
{
private:

	RECT m_Viewport;

public:
	void Init();
	void Uninit();
	void Update();
	void Draw();


};