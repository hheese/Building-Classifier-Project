//
//  OpenMap.swift
//  Building Classifier Project
//
//  Created by Henry Heese on 4/30/23.
//

import Foundation
import SwiftUI


func OpenMap(set_location: String){
    // search on maps using highest confidence result near mizzou area
    
    // replace spaces with + for url format
    let url_location = set_location.replacingOccurrences(of: " ", with: "+")
    
    // q= performs a search, sll sets location of search
    let url = URL(string: "maps://?q=\(url_location)&sll=38.945191,-92.328801")
    //let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)")
    
    if UIApplication.shared.canOpenURL(url!) {
          UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
}
        
