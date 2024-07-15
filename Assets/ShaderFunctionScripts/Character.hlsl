#ifndef MYHLSLINCLUDE_INCLUDE
#define MYHLSLINCLUDE_INCLUDE

void character_float(int n,float2 p,float3 col,out float Out){
			p = floor(p * float2(-4.0, 4.0) + 2.5);
            if (clamp(p.x, 0, 4) == p.x && clamp(p.y, 0, 4) == p.y)
            {
                float c = fmod(n / exp2(p.x + 5 * p.y), 2);
                if (int(c) == 1) Out = 1;
            }
			Out = 0;
}
#endif