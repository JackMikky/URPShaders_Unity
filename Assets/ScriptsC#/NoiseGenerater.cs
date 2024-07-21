using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class NoiseGenerater : MonoBehaviour
{
    [System.Serializable]
    public class NoiseProps
    {
        internal Material _material { get; set;}
        [SerializeField] string NoiseName;
        [Header("Duration Time")]
        public float minTime;
        public float maxTime;
        public string ShaderPropertyReference;
        [Range(0, 100)] public float Probability = 50;
        public float intervalTime = 1f;
    }
  
    [SerializeField] Material material;

    [SerializeField] List<Noise> Noises;

    public List<NoiseProps> NoisePropsList;

    private void Start()
    {
        foreach (var (props,index) in NoisePropsList.Select((props,index)=>(props,index)))
        {
            props._material = this.material;
            Noises[index].SetProps(props);
            Noises[index].StartCoroutine("NoiseInvoker");
        }
#if !UNITY_EDITOR
        Noises = null;
#endif
        NoisePropsList = null;
    }
}


