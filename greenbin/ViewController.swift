import UIKit
import SwiftUI

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create the SwiftUI view
        let introView = IntroView()
        
        // Embed it in a UIHostingController
        let hostingController = UIHostingController(rootView: introView)
        
        // Add the hosting controller as a child of the current UIViewController
        addChild(hostingController)
        
        // Add the hosting controller's view to the view hierarchy
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        
        // Set up constraints to make the SwiftUI view fill the screen
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        // Notify the hosting controller that it has been added to a parent
        hostingController.didMove(toParent: self)
    }
}
