import SwiftUI

struct AboutPage: View {
    var body: some View {
        VStack {
            // Bin Buddy Logo
            Image("Logo") // Replace with the actual logo image
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding(.top, 65)
            
            // Mission Statement
            Text("Our Mission")
                .font(.headline)
                .foregroundColor(Color("DarkBrown"))
                .padding(.top, -45)
            
            Text("BinBuddy is dedicated to using AI to help individuals reduce their waste and recycle more effectively. By using smart technology, we aim to build a greener future together.")
                .font(.body)
                .foregroundColor(Color("DarkBrown"))
                .padding(.horizontal, 20)
                .multilineTextAlignment(.center)
                .padding(.top, 10)
            
            // AI Use Disclaimer
            Text("AI Use Disclaimer")
                .font(.headline)
                .foregroundColor(Color("DarkBrown"))
                .padding(.top, 20)
            
            VStack(alignment: .leading, spacing: 15) {
                // Paw Bullet Points
                Text("🐾 BinBuddy uses AI to analyze and identify trash items, which requires energy and computational resources.")
                    .font(.body)
                    .foregroundColor(Color("DarkBrown"))
                    .multilineTextAlignment(.leading)
                
                Text("🐾 While the environmental cost of AI is a valid concern, AI is here to stay, and embracing AI responsibly allows us to make a positive impact.")
                    .font(.body)
                    .foregroundColor(Color("DarkBrown"))
                    .multilineTextAlignment(.leading)
                
                Text("🐾 By leveraging AI, BinBuddy empowers individuals to take small, actionable steps toward sustainability, proving that technology can be a force for good in building a greener future.")
                    .font(.body)
                    .foregroundColor(Color("DarkBrown"))
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)

            Spacer()
        }
        .background(Color("Cream"))
        .edgesIgnoringSafeArea(.all)
    }
}
