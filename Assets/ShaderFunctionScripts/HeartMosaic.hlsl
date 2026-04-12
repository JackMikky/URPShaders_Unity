#ifndef HEARTMOSIC_INCLUDE
#define HEARTMOSIC_INCLUDE

float inHeart(float2 tex, float size)
{
    if (size == 0.0)
    {
        return 0.0;
    }
    tex = float2(tex.x, -tex.y);
    tex /= size;
    tex += float2(1.25, -1.25);
                
    float s = tex.x * tex.x - tex.y * -tex.y - 1.0;
    float f1 = s * s * s;
    float f2 = tex.x * tex.x * tex.y * tex.y * tex.y * -1.0;
    return step(f1, f2);
}

float4 HeartMosaic(
    float2 uv,
    float2 resolution,
    TEXTURE2D_PARAM( mainTex, mainTexSampler), 
float4 mainTexTexelSize,
    float mosaicIntensity)
{
        float4 outp = SAMPLE_TEXTURE2D(mainTex, mainTexSampler, uv);
                
        if (mosaicIntensity > 1.0)
        {
            float2 tex = uv * resolution;
                    
            float2 center = float2(
                round(tex.x / mosaicIntensity) * mosaicIntensity,
                round(tex.y / mosaicIntensity) * mosaicIntensity
                );
                    
        center += float2(mosaicIntensity, mosaicIntensity) / 2.0;
        tex -= center;
                    
        if (inHeart(tex, mosaicIntensity / 2.4) > 0.0)
        {
            outp = SAMPLE_TEXTURE2D(mainTex, mainTexSampler, center / resolution);
        }
    }
    return outp;
}

void CalcHeartCenter_float(float2 tex, float mosaicIntensity, out float2 center)
{
    center = float2(
            round(tex.x / mosaicIntensity) * mosaicIntensity,
            round(tex.y / mosaicIntensity) * mosaicIntensity
        );
    center += float2(mosaicIntensity, mosaicIntensity) / 2.0;

}


void InHeart_float(float2 tex, float size, out float result)
{
    if (size == 0.0)
    {
        result = 0.0;
    }
    tex = float2(tex.x, -tex.y);
    tex /= size;
    tex += float2(1.25, -1.25);
                
    float s = tex.x * tex.x - tex.y * -tex.y - 1.0;
    float f1 = s * s * s;
    float f2 = tex.x * tex.x * tex.y * tex.y * tex.y * -1.0;
    result = step (f1, f2);
}

void InHeart_half(float2 tex, float size, out half result)
{
    if (size == 0.0)
    {
        result = 0.0;
    }
    tex = half2(tex.x, -tex.y);
    tex /= size;
    tex += half2(1.25, -1.25);
                
    half s = tex.x * tex.x - tex.y * -tex.y - 1.0;
    half f1 = s * s * s;
    half  f2 = tex.x * tex.x * tex.y * tex.y * tex.y * -1.0;
    result = step(f1, f2);
}

#endif // HEARTMOSIC_INCLUDE