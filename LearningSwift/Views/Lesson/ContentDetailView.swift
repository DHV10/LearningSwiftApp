//
//  ContentDetailView.swift
//  LearningSwift
//
//  Created by DHV on 16/06/2021.
//

import SwiftUI
import AVKit

struct ContentDetailView: View {
    @EnvironmentObject var model : ContentModel
    var body: some View {

        let lesson = model.currentLesson
        let url = URL(string: Contants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            //video
            if url != nil {
                VideoPlayer(player: AVPlayer(url: url!))
                    .cornerRadius(10)
            }
            //description
            CodeTextView()
            //show button next lesson only when have the next lesson
            
            if model.hasNextLesson() {
                Button {
                    model.nextLesson()
                } label: {
                    ZStack{
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                           
                        Text("Next Lesson : \(model.currentModule!.content.lessons[model.currentLessonIndex+1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }

            }
            else {
                Button {
                   model.currentContentSelected = nil
                } label: {
                    ZStack{
                        RectangleCard(color: Color.green)
                            .frame(height: 48)
                            
                        Text("Complete")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
            }
        }
        .padding()
        .navigationBarTitle(lesson?.title ?? "")
       
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
