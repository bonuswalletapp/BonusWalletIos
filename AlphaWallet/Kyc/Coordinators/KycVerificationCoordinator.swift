// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import UIKit
import Result

protocol KycVerificationCoordinatorDelegate: AnyObject {
//    func didCancel(coordinator: BackupCoordinator)
//    func didFinish(account: AlphaWallet.Address, in coordinator: BackupCoordinator)
}

class KycVerificationCoordinator: Coordinator {
    private let config: Config
    private let analyticsCoordinator: AnalyticsCoordinator

    let navigationController: UINavigationController
    weak var delegate: BackupCoordinatorDelegate?
    var coordinators: [Coordinator] = []

    init(navigationController: UINavigationController, config: Config, analyticsCoordinator: AnalyticsCoordinator) {
        self.navigationController = navigationController
        self.config = config
        self.analyticsCoordinator = analyticsCoordinator
        navigationController.navigationBar.isTranslucent = false
    }

    func start() {
        let controller = KycVerificationViewController(analyticsCoordinator: analyticsCoordinator)
        controller.delegate = self
        controller.navigationItem.largeTitleDisplayMode = .never
        controller.configure(viewModel: .init(config: config))
        navigationController.pushViewController(controller, animated: true)
    }
}

extension KycVerificationCoordinator: KycVerificationViewControllerDelegate {
    
}
