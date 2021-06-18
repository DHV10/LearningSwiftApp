//
//  TestView.swift
//  LearningSwift
//
//  Created by DHV on 17/06/2021.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var model:ContentModel
    var module : Module
    var body: some View {
        VStack {
        if model.currentQuestion != nil {
            VStack{
                //question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                //question
                CodeTextView()
            }
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        
    }
        .onAppear{
            model.beginTest(module.id)
        }
    }
}

