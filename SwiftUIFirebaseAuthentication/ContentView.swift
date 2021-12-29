//
//  ContentView.swift
//  SwiftUIFirebaseAuthentication
//
//  Created by Julian on 29.12.21.
//

import SwiftUI
import FirebaseAuth

class AppViewModel: ObservableObject {
        
    @Published var signedIn = false
    
    var isSignedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func loginUser(_email: String, _password: String) {
        
        Auth.auth().signIn(withEmail: _email, password: _password) { [weak self] (result, error) in
            if let err = error {
                print(err)
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func createUser(_email: String, _password: String) {
        
        Auth.auth().createUser(withEmail: _email, password: _password) { [weak self] (result, error) in
            if let err = error {
                print(err)
                return
            }
            
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func logoutUser() {
        
        do {
            try Auth.auth().signOut()
            self.signedIn = false
            
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var viewModel: AppViewModel
        
    var body: some View {
        NavigationView {
            if viewModel.signedIn {
                VStack {
                    Text("You are signed in!")
                    Button(action: {
                        viewModel.logoutUser()
                    }, label: {
                        Text("Logout")
                            .frame(width: 200, height: 50)
                            .background(Color.red)
                            .foregroundColor(Color.white)
                            .padding()
                    })
                }
            } else {
                SignInView()
            }
        }
        .onAppear {
            viewModel.signedIn = viewModel.isSignedIn
        }
    }
}

struct SignInView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else { return }
                    
                    viewModel.loginUser(_email: email, _password: password)
                }) {
                    HStack {
                        Image("login")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .font(.body)
                        Text("Login")
                            .fontWeight(.medium)
                            .font(.body)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(40)
                }
                    .padding()
                Spacer()
                
                NavigationLink("Create Account", destination: SignUpView())
                    .padding()
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding()
            Spacer()
        }
        .navigationTitle("Login")
    }
}

struct SignUpView: View {
    
    @State var email = ""
    @State var password = ""
    
    @EnvironmentObject var viewModel: AppViewModel
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            VStack {
                TextField("email", text: $email)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                SecureField("password", text: $password)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                
                Button(action: {
                    
                    guard !email.isEmpty, !password.isEmpty else { return }
                    
                    viewModel.createUser(_email: email, _password: password)
                }) {
                    HStack {
                        Image("register")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .font(.body)
                        Text("Sign Up")
                            .fontWeight(.medium)
                            .font(.body)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(40)
                }
                .padding()
                Spacer()
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Sign Up")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
