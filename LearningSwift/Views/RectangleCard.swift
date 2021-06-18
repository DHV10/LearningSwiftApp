//
//  RectangleCard.swift
//  LearningSwift
//
//  Created by DHV on 17/06/2021.
//

import SwiftUI

struct RectangleCard: View {
    var color = Color.white
    var body: some View {
        Rectangle()
            
            .foregroundColor(color)
            .cornerRadius(10)
          .shadow(radius: 2)
    }
}

struct RectangleCard_Previews: PreviewProvider {
    static var previews: some View {
        RectangleCard(color: Color.white)
    }
}
