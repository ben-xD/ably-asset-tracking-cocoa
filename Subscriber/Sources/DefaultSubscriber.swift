import Foundation
import CoreLocation

class DefaultSubscriber: AssetTrackingSubscriber {
    private let logConfiguration: LogConfiguration
    private let trackingId: String
    private let resolution: Double?
    private let ablyService: AblySubscriberService
    weak var delegate: AssetTrackingSubscriberDelegate?

    /**
     Default constructor. Initializes Subscriber with given `AssetTrackingSubscriberConfiguration`.
     Subscriber starts listening (and notifying delegate) after initialization.
     - Parameters:
        -  configuration: Configuration struct to use in this instance.
     */
    init(connectionConfiguration: ConnectionConfiguration,
         logConfiguration: LogConfiguration,
         trackingId: String,
         resolution: Double?) {
        self.trackingId = trackingId
        self.resolution = resolution
        self.logConfiguration = logConfiguration
        self.ablyService = AblySubscriberService(configuration: connectionConfiguration,
                                                 trackingId: trackingId)
        self.ablyService.delegate = self
    }

    func start() {
        ablyService.start { [weak self] error in
            if let error = error,
               let self = self {
                self.delegate?.assetTrackingSubscriber(sender: self, didFailWithError: error)
            }
        }
    }

    func stop() {
        ablyService.stop()
    }
}

extension DefaultSubscriber: AblySubscriberServiceDelegate {
    func subscriberService(sender: AblySubscriberService, didChangeAssetConnectionStatus status: AssetTrackingConnectionStatus) {
        delegate?.assetTrackingSubscriber(sender: self, didChangeAssetConnectionStatus: status)
    }

    func subscriberService(sender: AblySubscriberService, didFailWithError error: Error) {
        delegate?.assetTrackingSubscriber(sender: self, didFailWithError: error)
    }

    func subscriberService(sender: AblySubscriberService, didReceiveRawLocation location: CLLocation) {
        delegate?.assetTrackingSubscriber(sender: self, didUpdateRawLocation: location)
    }

    func subscriberService(sender: AblySubscriberService, didReceiveEnhancedLocation location: CLLocation) {
        delegate?.assetTrackingSubscriber(sender: self, didUpdateEnhancedLocation: location)
    }
}
