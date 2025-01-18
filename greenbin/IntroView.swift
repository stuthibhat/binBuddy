import SwiftUI

// IntroPage: Displays the BinBuddy logo and intro text
struct IntroPage: View {
    var body: some View {
        ZStack {
            Color("Cream").edgesIgnoringSafeArea(.all) // Background color

            VStack {
                Image("Logo") // Ensure your logo image is named "Logo" in the asset catalog
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.top, 50)

                Text("Your smart companion")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("DarkBrown"))
                    .padding(.top, -25)

                Text("for a sustainable future")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("DarkBrown"))
            }
        }
    }
}

// RascalPage: Displays Rascal's dialogue and transitions to the fact pages
struct RascalPage: View {
    @State private var currentDialogue = 0
    @State private var displayedText = ""
    @State private var showTapToContinue = false
    @State private var navigateToFactPage = false

    let dialogues = [
        "Hey there! I'm Rascal, your recycling sidekick!",
        "I'll help you figure out what can and can't be recycled, so we can work together to keep our planet clean!",
        "But before we dive into the trash, let's explore some cool recycling facts!"
    ]

    var body: some View {
        ZStack {
            Color("Cream").edgesIgnoringSafeArea(.all) // Background color

            VStack {
                if currentDialogue < dialogues.count {
                    VStack {
                        Text(displayedText)
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("DarkBrown"))
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                            )
                            .frame(maxWidth: 300)
                            .padding(.top, 120)

                        if showTapToContinue {
                            Text("Click the arrow to continue")
                                .font(.system(size: 14))
                                .foregroundColor(Color("DarkBrown"))
                                .padding(.top, 8)
                        }
                    }
                    .onTapGesture {
                        if currentDialogue < dialogues.count - 1 {
                            currentDialogue += 1
                            startTypewriterEffect(for: dialogues[currentDialogue])
                        } else {
                            navigateToFactPage = true
                        }
                    }
                }

                Image("Rascal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
            }
        }
        .onAppear {
            startTypewriterEffect(for: dialogues[currentDialogue])
        }
        .background(
            NavigationLink(destination: SlideContent(currentSlide: 1), isActive: $navigateToFactPage) {
                EmptyView()
            }
        )
    }

    private func startTypewriterEffect(for text: String) {
        displayedText = ""
        showTapToContinue = false

        let characters = Array(text)
        for (index, char) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                displayedText.append(char)

                if index == characters.count - 1 {
                    showTapToContinue = true
                }
            }
        }
    }
}

// IntroView: Main view that handles transitions between slides
struct IntroView: View {
    @State private var currentSlide = 0 // Current slide index
    @State private var showIntroPage = true // To manage the intro page visibility

    var body: some View {
        ZStack {
            Color("Cream").edgesIgnoringSafeArea(.all)

            VStack {
                if showIntroPage {
                    IntroPage()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showIntroPage = false
                                }
                            }
                        }
                } else if currentSlide == 6 {
                    LoginPageView() // Directly show the login page after the intro pages
                } else {
                    SlideContent(currentSlide: currentSlide)
                }
            }

            // Show the arrow only after the intro page
            if !showIntroPage && currentSlide < 6 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: nextSlide) {
                            Image(systemName: "arrow.right.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color("DarkBrown"))
                        }
                        .padding(.bottom, 30)
                        .padding(.trailing, 20)
                    }
                }
            }
        }
    }

    // Move to the next slide
    private func nextSlide() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentSlide += 1
        }
    }
}

// Content for each slide
struct SlideContent: View {
    let currentSlide: Int

    var body: some View {
        Group {
            switch currentSlide {
            case 0:
                RascalPage() // Show Rascal’s page first
            case 1:
                Text("Around 75% of all waste is recyclable...")
                    .font(.system(size: 24, weight: .medium, design: .default))
                    .foregroundColor(Color("DarkBrown"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 40) // Start text at the same position
            case 2:
                VStack {
                    Text("But only 21% of recyclables are recycled. A fraction of what's possible.")
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 40) // Start text at the same position
                    PieChartView() // Pie chart visual
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                }
            case 3:
                VStack {
                    Text("If we recycle just 8% more, we could save 11.4 million tons of carbon annually!")
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 40) // Start text at the same position
                        .lineLimit(nil) // Ensure the text wraps correctly
                        .frame(maxWidth: .infinity, alignment: .center) // Ensure text uses available space
                    PlantGrowingAnimationView() // Pie chart visual
                        .frame(width: 200, height: 200)
                        .padding(.top, 20)
                }
            case 4:
                VStack {
                    Text("That’s the same as eliminating emissions from 12 million households’ electricity usage every year.")
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 40) // Start text at the same position
                    HousesAnimationView()
                        .frame(height: 100)
                        .padding(.top, 20)
                }
            case 5:
                VStack {
                    Text("Your choices today can create a sustainable tomorrow. Let’s build a greener future, together.")
                        .font(.system(size: 18, weight: .medium)) // Smaller font size for dialogue
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                        .padding(.vertical, 10) // Adjust vertical padding
                        .padding(.horizontal, 18) // Adjust horizontal padding
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .shadow(radius: 10) // Softer shadow for a polished look
                        )
                        .frame(maxWidth: 300) // Set a maximum width for the dialogue box
                        .padding(.top, 120) // Adjusted padding from top

                    // Rascal's image below the dialogue box
                    Image("Cookie") // Ensure your Rascal image is named "Rascal"
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding(.top, 50)
                }
            
            case 6:
                LoginPageView() // Show LoginPage after all the intro slides
            default:
                EmptyView()
            }
        }
    }
}

// Pie chart view (orange and filling gradually)
struct PieChartView: View {
    @State private var fillAmount: CGFloat = 0.0

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: fillAmount) // Filling gradually
                .stroke(Color("Green"), lineWidth: 30)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 2), value: fillAmount) // Fill over time
            Circle()
                .trim(from: fillAmount, to: 1.0) // Remaining portion
                .stroke(Color.gray, lineWidth: 30)
                .rotationEffect(.degrees(-90))

            Image("Heart")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .opacity(0.6)
        }
        .onAppear {
            fillAmount = 0.75 // Fill the pie chart over time
        }
    }
}

struct PlantGrowingAnimationView: View {
    @State private var leafScale: CGFloat = 0
    @State private var leafRotation: Double = 0

    var body: some View {
        VStack {
            // Leaf
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color("Green")) // Set color to Green
                .scaleEffect(leafScale)
                .rotationEffect(.degrees(leafRotation))
                .animation(.easeInOut(duration: 2), value: leafScale) // Smooth leaf animation
        }
        .onAppear {
            // Leaf Growth Animation
            leafScale = 1.5   // Leaf will grow larger
            leafRotation = 45 // Leaf rotates a bit as it grows
        }
    }
}



// Houses animation view
struct HousesAnimationView: View {
    @State private var dimmedHouses: [Bool] = [false, false, false, false, false]

    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<5) { index in
                Image(systemName: dimmedHouses[index] ? "house.fill" : "house")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 60)
                    .foregroundColor(dimmedHouses[index] ? Color.gray : Color("Orange"))
            }
        }
        .onAppear {
            for i in 0..<dimmedHouses.count {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.5) {
                    withAnimation {
                        dimmedHouses[i] = true
                    }
                }
            }
        }
    }
}



// Placeholder for LoginPage
struct LoginPageView: View {
    var body: some View {
        LoginPage() // Ensure the LoginPage.swift is referenced
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
