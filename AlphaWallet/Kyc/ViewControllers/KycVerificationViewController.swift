//
//  KycVerificationViewController.swift
//  BonusWallet
//
//   Created by apollo on 2/18/22.
//

import UIKit

protocol KycVerificationViewControllerDelegate: AnyObject {
//    func didKycVerification(in viewController: KycVerificationViewController)
}

class KycVerificationViewController: UIViewController {

    private let analyticsCoordinator: AnalyticsCoordinator
    
    private let labelLabel = UILabel() //PaddingLabel(withInsets: 8, 8, 16, 16)
    private let titleLabel = UILabel()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonsBar = ButtonsBar(configuration: .green(buttons: 1))
    private let container = UIView()
    private let contentView = UIView()
    private var labelView = UIView()

    weak var delegate: KycVerificationViewControllerDelegate?

    init(analyticsCoordinator: AnalyticsCoordinator) {
        self.analyticsCoordinator = analyticsCoordinator
        
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true
        
        navigationItem.title = R.string.localizable.settingsKycVerificationTitle()

        let stackView = [
            labelLabel,
            UIView.spacer(height: ScreenChecker.size(big: 24, medium: 20, small: 18)),
            nameLabel,
            UIView.spacer(height: ScreenChecker.size(big: 24, medium: 20, small: 18)),
            contentView,
            UIView.spacer(height: ScreenChecker.size(big: 34, medium: 30, small: 28)),
            buttonsBar
        ].asStackView(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentStackView = [
            titleLabel,
            descriptionLabel
        ].asStackView(axis: .vertical, spacing: 5)
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(contentStackView)
        contentView.cornerRadius = 5
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
//        labelView.addSubview(labelLabel)
        labelView.translatesAutoresizingMaskIntoConstraints = false
        labelView.cornerRadius = 5
        container.addSubview(labelView)

        container.translatesAutoresizingMaskIntoConstraints = false
        container.cornerRadius = 12
        container.dropShadow(color: UIColor(hex: "BEBEBE"), opacity: 1, offSet: CGSize(width: 0, height: 0), radius: 4)
        container.addSubview(stackView)

        view.addSubview(container)

        NSLayoutConstraint.activate([

            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20),
            
            contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            container.heightAnchor.constraint(equalToConstant: 250),
            container.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            container.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            
//            labelLabel.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 12),
//            labelLabel.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -12),
//            labelLabel.topAnchor.constraint(equalTo: labelView.topAnchor, constant: 5),
//            labelLabel.bottomAnchor.constraint(equalTo: labelView.bottomAnchor, constant: -5),
            
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
//        if isMovingFromParent || isBeingDismissed {
//            delegate?.didClose(in: self)
//            return
//        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func configure(viewModel: KycVerificationViewModel) {
        view.backgroundColor = Colors.appBackground
        
        container.backgroundColor = viewModel.backgroundColor
        
        contentView.backgroundColor = viewModel.bgColor
        
        labelLabel.numberOfLines = 0
        labelLabel.attributedText = viewModel.attributedLabel
        labelLabel.clipsToBounds = true
        labelLabel.sizeToFit()
        
        let rect: CGRect = labelLabel.textRect(forBounds: labelLabel.bounds, limitedToNumberOfLines: 1)
        let labeViewRect = CGRect(x: self.view.frame.midX - rect.midX - 30, y: 30, width: rect.width + 25, height: rect.height + 5)
        labelView.frame = labeViewRect
        labelView.backgroundColor = viewModel.bgColor
        labelView.cornerRadius = 10
        
        nameLabel.numberOfLines = 0
        nameLabel.attributedText = viewModel.attributedName

        titleLabel.numberOfLines = 0
        titleLabel.attributedText = viewModel.attributedTitle

        descriptionLabel.numberOfLines = 0
        descriptionLabel.attributedText = viewModel.attributedDescription

        buttonsBar.configure()
        let showSeedPhraseButton = buttonsBar.buttons[0]
        showSeedPhraseButton.setTitle(viewModel.actionTitle, for: .normal)
        showSeedPhraseButton.addTarget(self, action: #selector(verifyKycSelected), for: .touchUpInside)
    }

    @objc private func verifyKycSelected() {
//        delegate?.didKycVerification(in: self)
    }

}
