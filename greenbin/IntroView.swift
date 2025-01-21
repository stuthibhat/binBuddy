import SwiftUI

// IntroPage: Displays the BinBuddy logo and intro text
// This view introduces the app, displaying the logo and a short text.
struct IntroPage: View {
    var body: some View {
        ZStack {
            Color("Cream").edgesIgnoringSafeArea(.all) // Background color

            VStack {
                Image("Logo") // Display app logo
                    .resizable()
                    .scaledToFit()
                    .frame(width: 260, height: 260)
                    .padding(.top, 50)

                Text("Your smart companion") // Subtext for the app
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("DarkBrown"))
                    .padding(.top, -25)

                Text("for a sustainable future") // Subtext for the app
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(Color("DarkBrown"))
            }
        }
    }
}

// RascalPage: Displays Rascal's dialogue and transitions to the fact pages
// This view handles Rascal's dialogue and provides navigation to the next page with recycling facts.
struct RascalPage: View {
    @State private var currentDialogue = 0 // Track current dialogue index
    @State private var displayedText = ""  // Text displayed with typewriter effect
    @State private var showTapToContinue = false // Flag to show "Tap to continue" message
    @State private var navigateToFactPage = false // Flag to navigate to the next page

    // Array of dialogue strings for Rascal
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
                        Text(displayedText) // Display current dialogue
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
                            Text("Click the arrow to continue") // Prompt to tap for the next dialogue
                                .font(.system(size: 14))
                                .foregroundColor(Color("DarkBrown"))
                                .padding(.top, 8)
                        }
                    }
                    .onTapGesture {
                        if currentDialogue < dialogues.count - 1 {
                            currentDialogue += 1
                            startTypewriterEffect(for: dialogues[currentDialogue]) // Start typewriter effect for next dialogue
                        } else {
                            navigateToFactPage = true // Navigate to next page after dialogue ends
                        }
                    }
                }

                Image("Rascal") // Display Rascal's character image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
            }
        }
        .onAppear {
            startTypewriterEffect(for: dialogues[currentDialogue]) // Start with the first dialogue on view appearance
        }
        .background(
            NavigationLink(destination: SlideContent(currentSlide: 1), isActive: $navigateToFactPage) { // Navigate to next slide
                EmptyView()
            }
        )
    }

    // Function to simulate typewriter effect for text display
    private func startTypewriterEffect(for text: String) {
        displayedText = ""
        showTapToContinue = false

        let characters = Array(text)
        for (index, char) in characters.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                displayedText.append(char)

                if index == characters.count - 1 {
                    showTapToContinue = true // Show tap prompt when dialogue ends
                }
            }
        }
    }
}

// IntroView: Main view that handles transitions between slides
// This view controls the transition between intro slides and the login page.
struct IntroView: View {
    @State private var currentSlide = 0 // Current slide index
    @State private var showIntroPage = true // To manage the intro page visibility

    var body: some View {
        ZStack {
            Color("Cream").edgesIgnoringSafeArea(.all)

            VStack {
                if showIntroPage {
                    IntroPage() // Show the intro page initially
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) { // Delay before transitioning
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showIntroPage = false // Hide intro page after delay
                                }
                            }
                        }
                } else if currentSlide == 6 {
                    LoginPageView() // Show the login page after the intro slides
                } else {
                    SlideContent(currentSlide: currentSlide) // Show content for the current slide
                }
            }

            // Show the arrow button only after the intro page
            if !showIntroPage && currentSlide < 6 {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: nextSlide) { // Action to move to next slide
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

    // Function to move to the next slide
    private func nextSlide() {
        withAnimation(.easeInOut(duration: 0.5)) {
            currentSlide += 1
        }
    }
}

// Content for each slide
// This view handles the content for each slide in the intro sequence.
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
                    .padding(.top, 40)
            case 2:
                VStack {
                    Text("But only 21% of recyclables are recycled. A fraction of what's possible.")
                        .font(.system(size: 24, weight: .medium, design: .default))
                        .foregroundColor(Color("DarkBrown"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                    PieChartView() // Show pie chart visual
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
                        .padding(.top, 40)
                    PlantGrowingAnimationView() // Show plant growing animation
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
                        .padding(.top, 40)
                    HousesAnimationView() // Show houses animation
                        .frame(height: 100)
                        .padding(.top, 20)
                }
            case 5:
                VStack {
                    Text("Your choices today can create a sustainable tomorrow. Let’s build a greener future, together.")
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

                    Image("Cookie") // Show a cute image of Rascal
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding(.top, 50)
                }
            case 6:
                LoginPageView() // Transition to login page after intro slides
            default:
                EmptyView()
            }
        }
    }
}

// Pie chart view (green and filling gradually)
// This view simulates a pie chart visualizing recycling statistics.
struct PieChartView: View {
    @State private var fillAmount: CGFloat = 0.0

    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0.0, to: fillAmount)
                .stroke(Color("Green"), lineWidth: 30)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 2), value: fillAmount)
            Circle()
                .trim(from: fillAmount, to: 1.0)
                .stroke(Color.gray, lineWidth: 30)
                .rotationEffect(.degrees(-90))

            Image("Heart")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .opacity(0.6)
        }
        .onAppear {
            fillAmount = 0.28 // Gradually fill the pie chart
        }
    }
}

// Plant growing animation view
// This view animates a leaf growing, representing the positive impact of recycling.
struct PlantGrowingAnimationView: View {
    @State private var leafScale: CGFloat = 0
    @State private var leafRotation: Double = 0

    var body: some View {
        VStack {
            Image(systemName: "leaf.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(Color("Green"))
                .scaleEffect(leafScale)
                .rotationEffect(.degrees(leafRotation))
                .animation(.easeInOut(duration: 2), value: leafScale)
        }
        .onAppear {
            leafScale = 1.5 // Leaf grows larger during the animation
            leafRotation = 45 // Rotate leaf as it grows
        }
    }
}

// Houses animation view
// This view animates house icons dimming, representing the impact of reducing emissions.
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
// This view serves as a placeholder for the actual login page view.
struct LoginPageView: View {
    var body: some View {
        LoginPage() // Reference to LoginPage.swift file
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView() // Preview the IntroView
    }
}
