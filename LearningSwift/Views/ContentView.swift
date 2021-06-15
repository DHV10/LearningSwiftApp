//
//  ContentView.swift
//  LearningSwift
//
//  Created by DHV on 15/06/2021.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
                
               //confirm that curent module is set
                if model.currentModule != nil {
                    
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        
                        ContentViewRow(index: index)
                    }
                }
                
            }
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
