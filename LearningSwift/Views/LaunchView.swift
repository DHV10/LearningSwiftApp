//
//  LaunchView.swift
//  LearningSwift
//
//  Created by DHV on 30/06/2021.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.loggedIn == false {
            LoginView()
                .onAppear {
                    //check loggin status of user
                    model.checkLogin()
                }
        }else {
            //Tabview show home or profile
            TabView {
                HomeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "book")
                            Text("Learn")
                        }
                    }
                ProfileView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                    }
            }
            .onAppear {
                model.getDatabaseModules()
            }
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
                
                //save progress to database
                model.saveData(writeToDatabase: true)
            }
        }
        
      
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
