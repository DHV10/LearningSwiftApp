//
//  ContentView.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var model: ContentModel
    var body: some View {
        
        NavigationView {
            VStack(alignment: .leading) {
                Text("What do you do today ? ")
                    .padding(.leading, 20)
                ScrollView {
                    LazyVStack(spacing: 5) {
                        ForEach(model.modules) { module in
                            VStack(spacing: 20) {
                                NavigationLink(
                                    destination:
                                        ContentView()
                                        .onAppear(perform:
                                                    {
                                                        model.getLessons(module: module) {
                                                            model.beginModule(module.id)
                                                        }
                                         
                                                       // print(model.currentContentSelected)
                                        }),
                                    tag: module.id.hash,
                                    selection: $model.currentContentSelected,
                                   
                                    label: {
                                        // learn card
                                        HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: "\(module.content.time)")

                                       
                                
                                    })

//                                NavigationLink(destination: EmptyView()) { }
                                
                                NavigationLink(destination:
                                                TestView()
                                                .onAppear(perform: {
                                                    model.getQuestions(module: module) {
                                                        model.beginTest(module.id)
                                                    }
                                                   
                                                })
                                               
                                               , tag: module.id.hash, selection: $model.currentTestSelected) {
                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: "\(module.test.time)")
                                }
                            }
                            .padding(.bottom , 8)
                     
                            // test card
                           
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                    .navigationTitle("Get Started")
                    .onChange(of: model.currentContentSelected) { changedValue in
                        if changedValue == nil {
                            model.currentModule = nil
                        }
                    }
                    .onChange(of: model.currentTestSelected) { changedValue in
                        if changedValue == nil {
                            model.currentModule = nil
                        }
                    }
                }
            }
           
        }
        
     
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(ContentModel())
    }
}
