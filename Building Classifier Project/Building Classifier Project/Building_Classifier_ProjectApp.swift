//
//  Building_Classifier_ProjectApp.swift
//  Building Classifier Project
//
//  Created by Henry Heese on 2/10/23.
//

import SwiftUI

@main
struct Building_Classifier_ProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(classifier: ImageClassifier())
        }
    }
}
