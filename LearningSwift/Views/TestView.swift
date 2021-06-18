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
    var module : Module
    var body: some View {
        VStack(spacing: 5) {
        if model.currentQuestion != nil {
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
                        ForEach( 0..<model.currentQuestion!.answers.count) { index in
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
                    //
                    sumbmit = true
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        numCorrect += 1
                    }
                } label: {
                    ZStack {
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        Text("Sumbmit")
                    }
                }
                .disabled(selectedAnswerIndex == nil)

            }
            
            .accentColor(.black)
            .padding()
            .navigationBarTitle("\(model.currentModule?.category ?? "") Test")
        }
        
    }
        .onAppear{
            model.beginTest(module.id)
        }
    }
}
