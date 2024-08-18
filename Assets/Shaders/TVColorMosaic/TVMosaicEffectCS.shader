Shader "Unlit/TVMosaicEffectCS"
{
	Properties
	{
        _MosaicColorPos("Mosaic Color Position",Vector)=(0,1,2,0)
        [IntRange]_Resolution("Resolution",Range(4,1024))=256
        _BlendAlpha("Blend Alpha",Range(0,1))=1
		[Space(20)]
		[Header(Pix Horizontal)]
        _HorizontalSpace("Pix Horizontal Space",Range(0.01,1.5))=0.5
        [Toggle]_MovablePix_Horizontal("Horizontal Pix Movable",FLOAT)=0
		[Space(20)]
		[Header(Pix Vertical)]
        _VerticalSpace("Pix Vertical Space",Range(0.01,1))=0.25
        [Toggle]_MovablePix_Vertical("Vertical Pix Movable",FLOAT)=0
	   [NoScaleOffset][HideInInspector] _MainTex("Texture", 2D) = "white" {}
	}
		SubShader
	{
		Tags { "RenderType" = "Opaque" }

		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Assets/ShaderFunctionScripts/ShaderUtility.hlsl"

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
            float _Resolution;
            float _BlendAlpha;
            float4 _MosaicColorPos;
            float _HorizontalSpace;
            float _VerticalSpace;
            float _MovablePix_Horizontal;
            float _MovablePix_Vertical;

			static float PIXELSIZE = 3.0;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = TransformObjectToHClip(v.vertex.xyz);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}

			half4 frag(v2f i) : SV_Target
			{
                float3 mosaicCol=_MosaicColorPos;

                float screenRatio;

                if(_ScreenParams.x>_ScreenParams.y){
                    screenRatio = _ScreenParams.x/_ScreenParams.y;
                }else{
                    screenRatio = _ScreenParams.y/_ScreenParams.x;
                }

				float2 cor;
				float2 uv = i.uv*_Resolution;

				cor.x = uv.x / PIXELSIZE;
				cor.y = (uv.y + PIXELSIZE * 1.5 * fmod(floor(cor.x), 2.0)) / (PIXELSIZE * 3.0);

				float2 ico = floor(cor);
				float2 fco = frac(cor);

				float3 pix = step(1.5, fmod(mosaicCol + ico.x, 3.0));
				float3 ima = tex2D(_MainTex, PIXELSIZE * ico * float2(1.0, 3.0)/_Resolution);
				float3 col = pix * dot(pix, ima);

                float hor = _HorizontalSpace;
                if(_MovablePix_Horizontal){
                   hor = remap(_SinTime.x,-1,1,0.01,1);
                }

                float vert = _VerticalSpace;
                if(_MovablePix_Vertical){
                    vert = remap(_SinTime.x,-1,1,0.01,1);
                }

				col *= step(abs(fco.x - vert), 0.4);
				col *= step(abs(fco.y - hor), 0.4);

                float4 normalCol=tex2D(_MainTex,i.uv);
                
				float4 colo = float4(col,1);
				return lerp(normalCol, colo, _BlendAlpha);;
			}
			 ENDHLSL
		}
	}
}
