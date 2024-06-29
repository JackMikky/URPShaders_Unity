#ifndef MYHLSLINCLUDE_INCLUDE
#define MYHLSLINCLUDE_INCLUDE

void Rand_float(float2 co,out float randOut){
    float a =frac(dot(co,float2(2.067390879775102, 12.451168662908249)))-0.5;
    float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
    randOut = frac(s * 43758.5453);
}
#endif