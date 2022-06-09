// 2D疑似乱数
float random2D(in float2 vec)
{
    return frac(sin(dot(vec.xy, float2(12.9898, 78.233))) * 4378.545);
}

//2D->2D疑似乱数
float2 random2D2(in float2 vec)
{
    vec = float2(dot(vec, float2(127.1, 311.7)), dot(vec, float2(269.5, 183.3)));
    return frac(sin(vec) + 4378.545);
}

float random3(in float3 vec)
{
    return frac(sin(dot(vec.xyz, float3(12.9898, 78.233, 53.4545))) * 4378.545);

}

float3 random3D3(in float3 vec)
{
    vec = float3(dot(vec, float3(127.1, 311.7, 179.4)), dot(vec, float3(269.5, 182.3, 292.4)), dot(vec, float3(231.2, 179.4, 163.9)));
    return frac(sin(vec) + 4378.545);
}

// ボロノイ図
float voronoi2(in float2 vec)
{
    float2 ivec = floor(vec);
    float2 fvec = frac(vec);
    
    float value = 1.0;
    
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            float2 offset = float2(x, y);
            
            float2 position = random2D2(ivec + offset);
            float dist = distance(position + offset, fvec);
            value = min(value, dist);
        }
    }
    return value;
}

float4 colorvoronoi(in float2 vec)
{
    float2 ivec = floor(vec);
    float2 fvec = frac(vec);
    float value = 1.0;
    float4 color = 1.0;
    
    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            float2 offset = float2(x, y);
            
            float2 position = random2D2(ivec + offset);
            float dist = distance(position + offset, fvec);
            value = min(value, dist);
        }
    }
    color.a = sin(dot(value, 4378.545));
    color.g = dot(value, 4378.545);
    color.b = sin(value);
    return color;
}

// バリューノイズ
float valueNoise2(in float2 vec)
{
    float2 ivec = floor(vec);
    float2 fvec = frac(vec);
    
    float a = random2D(ivec + float2(0.0, 0.0));
    float b = random2D(ivec + float2(1.0, 0.0));
    float c = random2D(ivec + float2(0.0, 1.0));
    float d = random2D(ivec + float2(1.0, 1.0));

    fvec = smoothstep(0.0, 1.0, fvec);
    return lerp(lerp(a, b, fvec.x), lerp(c, d, fvec.x), fvec.y);

}

// パーリンノイズ
float perlinNoise2(in float2 vec)
{
    float2 ivec = floor(vec);
    float2 fvec = frac(vec);
    
    float a = dot(random2D2(ivec + float2(0.0, 0.0)) * 2.0 - 1.0, fvec - float2(0.0, 0.0));
    float b = dot(random2D2(ivec + float2(1.0, 0.0)) * 2.0 - 1.0, fvec - float2(1.0, 0.0));
    float c = dot(random2D2(ivec + float2(0.0, 1.0)) * 2.0 - 1.0, fvec - float2(0.0, 1.0));
    float d = dot(random2D2(ivec + float2(1.0, 1.0)) * 2.0 - 1.0, fvec - float2(1.0, 1.0));

    fvec = smoothstep(0.0, 1.0, fvec);
    return lerp(lerp(a, b, fvec.x), lerp(c, d, fvec.x), fvec.y);
}

// パーリンノイズ
float perlinNoise3(in float3 vec)
{
    float3 ivec = floor(vec);
    float3 fvec = frac(vec);
    
    float a = dot(random3D3(ivec + float3(0.0, 0.0, 0.0)) * 2.0 - 1.0, fvec - float3(0.0, 0.0, 0.0));
    float b = dot(random3D3(ivec + float3(1.0, 0.0, 0.0)) * 2.0 - 1.0, fvec - float3(1.0, 0.0, 0.0));
    float c = dot(random3D3(ivec + float3(0.0, 1.0, 0.0)) * 2.0 - 1.0, fvec - float3(0.0, 1.0, 0.0));
    float d = dot(random3D3(ivec + float3(1.0, 1.0, 0.0)) * 2.0 - 1.0, fvec - float3(1.0, 1.0, 0.0));

    
    float e = dot(random3D3(ivec + float3(0.0, 0.0, 1.0)) * 2.0 - 1.0, fvec - float3(0.0, 0.0, 1.0));
    float f = dot(random3D3(ivec + float3(1.0, 0.0, 1.0)) * 2.0 - 1.0, fvec - float3(1.0, 0.0, 1.0));
    float g = dot(random3D3(ivec + float3(0.0, 1.0, 1.0)) * 2.0 - 1.0, fvec - float3(0.0, 1.0, 1.0));
    float h = dot(random3D3(ivec + float3(1.0, 1.0, 1.0)) * 2.0 - 1.0, fvec - float3(1.0, 1.0, 1.0));

    // エルミート補間
    fvec = smoothstep(0.0, 1.0, fvec);
    
    float v1 = lerp(lerp(a, b, fvec.x), lerp(c, d, fvec.x), fvec.y);
    float v2 = lerp(lerp(e, f, fvec.x), lerp(g, h, fvec.x), fvec.y);
    float v3 = lerp(v1, v2, fvec.z);
    
    return v3;
}

// offset はスケールに応じた値が入る
float fbm2(in float2 vec, int octave, float offset = 0.0)
{
    float value;
    float amplitude = 1.0;
    
    for (int i = 0; i < octave; i++)
    {
        value += amplitude * perlinNoise2(vec + offset);
        vec *= 2;
        amplitude *= 0.5;
    }
    
    return value;
}

float fbm3(in float3 vec, int octave)
{
    float value;
    float amplitude = 1.0;
    
    for (int i = 0; i < octave; i++)
    {
        value += amplitude * perlinNoise3(vec);
        vec *= 2;
        amplitude *= 0.5;
    }
    
    return value;
}

float fbmabs2(in float2 vec, int octave)
{
    float value;
    float amplitude = 1.0;
    
    for (int i = 0; i < octave; i++)
    {
        value += amplitude * abs(perlinNoise2(vec));
        vec *= 3;
        amplitude *= 0.5;
    }
    
    return value;
}
