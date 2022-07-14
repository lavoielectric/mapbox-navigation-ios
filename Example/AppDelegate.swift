import UIKit
import MapboxNavigation
import MapboxCoreNavigation
import CarPlay

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    weak var currentAppRootViewController: ViewController?
    
    var window: UIWindow?
    
    var _carPlayManager: Any? = nil
    @available(iOS 12.0, *)
    var carPlayManager: CarPlayManager {
        if _carPlayManager == nil {
            _carPlayManager = CarPlayManager(customRoutingProvider: MapboxRoutingProvider(.hybrid))
        }
        
        return _carPlayManager as! CarPlayManager
    }
    
    var _carPlaySearchController: Any? = nil
    @available(iOS 12.0, *)
    var carPlaySearchController: CarPlaySearchController {
        if _carPlaySearchController == nil {
            _carPlaySearchController = CarPlaySearchController()
        }
        
        return _carPlaySearchController as! CarPlaySearchController
    }
    
    // `CLLocationManager` instance, which is going to be used to create a location, which is used as a
    // hint when looking up the specified address in `CarPlaySearchController`.
    static let coarseLocationManager: CLLocationManager = {
        let coarseLocationManager = CLLocationManager()
        coarseLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        return coarseLocationManager
    }()
    
    var _recentSearchItems: [Any]? = nil
    @available(iOS 12.0, *)
    var recentSearchItems: [CPListItem]? {
        get {
            _recentSearchItems as! [CPListItem]?
        }
        set {
            _recentSearchItems = newValue
        }
    }
    
    var recentItems: [RecentItem] = RecentItem.loadDefaults()
    var recentSearchText: String? = ""
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let historyRecordingUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("historyRecordings")
        _ = try? FileManager.default.createDirectory(at: historyRecordingUrl,
                                                     withIntermediateDirectories: true,
                                                     attributes: nil)

        PassiveLocationManager.historyDirectoryURL = historyRecordingUrl

        if isRunningTests() {
            if window == nil {
                window = UIWindow(frame: UIScreen.main.bounds)
            }
            window?.rootViewController = UIViewController()
        }
        
        listMapboxFrameworks()
        
        return true
    }

    private func isRunningTests() -> Bool {
        return NSClassFromString("XCTestCase") != nil
    }
    
    private func listMapboxFrameworks() {
        NSLog("Versions of linked Mapbox frameworks:")
        
        for framework in Bundle.allFrameworks {
            if let bundleIdentifier = framework.bundleIdentifier, bundleIdentifier.contains("mapbox") {
                let version = "CFBundleShortVersionString"
                NSLog("\(bundleIdentifier): \(framework.infoDictionary?[version] ?? "Unknown version")")
            }
        }
    }
}

// MARK: - UIWindowSceneDelegate methods

@available(iOS 13.0, *)
extension AppDelegate: UIWindowSceneDelegate {

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        if connectingSceneSession.role == .carTemplateApplication {
            return UISceneConfiguration(name: "ExampleCarPlayApplicationConfiguration", sessionRole: connectingSceneSession.role)
        }
        
        return UISceneConfiguration(name: "ExampleAppConfiguration", sessionRole: connectingSceneSession.role)
    }
}
