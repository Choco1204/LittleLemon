import SwiftUI

let kFirstName = "first name key"
let kLastName = "last name key"
let kEmail = "email key"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var isLoggedIn: Bool = false

    func signIn() {
        if firstName.isEmpty || lastName.isEmpty || email.isEmpty {
            print("Error: All fields are required.")
        } else {
            UserDefaults.standard.set(firstName, forKey: kFirstName)
            UserDefaults.standard.set(lastName, forKey: kLastName)
            UserDefaults.standard.set(email, forKey: kEmail)
            UserDefaults.standard.set(true, forKey: kIsLoggedIn) // Store login status
            isLoggedIn = true
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Home(), isActive: $isLoggedIn) {
                    EmptyView()
                }
                logoSection
                
                headerSection
                
                Spacer()
                
                TextField("First Name", text: $firstName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Last Name", text: $lastName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)

                Button(action: signIn) {
                    Text("Register")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.top)
            }
            .onAppear {
                if UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                    isLoggedIn = true
                }
            }
        }
    }
}
private var logoSection: some View {
    HStack {
        Image("little-lemon-logo")
            .resizable()
            .frame(width: 150, height: 50) // Adjust size as per the logo's dimensions

        Spacer()

        Image("profile-image-placeholder")
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    .padding(.horizontal)
}

// MARK: - Header Section
private var headerSection: some View {
    HStack(alignment: .top, spacing: 10) {
        VStack(alignment: .leading, spacing: 10) {
            Text("Little Lemon")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.yellow)
            
            Text("Chicago")
                .font(.title2)
                .foregroundColor(.white)
            
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .font(.body)
                .foregroundColor(.white)
            HStack {
                                Image(systemName: "magnifyingglass")
                                    .font(.title)
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(Color.white) // Circle background for the magnifying glass
                                    .clipShape(Circle()) // Make it a perfect circle
                            }
                            .frame(maxWidth: .infinity, alignment: .leading) // Center horizontally
                            .padding(.top, 10)
        }

        Spacer()

        Image("Greek-salad") // Replace with your food image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 120, height: 120)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    .padding()
    .background(Color(red: 73 / 255, green: 94 / 255, blue: 87 / 255)) // Background color #495E57
    .cornerRadius(10)
}

//#Preview{
//    Onboarding()
//}
