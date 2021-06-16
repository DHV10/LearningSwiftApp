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
            
            //show button next lesson only when have the next lesson
            
            if model.hasNextLesson() {
                Button {
                    model.nextLesson()
                } label: {
                    ZStack{
                        Rectangle()
                            .frame(height: 48)
                            .foregroundColor(.green)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        Text("Next Lesson : \(model.currentModule!.content.lessons[model.currentLessonIndex+1].title)")
                            .foregroundColor(.white)
                            .bold()
                    }
                }

            }
        }
        .padding()
       
        
    }
}

struct ContentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContentDetailView()
    }
}
