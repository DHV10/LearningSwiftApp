//
//  HomeViewRow.swift
//  LearningSwift
//
//  Created by DHV on 14/06/2021.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    var body: some View {
        
        
        ZStack {
            //background
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
//                            .frame(width: 336, height: 215, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            //content
            HStack(spacing: 30) {
                //image
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                VStack(alignment: .leading, spacing: 10) {
                    //title
                    Text(title)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    //description
                    Text(description)
                        .font(.footnote)
                        .padding(.bottom , 30)
                    HStack(spacing: 10) {
                        // count question/ lessons
                        HStack {
                            Image(systemName: "book.closed")
                            Text(count)
                                .font(Font.system(size: 10))
                        }
                        
                        //timer
                        HStack {
                            Image(systemName: "clock")
                            Text(time)
                                .font(Font.system(size: 10))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct HomeViewRow_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewRow(image: "swift", title: "Learn Swift", description: "some text", count: "12", time: "14")
            .environmentObject(ContentModel())
    }
}
