#pragma once

class Camera final : public GameObject
{
private:
	RECT m_Viewport;

public:
	void Init()override;
	void Uninit()override;
	void Update()override;
	void Draw()override;
};