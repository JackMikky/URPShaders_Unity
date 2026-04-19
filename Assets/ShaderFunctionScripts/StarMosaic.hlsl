#ifndef StarMOSAIC_INCLUDE
#define StarMOSAIC_INCLUDE

#define pi 3.1415926535

float inStar(float2 uv,float outSideR,float inSideR,float size,float rotate){
    float a = atan2(uv.y, uv.x);
    float r = length(uv);

    float sector = 2.0 * pi / 5.0;
    float a_offset = a + pi * rotate;
    float angle = fmod(a_offset + 10.0 * sector, sector) - sector * 0.5;
    angle = abs(angle);

    float2 p = float2(cos(angle), sin(angle)) * r;
    float d = p.x * inSideR + p.y * outSideR - size; 
    
    return d;
}

void inStar_float(float2 uv,float outSideR,float inSideR,float size,float rotate,out float result){    
    result = inStar(uv, outSideR, inSideR, size, rotate);
}

float4 starMosaic(float2 uv0,float2 iResolution,float2 offset,TEXTURE2D_PARAM( mainTex, mainTexSampler), float outSideR, float inSideR, float size, float density, float rotate){ 
    float2 aspect = float2(iResolution.x / iResolution.y, 1.0);
    
    float2 mosaicUV = floor(uv0 * density * aspect) / (density * aspect);
    mosaicUV += 0.5 / (density * aspect); 
    mosaicUV += float2(-0.0012,0.0);
    
    float4 colorAtCenter = SAMPLE_TEXTURE2D(mainTex, mainTexSampler, mosaicUV);
    
    float2 localUV = frac(uv0 * density * aspect) - 0.5 + offset;
    
    float d = inStar(localUV, outSideR, inSideR, size, rotate);
    
    float4 background = SAMPLE_TEXTURE2D(mainTex, mainTexSampler, uv0);
    
    float blurWidth = 0.001; // 边缘模糊度，越小越硬
    float mask = smoothstep(blurWidth, -blurWidth, d);
    
    float3 starCol = colorAtCenter.rgb;
    
    starCol *= 1.25; // 增强亮度
    
    return lerp(background, float4(starCol, 1.0), mask);
    //return float4(mask, mask, mask, 1.0);
}

void starMosaic_float(
    float2 UV, 
    float2 resolution, 
    float2 offset,
    UnityTexture2D mainTexture,
    UnitySamplerState SS,
    float outSideR, 
    float inSideR, 
    float size, 
    float density,
    float rotate,
    out float4 result)
{
    result = starMosaic(
        UV, 
        resolution, 
        offset,
        mainTexture.tex,
        SS.samplerstate,
        outSideR, 
        inSideR, 
        size,
        density,
        rotate
    );
}
#endif // StarMOSAIC_INCLUDE