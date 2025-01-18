import SwiftUI

struct LoginPage: View {
    @State private var email = ""
    @State private var password = ""
    @State private var currentFactIndex = 0
    @State private var isAnimating = false
    @State private var navigateToHome = false // Controls navigation to HomePage
    @State private var keyboardHeight: CGFloat = 0 // Track keyboard height

    let facts = [
        "Recycling one aluminum can saves enough energy to power a TV for three hours!",
        "Glass and aluminum can be recycled endlessly without losing quality or purity.",
        "Recycling plastic reduces landfill waste and conserves natural resources.",
        "Recycling one ton of paper can save 17 trees and 7,000 gallons of water.",
        "Every bit of recycling helps reduce greenhouse gas emissions!",
        "Plastic bottles take upwards of 700 years to decompose.",
        "Electronic waste, or e-waste, is the fastest-growing source of waste globally.",
        "76% of recyclables are lost at the household level.",
        "Recycling one glass bottle saves enough energy to power a 100-watt lightbulb for 4 hours!",
        "The first recorded instance of recycling is paper recycling in Japan in 1031.",
        "A recycled glass container can be back on shelves as fast as 30 days!",
        "During the time it takes you to read this sentence, 50,000 12-ounce cans are made."
    ]

    var body: some View {
        NavigationView {
            VStack {
                // Login Header with "About" link in the top-right corner
                HStack {
                    Spacer()
                    NavigationLink(destination: AboutPageView()) {
                        Text("About")
                            .font(.subheadline)
                            .foregroundColor(Color("DarkBrown"))
                            .padding(.top, 10)
                    }
                    .padding(.trailing, 20)
                }

                Spacer()

                // App Logo
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.bottom, 20)

                // Rotating Facts
                factRotationView()

                // Login Form
                VStack(spacing: 20) {
                    loginFields()
                    loginButton()
                    createAccountButton()
                }
                .padding(.top, 20)
                .padding(.bottom, keyboardHeight) // Adjust for keyboard height

                Spacer()

                // Footer
                Text("Powered by Google Cloud Vision AI")
                    .font(.footnote)
                    .foregroundColor(Color("DarkBrown"))
                    .padding(.bottom, 30)
            }
            .background(Color("Cream").edgesIgnoringSafeArea(.all))
            .onAppear(perform: setupKeyboardObservers)
            .onDisappear(perform: removeKeyboardObservers)
        }
    }

    // MARK: - Fact Rotation View
    private func factRotationView() -> some View {
        ZStack {
            ForEach(facts.indices, id: \.self) { index in
                if index == currentFactIndex {
                    Text(facts[index])
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                        .offset(x: isAnimating ? UIScreen.main.bounds.width : 0)
                        .animation(.easeInOut(duration: 0.6), value: isAnimating)
                } else if index == (currentFactIndex + 1) % facts.count {
                    Text(facts[index])
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 30)
                        .frame(maxWidth: .infinity)
                        .fixedSize(horizontal: false, vertical: true)
                        .offset(x: isAnimating ? 0 : -UIScreen.main.bounds.width)
                        .animation(.easeInOut(duration: 0.6), value: isAnimating)
                }
            }
        }
        .onAppear {
            startFactRotation()
        }
    }

    // MARK: - Login Fields
    private func loginFields() -> some View {
        VStack(spacing: 20) {
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color("DarkBrown").opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 40)

            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color("DarkBrown").opacity(0.2), radius: 8, x: 0, y: 4)
                .padding(.horizontal, 40)
        }
    }

    // MARK: - Login Button
    private func loginButton() -> some View {
        NavigationLink(
            destination: HomePage(), // Navigate to the HomePage
            isActive: $navigateToHome,
            label: {
                Button(action: loginAction) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.65)
                        .background(Color("DarkBrown"))
                        .cornerRadius(12)
                        .shadow(radius: 5)
                }
            }
        )
    }

    // MARK: - Create Account Button
    private func createAccountButton() -> some View {
        Button(action: createAccountAction) {
            Text("Create Account")
                .font(.subheadline)
                .foregroundColor(Color("DarkBrown"))
                .padding(.top, 20)
        }
    }

    // MARK: - Fact Rotation Logic
    private func startFactRotation() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: true) { _ in
            withAnimation {
                isAnimating.toggle()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                currentFactIndex = (currentFactIndex + 1) % facts.count
                isAnimating.toggle()
            }
        }
    }

    // MARK: - Button Actions
    private func loginAction() {
        // Perform login logic here
        print("Login action triggered")
        navigateToHome = true // Navigate to the homepage
    }

    private func createAccountAction() {
        print("Create Account action triggered")
    }

    // MARK: - Keyboard Observers
    private func setupKeyboardObservers() {
        // Listen for keyboard appearance
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                self.keyboardHeight = keyboardFrame.height
            }
        }

        // Listen for keyboard disappearance
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.keyboardHeight = 0
        }
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - About Page View
struct AboutPageView: View {
    var body: some View {
        AboutPage()
    }
}

// MARK: - Preview
struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
