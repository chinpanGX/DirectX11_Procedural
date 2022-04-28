// 2D‹^——”
float random2D(in float2 vec)
{
    return frac(sin(dot(vec.xy, float2(12.9898, 78.233))) * 4378.545);
}

//2D->2D‹^——”
float2 random2D2(in float2 vec)
{
    vec = float2(dot(vec, float2(127.1, 311.7)), dot(vec, float2(269.5, 183.3)));
    return frac(sin(vec) + 4378.545);
}

// ƒ{ƒƒmƒC}
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