#ifndef MYHLSLINCLUDE_INCLUDE
#define MYHLSLINCLUDE_INCLUDE

void ProsebilityCalculator_float(float2 InputValue, out float Probability)
{
    float Proba = 100 - InputValue;
    Probability = Proba * 0.01;
}

float remap(float val, float inMin, float inMax, float outMin, float outMax)
{
    return clamp(outMin + (val - inMin) * (outMax - outMin) / (inMax - inMin), outMin, outMax);
}

void TilingAndOffset(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
{
    Out = UV * Tiling + Offset;
}

float character(int n, float2 p, int secondaryEffect=0)
{
    p = floor(p * float2(-4.0, 4.0) + 2.5);
    if (clamp(p.x, 0.0, 4.0) == p.x && clamp(p.y, 0.0, 4.0) == p.y)
    {
        int a = int(round(p.x) + 5.0 * round(p.y));
        if (((n >> a) & 1) == 1)
        {
            if (secondaryEffect)
                return 0.0;
            else
                return 1.0;
        };
    }
    if (secondaryEffect)
        return 1.0;
    else
        return 0.0;
}
#endif