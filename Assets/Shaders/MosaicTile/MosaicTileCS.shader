Shader "Unlit/MosaicTileCS"
{
    // forked from : https://www.shadertoy.com/view/MssSDl
    Properties
    {
   _EdgeColor ("EdgeColor",Color)= (0.7,0.7,0.7)
    _NumTiles("NumTiles",Range(0,256))= 32
    _Threshhold("Threshhold",Range(0,1.0))= 0.15
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _EdgeColor;
            float _NumTiles;
            float _Threshhold;

            float2 fmod(float2 a, float2 b)
            {
                float2 c = frac(abs(a / b)) * abs(b);
                return abs(c);
            }


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex.xyz);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                //float2 iResolution = (_ScreenParams.x,_ScreenParams.y);
            	float2 uv =i.uv;
                float size = 1.0 / _NumTiles;
	            float2 Pbase = uv - fmod(uv, float2(size,size));
	            float2 PCenter = Pbase + float2(size / 2.0, size / 2.0);
	            float2 st = (uv - Pbase) / size;
	            float4 c1 = float4(0.0,0,0,0);
	            float4 c2 = float4(0,0,0,0);
	            float4 invOff = float4(1.0-_EdgeColor.r,1.0- _EdgeColor.g,1.0- _EdgeColor.b, 1.0);

	            if (st.x > st.y)
	            {
	            	c1 = invOff; 
	            }
	            float threshholdB = 1.0 - _Threshhold;

	            if (st.x > threshholdB) 
	            { 
	            	c2 = c1; 
	            }

	            if (st.y > threshholdB) 
	            { 
	            	c2 = c1; 
	            }

	            float4 cBottom = c2;
	            c1 = float4(0,0,0,0);
	            c2 = float4(0,0,0,0);
	
	            if (st.x > st.y)
	            { 
	            	c1 = invOff; 
	            }

	            if (st.x < _Threshhold) 
	            { 
	            	c2 = c1;
	            }
	
	            if (st.y < _Threshhold) 
	            { 
	            	c2 = c1; 
	            }

	            float4 cTop = c2;
	            float4 tileColor = tex2D(_MainTex, PCenter);
                half4 col = tileColor + cTop - cBottom;
                return col;
            }
             ENDHLSL
        }
    }
}
