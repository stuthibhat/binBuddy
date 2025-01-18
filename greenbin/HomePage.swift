import SwiftUI
import UIKit

import SwiftUI
import Vision

struct HomePage: View {
    @State private var isImagePickerPresented = false
    @State private var isCameraPickerPresented = false
    @State private var capturedImage: UIImage?
    @State private var identifiedTrashType = ""
    @State private var savedCarbonAmount = 0.0
    @State private var totalCoins = 0
    @State private var showCoinAnimation = false
    @State private var isProcessingImage = false
    @State private var showTrashTypeAlert = false
    @State private var showTutorial = true
    @State private var disposalMessage = ""
    @State private var earnedCoins = 0
    @State private var isShopPresented = false
    @State private var purchasedItems: [String] = [] // Track purchased items
    
    private let visionAPI = VisionAPI(apiKey: "AIzaSyCaZzxyjMgNx0Ab7gCPEbrYaZlAoLJtOl4")
    
    var body: some View {
            NavigationView {
                ZStack {
                    VStack {
                        // Cart and coins UI
                        HStack {
                            Image(systemName: "cart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("DarkBrown"))
                                .padding(.leading, 20)
                                .onTapGesture {
                                    isShopPresented = true
                                }
                                .sheet(isPresented: $isShopPresented) {
                                    ShopView(totalCoins: $totalCoins, purchasedItems: $purchasedItems)
                                }
                            
                            Spacer()
                            
                            Text("\(totalCoins)")
                                .font(.headline)
                                .foregroundColor(Color("DarkBrown"))
                            
                            Image(systemName: "bitcoinsign.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("DarkBrown"))
                                .padding(.top, 10)
                        }
                        .padding(.trailing, 20)
                        
                        VStack {
                            Text("Energy saved: \(savedCarbonAmount, specifier: "%.2f") kg of carbon!")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(Color("DarkBrown"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("SageGreen"))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                                .padding(.top, 20)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                        
                        VStack {
                            ZStack(alignment: .topLeading) {
                                // Raccoon Image
                                Image("Rascal")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 300, height: 300) // Keep the raccoon image at 300x300
                                    .clipShape(Circle())
                                    .padding(.leading, 20) // Padding for positioning
                                
                                // Purchased Items (positioned on top of the raccoon image)
                                HStack(spacing: 15) {
                                    ForEach(purchasedItems, id: \.self) { item in
                                        VStack {
                                            Image(item) // Image of the purchased item
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 100, height: 100) // Adjust size as needed
                                                .padding(5)
                                        }
                                        .frame(width: 120) // Ensure uniformity for each item
                                    }
                                }
                                .padding(.top, 165) // Adjust top padding to ensure items are positioned correctly
                                .padding(.leading, 210) // Skew it right a bit by adding left padding
                            }
                            .padding(.top, 20) // Padding for the whole ZStack
                        }
                        .padding(.horizontal) // Padding to prevent content overflow at the edges
                    
                    
                    // Bottom Left About Icon (separate layer)
                

                    VStack {
                        Text("Earn coins and buy goodies for Rascal by taking pictures to identify your trash and recycling it!")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("DarkBrown"))
                            .multilineTextAlignment(.center)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color.white)
                                    .shadow(radius: 10)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(.systemGray), lineWidth: 2)
                            )
                            .padding(.horizontal, 20)
                        
                        HStack {
                            Button(action: { isCameraPickerPresented = true }) {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("DarkBrown"))
                                    .padding()
                            }
                            .sheet(isPresented: $isCameraPickerPresented) {
                                ImagePicker(isPresented: $isCameraPickerPresented, capturedImage: $capturedImage, sourceType: .camera) { image in
                                    processImage(image: image)
                                }
                            }
                            
                            Button(action: { isImagePickerPresented = true }) {
                                Image(systemName: "photo.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(Color("DarkBrown"))
                                    .padding()
                            }
                            .sheet(isPresented: $isImagePickerPresented) {
                                ImagePicker(isPresented: $isImagePickerPresented, capturedImage: $capturedImage, sourceType: .photoLibrary) { image in
                                    processImage(image: image)
                                }
                            }
                        }
                        .padding(.bottom, 30)
                    }
                }
                .padding()
                .background(Color("Cream").edgesIgnoringSafeArea(.all))
                
                if showTutorial {
                    TutorialView(isVisible: $showTutorial)
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showTutorial = true }) {
                            Image(systemName: "info.circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(Color("DarkBrown"))
                                .padding()
                        }
                    }
                }
                
                if showTrashTypeAlert {
                    VStack {
                        Spacer()
                        VStack {
                            Text("You scanned \(identifiedTrashType)!")
                                .font(.title2)
                                .foregroundColor(Color("DarkBrown"))
                                .fontWeight(.bold)
                                .padding()
                            
                            Text(disposalMessage)
                                .font(.body)
                                .foregroundColor(Color("DarkBrown"))
                                .padding()
                                .multilineTextAlignment(.center)
                            
                            Text("You earned \(earnedCoins) coins!")
                                .font(.body)
                                .foregroundColor(.black)
                                .padding()
                                .multilineTextAlignment(.center)
                            
                            Button(action: {
                                showTrashTypeAlert = false
                            }) {
                                Text("Got it!")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("Green"))
                                    .cornerRadius(10)
                            }
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(radius: 10)
                        .padding()
                        Spacer()
                    }
                    .background(Color.black.opacity(0.6).edgesIgnoringSafeArea(.all))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func processImage(image: UIImage) {
        isProcessingImage = true
        visionAPI.analyzeImage(image: image) { result in
            isProcessingImage = false
            switch result {
            case .success(let label):
                let (trashType, message, coins) = categorizeTrashType(from: label)
                identifiedTrashType = trashType
                disposalMessage = message
                earnedCoins = coins
                totalCoins += coins
                updateCarbonSavings(for: trashType)
                showTrashTypeAlert = true
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    private func categorizeTrashType(from identifiedText: String) -> (String, String, Int) {
        let lowercasedText = identifiedText.lowercased()
        
        if lowercasedText.contains("plastic") {
            return ("Plastic", "Place your plastic item in your recycling bin, being sure to rinse them thoroughly before recycling. This bin is often color-coded blue.", 100)
        } else if lowercasedText.contains("glass") {
            return ("Glass", "Recycle your glass item in your recycling bin. Rinse containers to remove residue before recycling. If there is a designated glass bin (often green) use it!", 100)
        } else if lowercasedText.contains("paper") || lowercasedText.contains("cardboard") {
            return ("Paper/Cardboard", "Recycle paper and cardboard in the recycling bin. Flatten cardboard to save space. Avoid recycling wax-coated or greasy paper.", 100)
        } else if lowercasedText.contains("metal") || lowercasedText.contains("aluminum") || lowercasedText.contains("steel") {
            return ("Metal/Aluminum", "Recycle your metal in your recycling bin. Rinse any food residue off containers before recycling.", 100)
        } else if lowercasedText.contains("organic") || lowercasedText.contains("food") {
            return ("Organic", "Compost food scraps or dispose of them in your organic waste bin at home. Avoid placing non-organic materials in this bin.", 50)
        } else if lowercasedText.contains("e-waste") || lowercasedText.contains("electronic") || lowercasedText.contains("battery") {
            return ("E-Waste", "E-waste should not be disposed of in regular bins. Store it safely at home and take it to a local recycling center or drop-off location to save precious metals and energy!", 200)
        } else if lowercasedText.contains("textile") || lowercasedText.contains("fabric") {
            return ("Textiles", "Please donate wearable items to a thrift or find a textile recycling program near you. Don't throw worn-out fabrics in regular bins.", 150)
        } else {
            return ("Unidentified", "We couldn't identify this item. This item may not be recyclable! Please check your local recycling guidelines or try again.", 0)
        }
    }

    private func updateCarbonSavings(for trashType: String) {
        let carbonReductionForItem: Double
        
        switch trashType.lowercased() {
        case "plastic":
            carbonReductionForItem = 0.1
        case "paper/cardboard":
            carbonReductionForItem = 0.07
        case "glass":
            carbonReductionForItem = 0.15
        case "metal/aluminum":
            carbonReductionForItem = 0.2
        case "organic":
            carbonReductionForItem = 0.08
        case "e-waste":
            carbonReductionForItem = 0.25
        case "textiles":
            carbonReductionForItem = 0.12
        default:
            carbonReductionForItem = 0.0
        }
        
        savedCarbonAmount += carbonReductionForItem
    }
}


struct ShopView: View {
    @Binding var totalCoins: Int
    @Binding var purchasedItems: [String]
    @State private var showPurchasePopup = false
    @State private var popupMessage = ""
    @State private var popupTitle = ""
    @State private var showShop = true
    @State private var showSuccessMessage = false
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode> // For navigation back

    // Item List with Custom Images
    let items = [
        ("Plant", 500, "Plant"),
        ("Chippie", 550, "Chip"),
        ("Balloon", 600, "Balloon"),
        ("Soccer", 700, "Soccer"),
        ("Mittens", 800, "Mittens"),
        ("Gift", 900, "Gift")
    ].sorted(by: { $0.1 < $1.1 }) // Sorted by price

    var body: some View {
        ZStack {
            if showShop {
                VStack {
                    // Centered and Larger Loot Image
                    Image("Loot") // Replace "Loot" with your asset name
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 150)
                        .padding(.top, 20)

                    ScrollView {
                        LazyVGrid(columns: [GridItem(.fixed(120)), GridItem(.fixed(120))], spacing: 15) {
                            ForEach(0..<items.count, id: \.self) { index in
                                let item = items[index]
                                let canAfford = totalCoins >= item.1

                                VStack {
                                    Image(item.2) // Custom image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                        .padding(.top, 10)

                                    Text(item.0)
                                        .font(.subheadline)
                                        .foregroundColor(canAfford ? Color("DarkBrown") : .gray)
                                        .padding(.top, 8)

                                    HStack(spacing: 4) {
                                        Image(systemName: "dollarsign.circle")
                                            .foregroundColor(canAfford ? Color("DarkBrown") : .gray)
                                        Text("\(item.1)")
                                            .font(.footnote)
                                            .foregroundColor(canAfford ? Color("DarkBrown") : .gray)
                                    }

                                    Button(action: {
                                        if canAfford {
                                            totalCoins -= item.1
                                            purchasedItems.append(item.0)
                                            popupTitle = "\(item.0) Purchased!"
                                            popupMessage = "Rascal has received \(item.0)!"
                                            showPurchasePopup = true

                                            // Dismiss popup after 2 seconds
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                                showPurchasePopup = false
                                            }
                                        } else {
                                            popupTitle = "Purchase Failed"
                                            popupMessage = "You don't have enough coins. Recycle more to earn coins!"
                                            showPurchasePopup = true
                                        }
                                    }) {
                                        Text("Buy")
                                            .font(.caption)
                                            .foregroundColor(.white)
                                            .padding(6)
                                            .frame(maxWidth: .infinity)
                                            .background(canAfford ? Color("Green") : Color.gray)
                                            .cornerRadius(8)
                                    }
                                    .disabled(!canAfford)
                                    .padding(.top, 10)
                                }
                                .frame(width: 120, height: 180)
                                .background(canAfford ? Color.white : Color.gray.opacity(0.3))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("Pink"), lineWidth: 2)
                                )
                                .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                .background(Color("Cream"))
                .ignoresSafeArea()
            }

            // Purchase Popup (Single Popup Message)
            if showPurchasePopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)

                    VStack(spacing: 20) {
                        Text(popupTitle)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("DarkBrown"))

                        Text(popupMessage)
                            .font(.body)
                            .foregroundColor(Color("DarkBrown"))
                            .padding(.horizontal, 20)
                            .multilineTextAlignment(.center)

                        Button(action: {
                            showPurchasePopup = false
                        }) {
                            Text("Close")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color("DarkBrown"))
                                .cornerRadius(10)
                        }
                    }
                    .padding(40)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(radius: 10)
                }
                .transition(.opacity)
            }

            // Back Button (Navigate to Main Page)
            VStack {
                HStack {
                    Button(action: {
                        // Go back to the main page
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left.circle.fill") // Back arrow icon
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .foregroundColor(Color("DarkBrown"))
                    }
                    Spacer()
                }
                .padding()
                Spacer()
            }
        }
    }
}


struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    @Binding var capturedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    var onImagePicked: (UIImage) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.sourceType = sourceType
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.capturedImage = image
                parent.onImagePicked(image)
            }
            parent.isPresented = false
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.isPresented = false
        }
    }
}

struct TutorialView: View {
    @Binding var isVisible: Bool
    
    // Array of steps with icons and descriptions
    let tutorialSteps: [(icon: String, title: String, description: String)] = [
        ("camera.fill", "Step 1: Take a Photo", "Click the camera icon to take a photo and scan your trash."),
        ("photo.fill", "Step 2: Scanning Your Trash", "The app will identify the type of trash and give you disposal instructions."),
        ("arrow.triangle.2.circlepath", "Step 3: Recycle & Earn Coins", "Follow the recycling instructions and earn coins as you reduce carbon emissions."),
        ("cart.fill", "Step 4: Shop & Rewards", "Use your coins to shop for items for Rascal and keep saving the planet!")
    ]
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 15) {
                // Title and intro text
                Text("Welcome to BinBuddy!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("DarkBrown"))
                    .padding([.horizontal, .bottom], 10)
                
                // Step-by-step tutorial content
                ForEach(0..<tutorialSteps.count, id: \.self) { index in
                    HStack {
                        // Icon for the step
                        Image(systemName: tutorialSteps[index].icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("DarkBrown"))
                            .padding()
                        
                        // Text for the step
                        VStack(alignment: .leading) {
                            Text(tutorialSteps[index].title)
                                .font(.subheadline)
                                .fontWeight(.bold) // Bold step titles like "Step 1", "Step 2", etc.
                                .foregroundColor(Color("DarkBrown"))
                            
                            Text(tutorialSteps[index].description)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .lineLimit(3)
                                .multilineTextAlignment(.leading) // Align descriptions to the left for consistency
                        }
                        .padding([.leading, .top, .bottom], 10) // Add padding to the left, top, and bottom of text
                        .frame(maxWidth: .infinity, alignment: .leading) // Ensure text is aligned consistently to the left
                    }
                    .padding(.bottom, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .frame(maxWidth: .infinity, alignment: .leading) // Keep the whole HStack aligned to the left for consistency
                }
                
                // "Got it" button to close tutorial
                Button(action: {
                    isVisible = false
                }) {
                    Text("Got it!")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBrown"))
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding([.leading, .trailing], 20)
            .padding(.bottom, 30)
            
            Spacer()
        }
        .background(Color.black.opacity(0.6).edgesIgnoringSafeArea(.all))
    }
}




struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
