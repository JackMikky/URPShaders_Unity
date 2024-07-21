Shader "Unlit/illusionEffectCS"
{
	Properties
	{
		[HideInInspector]_MainTex("Texture", 2D) = "white" {}
        _Speed("Move Speed",Range(0.1,10))=1
        _Distance("illusion Move Distance",Range(0,1))=0.1
		[Header(Lens Option)]
        [Toggle]_UseFish_Eye_Lens("Fish-eye lens",FLOAT)=1
        _Scale("Lens Scale",Vector)=(1,1,0,0)
		_LensDistance("Lens Distance",float)=0.58
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
				//https://www.shadertoy.com/view/ldsSDn

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

                 float _Speed;
                 float2 _Scale;
				 float _LensDistance;
                 float _Distance;
                 float _UseFish_Eye_Lens;

				 v2f vert(appdata v)
				 {
					 v2f o;
					 o.vertex = TransformObjectToHClip(v.vertex.xyz);
					 o.uv = TRANSFORM_TEX(v.uv, _MainTex);
					 return o;
				 }

				 half4  frag(v2f i) : SV_Target
				 {                
                    
                    half4 col =float4(0,0,0,0);
                    float2 coords =i.uv;
					float2 uv=i.uv;
					if (_UseFish_Eye_Lens) {
						coords *= _Scale;
						coords -= float2(_Scale.x*0.5, _Scale.y * 0.5);
						coords /= 2.0 * (_LensDistance - distance(coords, float2(0.0, 0.0)));
						uv = coords + float2(0.5,0.5);
					}
                     
                    float _Constant_TAU = 6.28318530;

                    float time= _Time * _Constant_TAU*_Speed;
                    float offset = sin(time)*_Distance;

                    offset = remap(offset,-1,1,-0.5,0.5);

                    float2 uvR=uv;
                    float2 uvG=uv;
					float2 uvB = uv;
					col= tex2D(_MainTex,uv);
                    TilingAndOffset(uv,float2(1,1),float2(offset,offset),uvR);
                    TilingAndOffset(uv,float2(1,1),float2(0,offset),uvG);

                     col.r = tex2D(_MainTex,uvR).r;
                     col.g = tex2D(_MainTex,uvG).g;
                     col.b = tex2D(_MainTex,uvB).b;

				 return col;
				 }
					 ENDHLSL
			 }
		}
}