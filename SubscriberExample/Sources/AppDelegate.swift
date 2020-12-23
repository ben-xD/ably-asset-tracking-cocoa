import UIKit
import Logging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupLogger()

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let settingsVC = SettingsViewController()
        let navVC = UINavigationController(rootViewController: settingsVC)

        window.rootViewController = navVC
        window.makeKeyAndVisible()

        return true
    }

    private func setupLogger() {
        LoggingSystem.bootstrap { label -> LogHandler in
            var handler = StreamLogHandler.standardOutput(label: label)
            handler.logLevel = .debug
            return handler
        }
    }
}
