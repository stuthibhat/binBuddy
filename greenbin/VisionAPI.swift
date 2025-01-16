import Foundation
import UIKit

class VisionAPI {
    private let apiKey: String
    private let googleVisionURL: URL
    
    init(apiKey: String) {
        self.apiKey = apiKey
        self.googleVisionURL = URL(string: "https://vision.googleapis.com/v1/images:annotate?key=\(apiKey)")!
    }
    
    func analyzeImage(image: UIImage, completion: @escaping (String?) -> Void) {
        // Convert the image to Base64
        guard let imageData = image.jpegData(compressionQuality: 0.8)?.base64EncodedString() else {
            print("Failed to convert image to Base64.")
            completion("Failed to process image data.")
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
            print("Failed to serialize JSON payload.")
            completion("Failed to serialize JSON payload.")
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
                print("Error occurred: \(error.localizedDescription)")
                completion("Error: \(error.localizedDescription)")
                return
            }
            
            guard let data = data else {
                print("No data received from the Vision API.")
                completion("No data received from the Vision API.")
                return
            }
            
            // Log the raw response data for debugging
            if let rawString = String(data: data, encoding: .utf8) {
                print("Raw Response Data: \(rawString)")
            }
            
            // Parse the response
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Google Vision API Response: \(json)") // Log the API response
                    if let responses = json["responses"] as? [[String: Any]],
                       let labelAnnotations = responses.first?["labelAnnotations"] as? [[String: Any]] {
                        
                        let descriptions = labelAnnotations.compactMap { $0["description"] as? String }
                        print("Label Annotations: \(descriptions)") // Log the label annotations
                        completion(descriptions.joined(separator: ", "))
                    } else {
                        print("No labels found in the response.")
                        completion("No labels found in the response.")
                    }
                }
            } catch {
                print("Failed to parse response: \(error.localizedDescription)")
                completion("Failed to parse response: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
