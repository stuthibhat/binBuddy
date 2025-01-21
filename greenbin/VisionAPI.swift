import Foundation
import UIKit

// MARK: - VisionAPI Class
/// This class handles interactions with the Google Vision API for image analysis
class VisionAPI {
    
    // MARK: - Properties
        
    /// The API key used to authenticate requests to the Google Vision API.
    private let apiKey: String
    
    /// The URL endpoint for the Vision API to send image annotation requests.
    private let googleVisionURL: URL
    
    // MARK: - Initializer
        
    /// Initializes the VisionAPI with a provided API key.
    /// - Parameter apiKey: The API key required to access the Google Vision API.
    init(apiKey: String) {
        self.apiKey = apiKey
        self.googleVisionURL = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    // MARK: - analyzeImage Method
    
    /// Analyzes an image using the Google Vision API and returns label annotations.
    /// - Parameters:
    ///   - image: The UIImage to be analyzed.
    ///   - completion: A closure that is called with the result of the analysis. It returns either a list of labels (as a string) or an error.
    func analyzeImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        // Convert the image to Base64
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            let error = NSError(domain: "VisionAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to Base64."])
            completion(.failure(error))
            return
        }
        
        // Create the request payload
        let jsonRequest: [String: Any] = [
            "requests": [
                [
                    "image": [
                        "content": imageData
                    ],
                    "features": [
                        [
                            "type": "LABEL_DETECTION",
                            "maxResults": 10
                        ]
                    ]
                ]
            ]
        ]
        
        // Serialize the JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: jsonRequest) else {
            let error = NSError(domain: "VisionAPI", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize JSON payload."])
            completion(.failure(error))
            return
        }
        
        // Create the request
        var request = URLRequest(url: googleVisionURL)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = httpBody
        
        print("Sending request to Google Vision API...")
        
        // Send the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "VisionAPI", code: 2, userInfo: [NSLocalizedDescriptionKey: "No data received from the Vision API."])
                completion(.failure(error))
                return
            }
            
            // Log the raw response data for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(rawString)")
            }
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let responses = json["responses"] as? [[String: Any]],
                   let labelAnnotations = responses.first?["labelAnnotations"] as? [[String: Any]] {
                    
                    let descriptions = labelAnnotations.compactMap { $0["description"] as? String }
                    print("Label Annotations: \(descriptions)") // Log the label annotations
                    completion(.success(descriptions.joined(separator: ", ")))
                } else {
                    let error = NSError(domain: "VisionAPI", code: 3, userInfo: [NSLocalizedDescriptionKey: "No labels found in the response."])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
