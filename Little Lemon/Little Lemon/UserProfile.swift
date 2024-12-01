//
//  UserProfile.swift
//  Little Lemon
//
//  Created by Mimi_Son on 01/12/24.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    
    @State private var firstName = UserDefaults.standard.string(forKey: kFirstName) ?? "Mimi"
    @State private var lastName = UserDefaults.standard.string(forKey: kLastName) ?? "Son"
    @State private var email = UserDefaults.standard.string(forKey: kEmail) ?? "mimi@son.com"
    @State private var phoneNumber = "(217) 555-0113" // Default placeholder phone number
    
    @State private var notifications = [
        "Order statuses": true,
        "Password changes": true,
        "Special offers": true,
        "Newsletter": true
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header Section
                    HStack {
                        Button(action: {
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
                                .foregroundColor(.white)
                                .padding()
                                .background(Circle().fill(Color("BackgroundColor")))
                        }
                        
                        Spacer()
                        
                        Image("little-lemon-logo")
                            .resizable()
                            .frame(width: 120, height: 40)
                        
                        Spacer()
                        
                        Image("profile-image-placeholder")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                    
                    // Personal Info Section
                    Text("Personal Information")
                        .font(.title2)
                        .bold()
                        .padding(.top)
                    
                    VStack(alignment: .center, spacing: 10) {
                        // Avatar
                        Image("profile-image-placeholder")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        
                        HStack {
                            Button(action: {
                                print("Change avatar tapped")
                            }) {
                                Text("Change")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("BackgroundColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                print("Remove avatar tapped")
                            }) {
                                Text("Remove")
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Form Fields
                    Group {
                        VStack(alignment: .leading) {
                            Text("First name")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("First name", text: $firstName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Last name")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("Last name", text: $lastName)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Phone number")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            TextField("Phone number", text: $phoneNumber)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.phonePad)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Notifications Section
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Email notifications")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        ForEach(Array(notifications.keys), id: \.self) { key in
                            Toggle(isOn: Binding(
                                get: { notifications[key] ?? false },
                                set: { notifications[key] = $0 }
                            )) {
                                Text(key)
                                    .font(.body)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Buttons Section
                    VStack(spacing: 20) {
                        Button(action: {
                            UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                            self.presentation.wrappedValue.dismiss()
                        }) {
                            Text("Log out")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.yellow)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        HStack(spacing: 15) {
                            Button(action: {
                                print("Discard changes tapped")
                            }) {
                                Text("Discard changes")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.black)
                                    .cornerRadius(8)
                            }
                            
                            Button(action: {
                                saveChanges()
                            }) {
                                Text("Save changes")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color("BackgroundColor"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20) // Ensure the buttons have space at the bottom
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }

    // Save changes
    private func saveChanges() {
        UserDefaults.standard.set(firstName, forKey: kFirstName)
        UserDefaults.standard.set(lastName, forKey: kLastName)
        UserDefaults.standard.set(email, forKey: kEmail)
        print("Changes saved")
    }
}

//#Preview {
//    UserProfile()
//}
