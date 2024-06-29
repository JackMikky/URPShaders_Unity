Shader "Unlit/MosaicBlur"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[IntRange]_BlurRadius("BlurRadius",Range(0,100)) = 5
		[Toggle] _UseMosaic("Mosaic", Float) = 1
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
				 float _BlurRadius;
				 sampler2D _MainTex;
				 float _UseMosaic;
				 float4 _MainTex_ST;

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = TransformObjectToHClip(v.vertex.xyz);
					 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					 return o;
				 }
				 float Rand_float(float2 co) {
					 float a = frac(dot(co, float2(2.067390879775102, 12.451168662908249))) - 0.5;
					 float s = a * (6.182785114200511 + a * a * (-38.026512460676566 + a * a * 53.392573080032137));
					 return frac(s * 43758.5453);
				 }

				 half4  frag(v2f i) : SV_Target
				 {
					float width = _ScreenParams.x;
					float height = _ScreenParams.y;
					float2 vUV = i.uv;
					if (_UseMosaic) {
						float x = (vUV.x * width) + Rand_float(vUV) * _BlurRadius * 2.0 - _BlurRadius;
						float y = (vUV.y * height) + Rand_float(float2(vUV.y, vUV.x)) * _BlurRadius * 2.0 - _BlurRadius;
						vUV = float2(x, y) / float2(width, height);
					}
					half4 col = tex2D(_MainTex, vUV);
				 return col;
				 }
					 ENDHLSL
			 }
		}
}
