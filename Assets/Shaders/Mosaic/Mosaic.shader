Shader "Unlit/Mosaic"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		[IntRange]_Resolution("Resolution",Range(8,2048)) = 64
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

				 sampler2D _MainTex;
				 float _UseMosaic;
				 float _Resolution;
				 float4 _MainTex_ST;

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = TransformObjectToHClip(v.vertex.xyz);
					 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					 return o;
				 }

				 half4  frag(v2f i) : SV_Target
				 {
					float2 vUV = i.uv;
					if (_UseMosaic) {
						vUV = floor(vUV * _Resolution) / _Resolution;
					}
					half4 col = tex2D(_MainTex, vUV);
				 return col;
				 }
					 ENDHLSL
			 }
		}
}
