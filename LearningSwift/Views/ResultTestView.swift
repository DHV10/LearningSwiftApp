//
//  ResultTestView.swift
//  LearningSwift
//
//  Created by DHV on 18/06/2021.
//

import SwiftUI

struct ResultTestView: View {
    @EnvironmentObject var model: ContentModel
    var numCorrect: Int
    
    var resultHandle: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double (numCorrect) / Double (model.currentModule!.test.questions.count)
        
        if pct > 0.5 {
            return "Doing great"
        }else if pct > 0.2 {
            return "Good"
        }else {
            return "Try more"
        }
        
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text(resultHandle)
                .bold()
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            
            Spacer()
            
            Text("Result is \(numCorrect) of \(model.currentModule?.test.questions.count ?? 0)")
            Spacer()
            Button(action: {
                model.currentTestSelected = nil
            }, label: {
                ZStack {
                    RectangleCard(color: Color.green)
                        .frame(height: 48)
                    Text("Complete")
                        .bold()
                        .foregroundColor(.white)
                }
            })
            .padding()
            Spacer()
        }
    }
}

