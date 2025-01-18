import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        // Set IntroView as the initial view
        let introView = IntroView() // Replace this with your IntroView

        // Use UIHostingController to host the IntroView
        window?.rootViewController = UIHostingController(rootView: introView)
        window?.makeKeyAndVisible()
    }

    // Other methods remain unchanged...
}
