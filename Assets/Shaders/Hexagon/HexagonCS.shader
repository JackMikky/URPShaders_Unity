Shader "Unlit/HexagonCS"
{
	Properties
	{
		[HideInInspector]_MainTex("Texture", 2D) = "white" {}
		_Segment("Shape Segment",RANGE(3,24)) = 6
		[Toggle]_Invert("Invert Hex",FLOAT) = 0
		_Thickness("Line Thickness",RANGE(0,5))=0.1
		[Toggle]_UseLineColor("UseLineColor",FLOAT) = 0
		[HDR]_LineColor("Line Color",Color)=(0,2,0.232858658,1)
	}

		HLSLINCLUDE
		#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
		#include "Assets/ShaderFunctionScripts/Hex.hlsl"

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
	int _Segment;
	float _ShapeNumber;
	float _Invert;
	float _Thickness;
	float4 _LineColor;
	float _UseLineColor;

	v2f vert(appdata v)
	{
		v2f o;
		o.vertex = TransformObjectToHClip(v.vertex);
		o.uv = TRANSFORM_TEX(v.uv, _MainTex);
		return o;
	}

	half4 frag(v2f i) : SV_Target
	{
		float4 lineColor=float4(0,0,0,1);
		float2 Hex;
		float2 HexUV;
		float HexPos;
		float2 HexIndex;
		float2 uv = i.uv;
		uv.x *= _ScreenParams.x / _ScreenParams.y;
		Hexagon_noise_float(uv, _Segment, HexPos, HexIndex, HexUV, Hex);
		float4 col = tex2D(_MainTex,i.uv);
		HexPos = smoothstep(-0.01,_Thickness,HexPos);
		if (_Invert) {
		HexPos = 1-HexPos;
		}
		if(_UseLineColor && !_Invert){
		lineColor = _LineColor*(1-HexPos);
		}
		col *= HexPos;
		col+=lineColor;
	return col;
	}
		ENDHLSL
		SubShader
	{
		Pass
		{
			HLSLPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			ENDHLSL
		}
	}
}
