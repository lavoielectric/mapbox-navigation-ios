import UIKit

// :nodoc:
public protocol Banner: UIViewController {
    
    var bannerConfiguration: BannerConfiguration { get }
}

// :nodoc:
public struct BannerConfiguration {
    
    // :nodoc:
    public var position: BannerPosition = .bottomLeading
    
    // :nodoc:
    public var height: CGFloat? = nil
    
    // :nodoc:
    public init(position: BannerPosition, height: CGFloat? = nil) {
        self.position = position
        self.height = height
    }
}