// See https://aka.ms/new-console-template for more information

// This is the tool which tokenize the data , it should generate IDs, Mask and token type ids to the model. 
//Model takes those inputs to generate the embedding vector (float[]), which you store in the vector DB for search
//Read readme to see how to get model.onnx to use here


using System;

namespace EmbeddingServiceApp
{
    internal class Program
    {
        
        static void Main(string[] args)
        {
            var service = new EmbeddingdataPrepare(
            modelPath: "onnx-model/model.onnx",
             tokenizerPath: "onnx-model/tokenizer.json" );

            Console.WriteLine("Embedding Console App"); Console.WriteLine("Type text to embed, or 'exit' to quit.");
            Console.WriteLine("");

            while (true)
            {
                Console.Write("\nInput: "); 
                string? input = Console.ReadLine(); 
                if (string.IsNullOrWhiteSpace(input)) continue; 
                if (input.Equals("exit", StringComparison.OrdinalIgnoreCase)) break;
                float[] vector = service.PrepareModelInputs(input);

                Console.WriteLine($"Embedding length: {vector.Length}");
            }
            
        }
    }
}


