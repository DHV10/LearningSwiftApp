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
                    LazyVStack(spacing: 20) {
                        ForEach(model.modules) { module in
                           
                            NavigationLink(
                                destination:
                                    ContentView()
                                    .onAppear(perform:
                                                {
                                        model.beginModule(module.id)
                                                   // print(model.currentContentSelected)
                                    }),
                                tag: module.id,
                                selection: $model.currentContentSelected,
                               
                                label: {
                                    // learn card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.lessons.count) Lessons", time: "\(module.content.time)")

                                   
                            
                                })

                            // test card
                            HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.questions.count) Questions", time: "\(module.test.time)")
                            
                        }
                    }
                    .accentColor(.black)
                    .padding()
                    .navigationTitle("Get Started")
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
