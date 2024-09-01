Shader "Unlit/BlackWhiteDotCS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Angle("Angle",float) = 1.57
        _Size("Size",Vector)=(500,500,0,0)
        _Center("Center",Vector)=(0.5,0.5,0,0)
        _Color1("Color1",float)=5
        _Color2("Color2",float)=10
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

                 float _Angle;
                 float4 _Size;
                 float4 _Center;

                 float _Color1,_Color2;
                 

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = TransformObjectToHClip(v.vertex.xyz);
					 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					 return o;
				 }

				 half4  frag(v2f i) : SV_Target
				 {
                    float2 size = _Size.xy;

                    float2 center = _Center.xy;
                    
                    half4 col = float4(0,0,0,0);

                    float2 cuv = i.uv;

                    cuv.x *= screenRatio(_ScreenParams);

					col= tex2D(_MainTex,i.uv);

                    float aCol = (col.r + col.g +col.b ) / 3; 

                    float vc = aCol * _Color2 - _Color1 + pattern(_Angle,size,center,cuv);

                    float3 newColor3 = float3(vc,vc,vc);

                    float4 newCol = float4(newColor3,col.a);

				 return newCol;
				 }
					 ENDHLSL
			 }
    }
}
