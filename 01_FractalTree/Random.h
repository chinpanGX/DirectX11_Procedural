#pragma once
#include "main.h"
#include <time.h>

class Random final 
{
private:
	// 2�o�C�g��4�o�C�g�̕����Ȃ�����
	unsigned int xorRandomSeedX;
	unsigned int xorRandomSeedY;
	unsigned int xorRandomSeedZ;
	unsigned int xorRandomSeedW;

	inline Random()
	{
		srand((unsigned int)time(NULL));
		CreateInitNumber();
	}

	inline ~Random()
	{

	}

	inline void CreateInitNumber()
	{
		unsigned int seed = rand();
		if (seed == 0)
		{
			seed += 11;
		}

		xorRandomSeedW = seed;
		xorRandomSeedX = (seed << 16) + (seed >> 16);
		xorRandomSeedY = xorRandomSeedW + xorRandomSeedX;
		xorRandomSeedZ = xorRandomSeedX ^ xorRandomSeedY;
	}
public:
	Random(const Random&) = delete;
	Random& operator=(const Random&) = delete;
	Random(Random&&) = delete;
	Random& operator=(Random&&) = delete;

	// Min�`Max �͈̗̔͂����B
	inline static int Rand_R(const int Min, const int Max)
	{
		return (rand() % (Max - Min)) + Min;
	}

	// 0.0�`1.0 �͈̔͂̎��������ɂ���B
	inline static float GetRandomXORf()
	{
		static Random ins;
		unsigned int Transform = (ins.xorRandomSeedX ^ (ins.xorRandomSeedX << 11));
		ins.xorRandomSeedX = ins.xorRandomSeedY;
		ins.xorRandomSeedY = ins.xorRandomSeedZ;
		ins.xorRandomSeedZ = ins.xorRandomSeedW;
		ins.xorRandomSeedW = (ins.xorRandomSeedW ^ (ins.xorRandomSeedW >> 19)) ^ (Transform ^ (Transform >> 8));

		return float(ins.xorRandomSeedW % 10000) / float(10000);
	}

	// -1.0�`+1.0 �͈̔͂̎��������ɂ���B
	inline static float GetRandomXOR()
	{
		return 2.0f * GetRandomXORf() - 1.0f;
	}

	//���aradius�~���̓_�������_���Ɏ擾
	inline static void InsideUnitSpheref(float* x, float* y, float radius)
	{
		const float r = GetRandomXORf() * DirectX::XM_2PI;
		const float s = radius * sqrtf(GetRandomXORf());
		*x = s * cosf(r) + radius;
		*y = s * sinf(r) + radius;
	}
};

