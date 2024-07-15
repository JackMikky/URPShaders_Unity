Shader "Unlit/Ascii ArtCS"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "" {}
		_Color("Color", Color) = (1, 1, 1, 1)
		_Font_Color("Font Color", Color) = (1, 0, 0, 1)
		_Alpha("Alpha Blending", Range(0,1.0)) = 1.0
		_Scale("Scale Factor", Range(0.01,10)) = 1
		[Toggle]_use_Full_Character("Full Character",Float)=1
		[Toggle]_SecondaryEffect("Secondary Effect",Float)=0
		_GrayR("R Chanel", Range(0.1,1)) = 0.3
		_GrayG("G Chanel", Range(0.1,1)) = 0.59
		_GrayB("B Chanel", Range(0.1,1)) = 0.11
	}

		HLSLINCLUDE
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
		float4 _MainTex_TexelSize;
		float4 _Color;
		float4 _Font_Color;
		float _Scale;
		float _Alpha;
		float4 _MainTex_ST;
		float _use_Full_Character;
		float _SecondaryEffect;
		float _GrayR;
		float _GrayG;
		float _GrayB;

		float character(int n, float2 p)
		{
			p = floor(p * float2(-4.0, 4.0) + 2.5);
			if (clamp(p.x, 0.0, 4.0) == p.x && clamp(p.y, 0.0, 4.0) == p.y)
			{
				int a = int(round(p.x) + 5.0 * round(p.y));
				if (((n >> a) & 1) == 1)
				{
				if(_SecondaryEffect)
				 return 0.0;
				 else 
				 return 1.0;
				};
			}
				if(_SecondaryEffect)
				 return 1.0;
				 else 
				 return 0.0;
		}

		v2f vert(appdata v)
		{
			v2f o;
			o.vertex = TransformObjectToHClip(v.vertex.xyz);
			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
			return o;
		}

		half4 frag(v2f i) : SV_Target
		{
			//float2 texel = float2(1/_ScreenParams.x,1/_ScreenParams.y)*_Scale;
			float2 texel = _MainTex_TexelSize.xy * _Scale;
			float2 uv = i.uv / texel;
			float3 col = tex2D(_MainTex, floor(uv / 8.0) * 8.0 * texel).rgb;

			float gray = _GrayR * col.r + _GrayG * col.g + _GrayB * col.b;

			int n = 65536;              // .

			if (gray > 0.2) n = 65600;    // :
			if (gray > 0.3) n = 163153;   // *
			if (gray > 0.4) n = 15255086; // o 
			if (gray > 0.5) n = 13121101; // &
			if (gray > 0.6) n = 15252014; // 8
			if (gray > 0.7) n = 13195790; // @
			if (gray > 0.8) n = 11512810; // #

			// full character set including A-Z and 0-9
			if(_use_Full_Character)
			{
				if (gray > 0.0233) n = 4096;
				if (gray > 0.0465) n = 131200;
				if (gray > 0.0698) n = 4329476;
				if (gray > 0.0930) n = 459200;
				if (gray > 0.1163) n = 4591748;
				if (gray > 0.1395) n = 12652620;
				if (gray > 0.1628) n = 14749828;
				if (gray > 0.1860) n = 18393220;
				if (gray > 0.2093) n = 15239300;
				if (gray > 0.2326) n = 17318431;
				if (gray > 0.2558) n = 32641156;
				if (gray > 0.2791) n = 18393412;
				if (gray > 0.3023) n = 18157905;
				if (gray > 0.3256) n = 17463428;
				if (gray > 0.3488) n = 14954572;
				if (gray > 0.3721) n = 13177118;
				if (gray > 0.3953) n = 6566222;
				if (gray > 0.4186) n = 16269839;
				if (gray > 0.4419) n = 18444881;
				if (gray > 0.4651) n = 18400814;
				if (gray > 0.4884) n = 33061392;
				if (gray > 0.5116) n = 15255086;
				if (gray > 0.5349) n = 32045584;
				if (gray > 0.5581) n = 18405034;
				if (gray > 0.5814) n = 15022158;
				if (gray > 0.6047) n = 15018318;
				if (gray > 0.6279) n = 16272942;
				if (gray > 0.6512) n = 18415153;
				if (gray > 0.6744) n = 32641183;
				if (gray > 0.6977) n = 32540207;
				if (gray > 0.7209) n = 18732593;
				if (gray > 0.7442) n = 18667121;
				if (gray > 0.7674) n = 16267326;
				if (gray > 0.7907) n = 32575775;
				if (gray > 0.8140) n = 15022414;
				if (gray > 0.8372) n = 15255537;
				if (gray > 0.8605) n = 32032318;
				if (gray > 0.8837) n = 32045617;
				if (gray > 0.9070) n = 33081316;
				if (gray > 0.9302) n = 32045630;
				if (gray > 0.9535) n = 33061407;
				if (gray > 0.9767) n = 11512810;
			}
				float2 p = fmod(uv / 4, 2) - 1;
				float char = character(n, p);
				col *= char;

				float4 src = tex2D(_MainTex, i.uv);
				if(_SecondaryEffect)
				{
				return lerp(src, float4((col + (1-char)* _Font_Color.rgb) * _Color.rgb, _Color.a), _Alpha);
				}
				else
				return lerp(src, float4(col * _Color.rgb, _Color.a), _Alpha);
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
