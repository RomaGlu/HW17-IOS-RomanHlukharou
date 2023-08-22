
protocol ShowPasswordProtocol {
    /// Show password on label
    /// - Parameter password: inputed password
    func showPasswordLabel(_ password: String)
    /// Actions if password search was success
    func successHacking()
    /// Actions if user taped cancel
    func cancelHacking()
}
