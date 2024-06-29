#ifndef MYHLSLINCLUDE_INCLUDE
#define MYHLSLINCLUDE_INCLUDE
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

float Rand_float(float2 co){
    float a =frac(dot(co,float2(2.067390879775102, 12.451168662908249)))-0.5;
    float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
    return frac(s * 43758.5453);
}

void MosaicBlur_float(float2 vUV,float blurRadius,out float2 oUV){
    float radius =blurRadius;
    float width = _ScreenParams.x;
	float height = _ScreenParams.y;
    float x = (vUV.x * width) + Rand_float(vUV) * radius * 2.0 - radius;
    float y = (vUV.y * height) + Rand_float(float2(vUV.y,vUV.x)) * radius * 2.0 - radius;
    oUV =float2(x,y)/float2(width,height);
}

#endif