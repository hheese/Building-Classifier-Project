//
//  Classifier.swift
//  Building Classifier Project
//
//  Created by Henry Heese on 2/10/23.
//

import CoreML
import Vision
import CoreImage

struct Classifier {

//    private(set) var results: String?
//    private(set) var confidenceScore: Float?
    private(set) var predictions: [(label: String, confidence: Float)]? = []
    
    mutating func detect(ciImage: CIImage, set_model: Int) {
        
        // defaults to one model, then checks for set_model
        guard var model = try? VNCoreMLModel(for: Quad(configuration: MLModelConfiguration()).model)
        else {
            return
        }
        switch (set_model) { // update once new models added
            case 1: model = try! VNCoreMLModel(for: Quad(configuration: MLModelConfiguration()).model)
            case 2: model = try! VNCoreMLModel(for: Lowry_Mall(configuration: MLModelConfiguration()).model)
            case 3: model = try! VNCoreMLModel(for: Traditions_Plaza(configuration: MLModelConfiguration()).model) // Tradition Plaza
            case 4: model = try! VNCoreMLModel(for: Unity_Fountain(configuration: MLModelConfiguration()).model) //
            case 5: model = try! VNCoreMLModel(for: Memorial_Union(configuration: MLModelConfiguration()).model) // memorial
        default: break
        }

        let request = VNCoreMLRequest(model: model)

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])

        try? handler.perform([request])
        
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        let topResults = results.prefix(3)
        
        self.predictions = topResults.map { ($0.identifier, $0.confidence) }
        
//        for i in 0..<min(3,results.count){
//            predictions.append(results[i].identifier)
//            confidenceScores.append(results[i].confidence)
//        }
        
//        self.results = predictions.joined(separator: ", ")
        
//        if let firstResult = results.first {
//            self.results = firstResult.identifier
//            self.confidenceScore = firstResult.confidence
//        }


    }

}

