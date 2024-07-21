using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using static NoiseGenerator;

public class Noise : MonoBehaviour
{
    Material _material { get; set; }
    [SerializeField] float minTime;
    [SerializeField] float maxTime;
    [SerializeField] string ShaderPropertyReference;
    [SerializeField] float Probability = 50;
    [SerializeField] float intervalTime = 1f;
    public void SetProps(NoiseProps noiseProps)
    {
        this._material = noiseProps._material;
        this.minTime = noiseProps.minTime;
        this.maxTime = noiseProps.maxTime;
        this.ShaderPropertyReference = noiseProps.ShaderPropertyReference;
        this.Probability = noiseProps.Probability;
        this.intervalTime = noiseProps.intervalTime;
    }
    bool CalculateProbability()
    {
        var r = Random.Range(0, 100f);
        if (r <= Probability)
        {
            return true;
        }
        else
        {
            return false;
        }
    }

    public IEnumerator NoiseInvoker()
    {
        for (; ; )
        {
            _material.SetFloat(ShaderPropertyReference, 0);
            if (CalculateProbability())
            {
                _material.SetFloat(ShaderPropertyReference, 1);
                var durationTime = Random.Range(minTime, maxTime);
                yield return new WaitForSeconds(durationTime);
            }
            else
            {
                yield return new WaitForSeconds(intervalTime);
            }
        }
    }
    private void OnDestroy()
    {
        StopAllCoroutines();
        _material.SetFloat(ShaderPropertyReference, 0);
    }
}