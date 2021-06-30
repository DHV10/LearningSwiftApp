//
//  TestView.swift
//  LearningSwift
//
//  Created by DHV on 17/06/2021.
//

import SwiftUI

struct TestView: View {
  
    @EnvironmentObject var model:ContentModel
    //about answer
    @State var selectedAnswerIndex:Int?
    @State var sumbmit = false
    //about amount of correct answer
    @State var numCorrect = 0
    @State var showResult = false
   // var module : Module
    var body: some View {
        VStack(spacing: 5) {
        if model.currentQuestion != nil && showResult == false{
            VStack(alignment: .leading, spacing: 5){
                //question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.questions.count ?? 0)")
                    .padding(.leading , 20)
                //question
                CodeTextView()
                    .padding(.horizontal , 20)
                //answer
                ScrollView {
                    VStack {
                        ForEach( 0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            Button {
                                //
                                selectedAnswerIndex = index
                            } label: {
                                ZStack {
                                    if sumbmit == false {
                                        RectangleCard(color : index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                    }
                                    else {
                                        //answer has been sumbmit
                                        //show green background
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            RectangleCard(color : Color.green)
                                                .frame(height: 48)
                                        }else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex{
                                            RectangleCard(color : Color.red)
                                                .frame(height: 48)
                                        }else if index == model.currentQuestion!.correctIndex {
                                            //show the right answer
                                            RectangleCard(color : Color.green)
                                                .frame(height: 48)
                                                
                                        }else {
                                            RectangleCard(color : Color.white)
                                                .frame(height: 48)
                                        }
                                    }
                                    Text(model.currentQuestion!.answers[index])
                                }
                            }
                            
                            .disabled(sumbmit)
                            .padding([.top, .horizontal], 5)
                        }
                    }
                }
          
                //button sumbit
                
                Button {
                    //question submitted
                    if sumbmit == true {
                        
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                            
                            //check next question and save progress
                            model.nextQuestion()
                            
                            // Show the results
                            showResult = true
                        }else {
                            model.nextQuestion()
                            
                            //set propertty to defaut for the next question
                            sumbmit = false
                            selectedAnswerIndex = nil
                        }
                        
                
                        
                    }else{
                        //question hasnt been submitted
                        sumbmit = true
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            numCorrect += 1
                        }
                    }
                    
                    //
                 
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text(buttonText)
                    }
                }
                .disabled(selectedAnswerIndex == nil)

            }
            
            .accentColor(.black)
            .padding()
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        else if showResult == true {
            ResultTestView(numCorrect: numCorrect)
        }else {
            ProgressView()
        }
        
    }
//        .onAppear{
//            model.beginTest(module.id)
//        }
    }
    
    var buttonText: String {
        //check the answer has been submitted
        if sumbmit == true {
            if  model.currentQuestionIndex + 1 == model.currentModule!.test.questions.count {
                //this is the last question
                return "Finish"
            }
            else {
                return "Next"
            }
        }
        else {
            return "Submit"
        }
    }
}

