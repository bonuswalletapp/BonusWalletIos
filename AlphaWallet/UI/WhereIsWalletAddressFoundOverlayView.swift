
// Copyright © 2019 Stormbird PTE. LTD.

import Foundation
import UIKit

class WhereIsWalletAddressFoundOverlayView: UIView {
    static func show() {
        let view = WhereIsWalletAddressFoundOverlayView(frame: UIScreen.main.bounds)
        view.show()
    }

    private let dialog = Dialog()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.3)

        let blurEffect = UIBlurEffect(style: .regular)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(blurView)
        blurView.alpha = 0.3

        //clipBottomRight()

        dialog.delegate = self
        dialog.cornerRadius = 10
        dialog.clipsToBounds = true
        dialog.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dialog)

        NSLayoutConstraint.activate([
            blurView.anchorsConstraint(to: self),

            dialog.centerXAnchor.constraint(equalTo: centerXAnchor),
            dialog.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func clipBottomRight() {
        //TODO support clipping for iPad too
        if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone {
            let clipDimension = CGFloat(180)
            let clipPath = UIBezierPath(ovalIn: CGRect(x: UIScreen.main.bounds.size.width - clipDimension / 2 - 20, y: UIScreen.main.bounds.size.height - clipDimension / 2 - 20, width: clipDimension, height: clipDimension))
            let maskPath = UIBezierPath(rect: UIScreen.main.bounds)
            maskPath.append(clipPath.reversing())
            let mask = CAShapeLayer()
            mask.backgroundColor = UIColor.red.cgColor
            mask.path = maskPath.cgPath
            layer.mask = mask
        }
    }

    @objc private func hide() {
        removeFromSuperview()
    }

    func show() {
        dialog.configure()
        dialog.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 7, options: .curveEaseInOut, animations: {
            self.dialog.transform = .identity
        })

        UINotificationFeedbackGenerator.show(feedbackType: .success)
    }
}

extension WhereIsWalletAddressFoundOverlayView: DialogDelegate {
    fileprivate func tappedContinue(inDialog dialog: Dialog) {
        hide()
    }
}

private protocol DialogDelegate: AnyObject {
    func tappedContinue(inDialog dialog: Dialog)
}

private class Dialog: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let buttonsBar = ButtonsBar(configuration: .white(buttons: 1))
    private let closeButtonsBar = ButtonsBar(configuration: .green(buttons: 1))
    private var closeButtonContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    weak var delegate: DialogDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        let stackView = [
            titleLabel,
            UIView.spacer(height: 8),
            descriptionLabel,
            UIView.spacer(height: 14),
            closeButtonContainerView
        ].asStackView(axis: .vertical)
        buttonsBar.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        closeButtonContainerView.addSubview(buttonsBar)
        NSLayoutConstraint.activate([
            closeButtonContainerView.heightAnchor.constraint(equalToConstant: 36),
            widthAnchor.constraint(equalToConstant: 320),
            heightAnchor.constraint(equalToConstant: 180),
            stackView.anchorsConstraint(to: self, edgeInsets: .init(top: 20, left: 20, bottom: 30, right: 20)),
            buttonsBar.centerXAnchor.constraint(equalTo: closeButtonContainerView.centerXAnchor),
            buttonsBar.widthAnchor.constraint(equalToConstant: 120),
            buttonsBar.topAnchor.constraint(equalTo: closeButtonContainerView.topAnchor),
            buttonsBar.bottomAnchor.constraint(equalTo: closeButtonContainerView.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = Colors.appWhite

        titleLabel.font = Fonts.bold(size: 18)
        titleLabel.textColor = Colors.headerThemeColor
        titleLabel.textAlignment = .center
        titleLabel.text = R.string.localizable.onboardingNewWalletBackupWalletTitle()

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = Fonts.regular(size: 14)
        descriptionLabel.textColor = UIColor(red: 0.502, green: 0.514, blue: 0.573, alpha: 1)
        descriptionLabel.textAlignment = .center
        descriptionLabel.text = R.string.localizable.onboardingNewWalletBackupWalletDescription()

        buttonsBar.configure()
        let continueButton = buttonsBar.buttons[0]
        continueButton.setTitle(R.string.localizable.close().localizedCapitalized, for: .normal)
        continueButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
        buttonsBar.backgroundColor = Colors.clear
        continueButton.backgroundColor = Colors.clear
        continueButton.titleLabel?.font = Fonts.bold(size: 14)
    }

    @objc private func hide() {
        delegate?.tappedContinue(inDialog: self)
    }
}

