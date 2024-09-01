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

float hexDist(float2 a, float2 b,float degree){
    float2 p = abs(b-a);
    float s = sin(degree);
    float c = cos(degree);
    
    float diagDist = s*p.x + c*p.y;
    return max(diagDist, p.x)/c;
}

float2 nearestHex(float s, float2 st,float degree){
    float h = sin(degree)*s;
    float r = cos(degree)*s;
    float b = s + 2.0*h;
    float a = 2.0*r;
    float m = h/r;

    float2 sect = st/float2(2.0*r, h+s);
    float2 sectPxl = fmod(st, float2(2.0*r, h+s));
    
    float aSection = fmod(floor(sect.y), 2.0);
    
    float2 coord = floor(sect);
    if(aSection > 0.0){
        if(sectPxl.y < (h-sectPxl.x*m)){
            coord -= 1.0;
        }
        else if(sectPxl.y < (-h + sectPxl.x*m)){
            coord.y -= 1.0;
        }

    }
    else{
        if(sectPxl.x > r){
            if(sectPxl.y < (2.0*h - sectPxl.x * m)){
                coord.y -= 1.0;
            }
        }
        else{
            if(sectPxl.y < (sectPxl.x*m)){
                coord.y -= 1.0;
            }
            else{
                coord.x -= 1.0;
            }
        }
    }
    
    float xoff = fmod(coord.y, 2.0)*r;
    return float2(coord.x*2.0*r-xoff, coord.y*(h+s))+float2(r*2.0, s);
}

float pattern(float angle,float2 Size,float2 center,float2 uv) {
    float s = sin( angle );
    float c = cos( angle );
    float2 tex = uv * Size - center;
    float2 points = float2( c * tex.x - s * tex.y, s * tex.x + c * tex.y );
    return ( sin( points.x ) * sin( points.y ) ) * 4.0;
}

float screenRatio(float4 ScreenParams){
    float screenRat;
    if(ScreenParams.x > ScreenParams.y){
    screenRat = ScreenParams.x / ScreenParams.y;
    }else{
    screenRat = ScreenParams.y / ScreenParams.x;
    }
    return screenRat;
}

#endif