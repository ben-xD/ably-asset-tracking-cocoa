protocol AblySubscriberService: AnyObject {
    var delegate: AblySubscriberServiceDelegate? { get set }
    
    func start(completion: ((Error?) -> Void)?)
    func stop(completion: @escaping ResultHandler<Void>)
    func changeRequest(resolution: Resolution?, completion: @escaping ResultHandler<Void>)
}
