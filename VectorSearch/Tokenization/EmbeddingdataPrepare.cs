using Microsoft.ML.OnnxRuntime;
using Microsoft.ML.OnnxRuntime.Tensors;
using System;
using Tokenizers;
using System.Collections.Generic;
using System.Linq;
using Tokenizers.HuggingFace.Tokenizer;

namespace EmbeddingServiceApp
{
    public class EmbeddingdataPrepare : IDisposable
{
    private readonly InferenceSession _session;
    private readonly Tokenizer _tokenizer;

    public EmbeddingdataPrepare(string modelPath, string tokenizerPath)
    {
        // Load ONNX model
        _session = new InferenceSession(modelPath);

        // Load tokenizer.json
         _tokenizer = Tokenizer.FromFile(tokenizerPath);
    }

    public float[] PrepareModelInputs(string text)
    {
        if (string.IsNullOrWhiteSpace(text))
            throw new ArgumentException("Input text cannot be empty.", nameof(text));
        else Console.WriteLine("User Typed: "+ text);

        // 1. Tokenize
        var encoding = _tokenizer.Encode(text,addSpecialTokens: true,includeAttentionMask: true);

         
        var e = encoding.First();

        var inputIds = e.Ids.ToArray();
        var attentionMask = e.AttentionMask.ToArray();

        Console.WriteLine("IDs: " + string.Join(", ", inputIds));
         Console.WriteLine("Mask: " + string.Join(", ", attentionMask));
         Console.WriteLine("IDs length: " + inputIds.Length); 
         Console.WriteLine("Mask length: " + attentionMask.Length);

        // 2. Create tensors
        var inputIdsTensor = new DenseTensor<long>(new[] { 1, inputIds.Length });
        var attentionMaskTensor = new DenseTensor<long>(new[] { 1, attentionMask.Length });

        for (int i = 0; i < inputIds.Length; i++)
        {
            inputIdsTensor[0, i] = inputIds[i];
            attentionMaskTensor[0, i] = attentionMask[i];
        }

        // 3. Prepare ONNX inputs
        var tokenTypeIdsTensor = new DenseTensor<long>(new[] { 1, inputIds.Length }); for (int i = 0; i < inputIds.Length; i++) { tokenTypeIdsTensor[0, i] = 0; }
        var inputs = new List<NamedOnnxValue>
        {
            NamedOnnxValue.CreateFromTensor("input_ids", inputIdsTensor),
            NamedOnnxValue.CreateFromTensor("attention_mask", attentionMaskTensor),
            NamedOnnxValue.CreateFromTensor("token_type_ids", tokenTypeIdsTensor)
        };


        // 4. Run inference
        using var results = _session.Run(inputs);

        // 5. Extract embedding (first output)
        var embedding = results.First().AsEnumerable<float>().ToArray();

        return embedding;
    }

    public void Dispose()
    {
        _session?.Dispose();
    }
}


}
