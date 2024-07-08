#ifndef MYHLSLINCLUDE_INCLUDE
#define MYHLSLINCLUDE_INCLUDE

void Fmod_float(float2 uv, float2 size,out float2 outPut){
                float2 c = frac(abs(uv / size)) * abs(size);
                outPut= abs(c);
}
#endif