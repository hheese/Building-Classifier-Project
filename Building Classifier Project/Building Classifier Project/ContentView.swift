//
//  ContentView.swift
//  Building Classifier Project
//
//  Created by Henry Heese on 2/10/23.
//

import SwiftUI

struct ContentView: View {
    @State var isPresenting: Bool = false
    @State var uiImage: UIImage?
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @ObservedObject var classifier: ImageClassifier
    
    @State private var showingPopover = false
    @State var set_model = 0
    // Models changed in Classifier/Classifier.swift
    
    var body: some View {
        NavigationView {
            ZStack{
                Color.black.ignoresSafeArea()
                VStack{
                    Text("Building Classifier")
                        .font(.title)
                        .foregroundColor(.gray)
                    
                    Rectangle()
                        .strokeBorder()
                        .foregroundColor(.yellow)
                        .overlay(
                            Group {
                                if uiImage != nil {
                                    // If image set, display it and run model
                                    Image(uiImage: uiImage!)
                                        .resizable()
                                        .scaledToFit()
                                        .onChange(of: uiImage) { newValue in
                                            if newValue != nil {
                                                classifier.detect(uiImage: uiImage!, set_model: set_model)
                                            }
                                        }
                                    
                                } else {
                                    // Display welcome message before image set
                                    VStack(){
                                        Spacer()
                                        Text("Welcome to the MIZZOU Building Classifier.")
                                            .font(.system(size: 26))
                                            .foregroundColor(.yellow)
                                            .padding(40)
                                        
                                        Text("Select or Take a Photo")
                                            .font(.system(size: 22))
                                            .foregroundColor(.yellow)
                                        Spacer()
                                    }.frame(alignment: .center)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        )
                    
                    VStack{
                        HStack(spacing: 50){
                            Image(systemName: "photo")
                                .onTapGesture {
                                    isPresenting = true
                                    sourceType = .photoLibrary
                                }
                                .font(.system(size: 18))
                                .scaleEffect(2.0)
                            
                            Picker(selection: $set_model, label: Text("Model Selection")) {
                                Text("The Quad").tag(1) // maps to models in classifier
                                Text("Lowry Mall").tag(2)
                                Text("Traditions Plaza").tag(3)
                                Text("Unity Fountain").tag(4)
                                Text("Memorial Union").tag(5)
                                
                            }
                            .onChange(of: set_model) { _ in
                                if uiImage != nil {
                                    classifier.detect(uiImage: uiImage!, set_model: set_model)
                                }
                            }
                            // Navigate to Camera View
                            NavigationLink(destination: CameraView(capturedImage: $uiImage)) {
                                Image(systemName: "camera")
                                    .font(.system(size: 18))
                                    .scaleEffect(2.0)
                            } // when uiImage is updated, run the model on the image
                            .onChange(of: uiImage) { newValue in
                                if newValue != nil {
                                    classifier.detect(uiImage: uiImage!, set_model: set_model)
                                }
                            }
                        }
                        .font(.title)
                        .foregroundColor(.blue)
                        .padding(2)
                        
                        Group {
                            if let imageClass = classifier.imageClass {
                                //                                var formattedConfidenceScores: [String] { // holds top 3 confidence scores
                                //                                    return imageClass.map { NumberFormatter.localizedString(from: NSNumber(value: $0.confidence), number: .percent) }
                                //                                }
                                let formattedConfidenceScores = imageClass.map { NumberFormatter.localizedString(from: NSNumber(value: $0.confidence), number: .percent) }
                                
                                let prediction = imageClass.map { $0.label } // holds top three predictions
                                
                                
                                VStack {
                                    if !prediction.isEmpty && !formattedConfidenceScores.isEmpty{
                                        HStack {
                                            // map button on far right
                                            Spacer()
                                            
                                            Button {
                                                OpenMap(set_location: prediction[0])
                                            } label: {
                                                Label("", systemImage: "map")
                                            }.font(.system(size: 19))
                                                .scaleEffect(1.7)
                                            
                                        }.offset(y: 30)
                                            .frame(height: 0)
                                        HStack {
                                            Text("This is:")
                                                .font(.system(size: 19))
                                                .foregroundColor(.white)
                                            Text((prediction[0]))
                                                .bold()
                                                .foregroundColor(.white)
                                                .font(.system(size: 19))
                                                .foregroundColor(.white)
                                        }
                                        //                                        Text((prediction[1]) + ".") // Placeholder: need to decide where to put extra predictions
                                        //                                            .bold()
                                        //                                            .foregroundColor(.white)
                                        //                                            .font(.caption)
                                        //                                            .foregroundColor(.white)
                                        //                                        Text((prediction[2]) + ".")
                                        //                                            .bold()
                                        //                                            .foregroundColor(.white)
                                        //                                            .font(.caption)
                                        //                                            .foregroundColor(.white)
                                        Text(formattedConfidenceScores[0] + " confidence score")
                                            .foregroundColor(.white)
                                            .font(.system(size: 18))
                                        //                                        Text(formattedConfidenceScores[1]) // Placeholder: need to decide where to put additional confidence scores
                                        //                                            .foregroundColor(.white)
                                        //                                            .font(.caption)
                                        //                                        Text(formattedConfidenceScores[2])
                                        //                                            .foregroundColor(.white)
                                        VStack() {
                                            if (formattedConfidenceScores[0] != "100%") {
                                            
                                                Button("Show More") {
                                                    showingPopover = true
                                                }
                                                .popover(isPresented: $showingPopover) {
                                                    ZStack() {
                                                        Color.black.ignoresSafeArea()
                                                        VStack() {
                                                            Text(prediction[0] + " : " + formattedConfidenceScores[0])
                                                                .font(.system(size: 24))
                                                                .foregroundColor(.white)
                                                                .padding()
                                                            Text(prediction[1] + " : " + formattedConfidenceScores[1])
                                                                .font(.system(size: 24))
                                                                .foregroundColor(.white)
                                                                .padding()
                                                            
                                                            let int0 = Int(formattedConfidenceScores[0].prefix(2))
                                                            if formattedConfidenceScores[1].count == 3 {
                                                                let int1 = Int(formattedConfidenceScores[1].prefix(2))
                                                                if (int0! + int1! < 100) {
                                                                    Text(prediction[2] + " : " + formattedConfidenceScores[2])
                                                                        .font(.system(size: 24))
                                                                        .foregroundColor(.white)
                                                                        .padding()
                                                                }
                                                            } else {
                                                                let int1 = Int(formattedConfidenceScores[1].prefix(1))
                                                                if (int0! + int1! < 100) {
                                                                    Text(prediction[2] + " : " + formattedConfidenceScores[2])
                                                                        .font(.system(size: 24))
                                                                        .foregroundColor(.white)
                                                                        .padding()
                                                                }
                                                            }
                                                            
                                                            
                                                            
                                                            
                                                        
                                                        }
                                                    }
                                                }
                                            }
                                        }.frame(height: 10)
                                    }
                                    else{
                                        // show nothing when no image selected
                                    }
                                }
                                .frame(height: 40)
                            }
                        }
                        .font(.subheadline)
                        .padding()
                        
                    }
                }
                
                .sheet(isPresented: $isPresenting){
                    ImagePicker(uiImage: $uiImage, isPresenting:  $isPresenting, sourceType: $sourceType)
                        .onDisappear{
                            if uiImage != nil {
                                classifier.detect(uiImage: uiImage!, set_model: set_model)
                            }
                        }
                }
                
                .padding()
            }
            
        }.navigationTitle("Navigation Menu")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(classifier: ImageClassifier())
    }
}

