//
//  KycVerificationViewModel.swift
//  BonusWallet
//
//  Created by apollo on 2/18/22.
//

import UIKit

enum KycStatus {
    case verified
    case pending
    case declined
    case unverified
}

struct KycVerificationViewModel {
    private var config: Config
    
    init(config: Config) {
        self.config = config
    }
    
    var status: KycStatus {
        switch config.kycStatus {
        case "verified":
            return .verified
        case "unverified":
            return .unverified
        case "declined":
            return .declined
        case "pending":
            return .pending
        default:
            return .unverified
        }
    }

    var backgroundColor: UIColor {
        return Colors.appWhite
    }
    
    var attributedLabel: NSAttributedString {
        let attributeString = NSMutableAttributedString(string: label)
        let style = NSMutableParagraphStyle()
        style.alignment = .center
//        style.headIndent = 15
//        style.tailIndent = 15
//        style.firstLineHeadIndent = 15

        attributeString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Kyc.font.label,
            .foregroundColor: labelColor,
//            .kern: 0.0
        ], range: NSRange(location: 0, length: label.count))

        return attributeString
    }

    var attributedTitle: NSAttributedString {
        let attributeString = NSMutableAttributedString(string: title)
        let style = NSMutableParagraphStyle()

        attributeString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Kyc.font.title,
            .foregroundColor: titleColor,
            .kern: 0.0
        ], range: NSRange(location: 0, length: title.count))

        return attributeString
    }

    var attributedDescription: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: description)
        let style = NSMutableParagraphStyle()

        attributedString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Kyc.font.description,
            .foregroundColor: descriptionColor,
            .kern: 0.0
        ], range: NSRange(location: 0, length: description.count))

        return attributedString
    }
    
    var attributedName: NSAttributedString {
        let attributedString = NSMutableAttributedString(string: name)
        let style = NSMutableParagraphStyle()

        attributedString.addAttributes([
            .paragraphStyle: style,
            .font: Screen.Kyc.font.name,
            .foregroundColor: Screen.Kyc.Color.name,
            .kern: 0.0
        ], range: NSRange(location: 0, length: name.count))

        return attributedString
    }
    
    var labelColor: UIColor {
        switch status {
        case .verified:
            return Screen.Kyc.Color.verifiedLabel
        case .pending:
            return Screen.Kyc.Color.pendingLabel
        case .declined:
            return Screen.Kyc.Color.declinedLabel
        case .unverified:
            return Screen.Kyc.Color.unverifiedLabel
        }
    }
    
    var bgColor: UIColor {
        switch status {
        case .verified:
            return Screen.Kyc.Color.verifiedBg
        case .pending:
            return Screen.Kyc.Color.pendingBg
        case .declined:
            return Screen.Kyc.Color.declinedBg
        case .unverified:
            return Screen.Kyc.Color.unverifiedBg
        }
    }
    
    var titleColor: UIColor {
        switch status {
        case .verified:
            return Screen.Kyc.Color.verifiedTitle
        case .pending:
            return Screen.Kyc.Color.pendingTitle
        case .declined:
            return Screen.Kyc.Color.declinedTitle
        case .unverified:
            return Screen.Kyc.Color.unverifiedTitle
        }
    }
    
    var descriptionColor: UIColor {
        switch status {
        case .verified:
            return Screen.Kyc.Color.verifiedDescription
        case .pending:
            return Screen.Kyc.Color.pendingDescription
        case .declined:
            return Screen.Kyc.Color.declinedDescription
        case .unverified:
            return Screen.Kyc.Color.unverifiedDescription
        }
    }
    
    var label: String {
        switch status {
        case .verified:
            return R.string.localizable.kycStatusVerifiedLabel()
        case .pending:
            return R.string.localizable.kycStatusPendingLabel()
        case .declined:
            return R.string.localizable.kycStatusDeclinedLabel()
        case .unverified:
            return R.string.localizable.kycStatusUnverifiedLabel()
        }
    }
    
    var name: String {
        switch status {
        case .verified:
            if let name = config.nameKyc {
                return name
            } else {
                return ""
            }
        default:
            return ""
        }
    }
    
    var title: String {
        switch status {
        case .verified:
            return R.string.localizable.kycStatusVerifiedTitle()
        case .pending:
            return R.string.localizable.kycStatusPendingTitle()
        case .declined:
            return R.string.localizable.kycStatusDeclinedTitle()
        case .unverified:
            return R.string.localizable.kycStatusUnverifiedTitle()
        }
    }
    
    var description: String {
        switch status {
        case .verified:
            return R.string.localizable.kycStatusVerifiedDescription()
        case .pending:
            return R.string.localizable.kycStatusPendingDescription()
        case .declined:
            return R.string.localizable.kycStatusDeclinedDescription()
        case .unverified:
            return R.string.localizable.kycStatusUnverifiedDescription()
        }
    }
    
    var actionTitle: String {
        switch status {
        case .verified:
            return ""
        case .pending, .declined:
            return R.string.localizable.kycResubmitActionTitle()
        case .unverified:
            return R.string.localizable.kycStartActionTitle()
        }
    }
}
