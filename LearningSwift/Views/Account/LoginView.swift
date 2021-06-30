//
//  LoginView.swift
//  LearningSwift
//
//  Created by DHV on 30/06/2021.
//

import SwiftUI
import FirebaseAuth
import Firebase

struct LoginView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var loginMode = Contants.LogginMode.login
    @State var email: String = ""
    @State var name: String = ""
    @State var password: String = ""
    @State var errorMessage: String?
    
    var buttonText: String {
        
        if loginMode == Contants.LogginMode.login {
            return "Login"
        }else {
            return "Sign Up"
        }
    }
    
    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            //Logo
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 150)
            
            //Title
            Text("Learning App")
            Spacer()
            //Picker
            Picker(selection: $loginMode, label: Text("Picker")) {
                
                Text("Login")
                    .tag(Contants.LogginMode.login)
                
                Text("Sign up")
                    .tag(Contants.LogginMode.createAccount)
            }
            .pickerStyle(SegmentedPickerStyle())
            
            //Form
            Group {
                TextField("Email", text: $email)
                
                if loginMode == Contants.LogginMode.createAccount {
                    TextField("Name", text: $name)
                }
                
                SecureField("Password", text: $password)
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
            }
            //Button
            Button(action: {
                
                if loginMode == Contants.LogginMode.login {
                    //log in for this user
                    Auth.auth().signIn(withEmail: email, password: password) { result, error in
                        
                        //check for the error
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        //clear the error message
                        self.errorMessage = nil
                        
                        //fetch the user data
                        self.model.getUserData()
                        
                        //change login view
                        self.model.checkLogin()
                        
                    }
                }else {
                    //Create an new accout
                    Auth.auth().createUser(withEmail: email, password: password) { result, error in
                        
                        //check for the error
                        guard error == nil else {
                            self.errorMessage = error!.localizedDescription
                            return
                        }
                        
                        //clear the error message
                        self.errorMessage = nil
                        
                        //save name user
                        let username = Auth.auth().currentUser
                        let db = Firestore.firestore()
                        let ref = db.collection("user").document(username!.uid)
                        
                        ref.setData(["name":name], merge: true)
                        
                        //Update the user data
                        let user = UserService.shared.user
                        user.name = name
                        
                        //change login view
                        self.model.checkLogin()
                        
                    }
                }
            }, label: {
                
                ZStack {
                    Rectangle()
                        .foregroundColor(.green)
                        .frame(height: 40)
                        .cornerRadius(10)
                    
                    Text(buttonText)
                        .foregroundColor(.white)
                }
            })
            Spacer()
        }
        .padding(.horizontal, 40)
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
