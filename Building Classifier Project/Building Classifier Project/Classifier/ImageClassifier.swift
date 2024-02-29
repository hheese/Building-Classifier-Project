//
//  ImageClassifier.swift
//  Building Classifier Project
//
//  Created by Henry Heese on 2/10/23.
//

import SwiftUI

class ImageClassifier: ObservableObject {
    
    @Published private var classifier = Classifier()
    
    var imageClass: [(label: String, confidence: Float)]?{
        return (classifier.predictions)
    }
//    var imageClass: String? {
//        classifier.results
//    }
    
    // MARK: Intent(s)
    func detect(uiImage: UIImage, set_model: Int) {
        guard let ciImage = CIImage (image: uiImage) else { return }
        classifier.detect(ciImage: ciImage, set_model: set_model)
        
    }
        
}
