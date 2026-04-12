Shader "CustomRenderFeature/HeartMosaic"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MosaicIntensity ("Mosaic Intensity", Float) = 10.0
    }
    
    SubShader
    {
        Tags { "RenderType"="Opaque" "RenderPipeline" = "UniversalPipeline"}
        LOD 100
        ZWrite Off Cull Off
        
        Pass
        {
            Name "HeartMosaicPass"
            
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Assets/ShaderFunctionScripts/ShaderUtility.hlsl"
            #include "Assets/ShaderFunctionScripts/HeartMosaic.hlsl"
            
            struct Attributes
            {
                float4 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };
            
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };
            
            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            
            CBUFFER_START(UnityPerMaterial)
                float4 _MainTex_ST;
                float4 _MainTex_TexelSize;
                float _MosaicIntensity;
            CBUFFER_END
            
            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS.xyz);
                output.uv = input.uv;
                return output;
            }
            
            half4 frag(Varyings input) : SV_Target
            {
                float2 resolution = float2(1.0 / _MainTex_TexelSize.x, 1.0 / _MainTex_TexelSize.y);
                return HeartMosaic(input.uv, resolution, TEXTURE2D_ARGS(_MainTex, sampler_MainTex), _MainTex_TexelSize, _MosaicIntensity);
            }
            ENDHLSL
        }
    }
}