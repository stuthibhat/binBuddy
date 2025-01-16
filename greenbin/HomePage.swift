import SwiftUI
import UIKit

struct HomePage: View {
    @State private var isImagePickerPresented = false
    @State private var isCameraPresented = false
    @State private var capturedImage: UIImage?
    @State private var identifiedTrashType = ""
    
    // Initialize VisionAPI instance
    private let visionAPI = VisionAPI(apiKey: "AIzaSyCaZzxyjMgNx0Ab7gCPEbrYaZlAoLJtOl4")
    
    var body: some View {
        NavigationView {
            VStack {
                // Shop and Coin Icons at the Top, next to each other
                HStack {
                    // Shop icon on the left
                    Button(action: {
                        // Add your action here
                    }) {
                        Image(systemName: "cart.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("DarkBrown"))
                            .padding(.top, 40) // Adjust top padding
                    }
                    
                    // Coins icon on the right
                    Button(action: {
                        // Add your action here
                    }) {
                        Image(systemName: "bitcoinsign.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("DarkBrown"))
                            .padding(.top, 40) // Adjust top padding
                    }
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Rascal's image in the center of the page
                Image("Rascal") // Ensure your Rascal image is named "Rascal"
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300) // Adjust size of Rascal
                    .clipShape(Circle())
                    .padding(.bottom, 20)
                
                // Display captured image or prompt to use camera or photo library
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                    
                    if !identifiedTrashType.isEmpty {
                        Text("Trash Type: \(identifiedTrashType)")
                            .font(.headline)
                            .foregroundColor(.green)
                            .padding()
                    }
                }
                
                Spacer()
                
                // Text instructions inside a styled dialogue box
                VStack {
                    // Dialogue Box for text instructions
                    VStack {
                        Text("Use the camera to capture an image of your trash or select from your photo library.")
                            .font(.body)
                            .foregroundColor(Color("DarkBrown"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("Cream"))
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("DarkBrown"), lineWidth: 2)
                            )
                            .padding(.horizontal, 20)
                    }
                    .padding(.top, 30)
                    
                    // Camera and photo library buttons outside the dialogue box
                    HStack {
                        // Camera button (smaller size)
                        Button(action: { isCameraPresented = true }) {
                            Image(systemName: "camera.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30) // Smaller size for camera button
                                .foregroundColor(Color("DarkBrown"))
                                .padding()
                        }
                        .sheet(isPresented: $isCameraPresented) {
                            CameraView(isPresented: $isCameraPresented, capturedImage: $capturedImage) { image in
                                processImage(image: image)
                            }
                        }
                        
                        // Photo library button with a different icon and dark brown color
                        Button(action: { isImagePickerPresented = true }) {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40) // Same size for photo button
                                .foregroundColor(Color("DarkBrown"))
                                .padding()
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePickerView(isPresented: $isImagePickerPresented, capturedImage: $capturedImage) { image in
                                processImage(image: image)
                            }
                        }
                    }
                    .padding(.bottom, 30) // Adjust spacing from bottom of the image
                }
                
            }
            .padding()
            .background(Color("Cream").edgesIgnoringSafeArea(.all))
            .navigationBarBackButtonHidden(true) // Hide the default back button
        }
    }
    
    // MARK: - Actions
    private func processImage(image: UIImage) {
        // Call the Vision API here
        print("Processing image...")
        
        visionAPI.analyzeImage(image: image) { identifiedText in
            DispatchQueue.main.async {
                if let identifiedText = identifiedText {
                    self.identifiedTrashType = identifiedText
                } else {
                    self.identifiedTrashType = "Unable to identify trash type"
                }
            }
        }
    }
    
    // MARK: - CameraView
    struct CameraView: UIViewControllerRepresentable {
        @Binding var isPresented: Bool
        @Binding var capturedImage: UIImage?
        var onCapture: (UIImage) -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .camera
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: CameraView
            
            init(_ parent: CameraView) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
                if let image = info[.originalImage] as? UIImage {
                    parent.capturedImage = image
                    parent.onCapture(image)
                }
                parent.isPresented = false
            }
            
            func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
                parent.isPresented = false
            }
        }
    }
    
    // MARK: - ImagePickerView (for selecting images from Camera Roll)
    struct ImagePickerView: UIViewControllerRepresentable {
        @Binding var isPresented: Bool
        @Binding var capturedImage: UIImage?
        var onImagePicked: (UIImage) -> Void
        
        func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }
        
        func makeUIViewController(context: Context) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            picker.sourceType = .photoLibrary // Set source type to photo library
            picker.allowsEditing = false  // Optional: Allow users to edit photos if needed
            return picker
        }
        
        func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
        
        class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
            let parent: ImagePickerView
            
            init(_ parent: ImagePickerView) {
                self.parent = parent
            }
            
            func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
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
    
    // MARK: - Preview
    struct HomePage_Previews: PreviewProvider {
        static var previews: some View {
            HomePage()
        }
    }
}
