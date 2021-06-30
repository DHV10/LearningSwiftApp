//
//  ProfileView.swift
//  LearningSwift
//
//  Created by DHV on 30/06/2021.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @EnvironmentObject var model: ContentModel
    var body: some View {
        Button {
            //sign out this user
            try! Auth.auth().signOut()
            //mode
            
            model.checkLogin()
        } label: {
            Text("Sign Out")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
