// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit
import BigInt

struct FungibleTokenViewCellViewModel {
    private let shortFormatter = EtherNumberFormatter.short
    private let token: TokenObject
    private let ticker: CoinTicker?
    private let assetDefinitionStore: AssetDefinitionStore
    private let isVisible: Bool

    init(token: TokenObject, assetDefinitionStore: AssetDefinitionStore, isVisible: Bool = true, ticker: CoinTicker?) {
        self.token = token
        self.ticker = ticker
        self.assetDefinitionStore = assetDefinitionStore
        self.isVisible = isVisible
    }

    private var name: String {
//        if !token.symbol.isEmpty {
//            return "\(token.shortTitleInPluralForm(withAssetDefinitionStore: assetDefinitionStore)) (\(token.symbol))"
//        }
        return token.shortTitleInPluralForm(withAssetDefinitionStore: assetDefinitionStore)
    }

    private var amount_USD: String {
        let string = shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals)
        if let floatValue = Double(string), let value = EthCurrencyHelper(ticker: ticker).marketPrice {
            let nummber = floatValue * value
            return NumberFormatter.usd(format: .withLeadingCurrencySymbol(positiveSymbol: "")).string(from: nummber) ?? "_"
        }
        return string
    }
    
    private var amount: String {
        let string = shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals)
        return string
    }
    
    private var networkName: String {
        return token.server.getShortName()
    }

    var backgroundColor: UIColor {
        return Colors.clear
    }

    var contentsBackgroundColor: UIColor {
        return Colors.appWhite
    }

    var nameAttributedString: NSAttributedString {
        return NSAttributedString(string: name, attributes: [
            .foregroundColor: Screen.TokenCard.Color.title,
            .font: Fonts.regular(size: 12)
        ])
    }
    
    var symbolAttributedString: NSAttributedString {
        return NSAttributedString(string: token.symbol.isEmpty ? "" : token.symbol, attributes: [
            .foregroundColor: Screen.TokenCard.Color.title,
            .font: Fonts.bold(size: 14)
        ])
    }
    
    var networkNameAttributedString: NSAttributedString {
        return NSAttributedString(string: "\(networkName)", attributes: [
            .foregroundColor: Colors.appGrayLabel,
            .font: Fonts.regular(size: 12)
        ])
    }

    var cryptoValueAttributedString: NSAttributedString {
        return NSAttributedString(string: amount, attributes: [
            .foregroundColor: Screen.TokenCard.Color.title,
            .font: Fonts.regular(size: 14)
        ])
    }

    private var valuePercentageChangeColor: UIColor {
        return Screen.TokenCard.Color.valueChangeValue(ticker: ticker)
    }

    var apprecation24hoursBackgroundColor: UIColor {
        valuePercentageChangeColor.withAlphaComponent(0.07)
    }

    var apprecationViewModel: ApprecationViewModel {
        .init(icon: apprecation24hoursImage, valueAttributedString: apprecation24hoursAttributedString, backgroundColor: apprecation24hoursBackgroundColor)
    }

    private var apprecation24hoursAttributedString: NSAttributedString {
        let apprecation24hours: String = {
            switch EthCurrencyHelper(ticker: ticker).change24h {
            case .appreciate(let percentageChange24h):
                return "(\(percentageChange24h)%)"
            case .depreciate(let percentageChange24h):
                return "(\(percentageChange24h)%)"
            case .none:
                return "-"
            }
        }()

        return NSAttributedString(string: apprecation24hours, attributes: [
            .foregroundColor: valuePercentageChangeColor,
            .font: Fonts.regular(size: 12)
        ])
    }

    private var apprecation24hoursImage: UIImage? {
        switch EthCurrencyHelper(ticker: ticker).change24h {
        case .appreciate:
            return R.image.price_up()
        case .depreciate:
            return R.image.price_down()
        case .none:
            return .none
        }
    }

    private var priceChangeUSDValue: String {
        if let result = EthCurrencyHelper(ticker: ticker).valueChanged24h(value: token.optionalDecimalValue) {
            return NumberFormatter.usd(format: .withTrailingCurrency).string(from: result) ?? " 0.0000"
        } else {
            return "-"
        }
    }

    private var marketPriceValue: String {
        if let value = EthCurrencyHelper(ticker: ticker).marketPrice {
            return NumberFormatter.usd(format: .withLeadingCurrencySymbol(positiveSymbol: "")).string(from: value) ?? "-"
        } else {
            return "-"
        }
    }
    
    var priceChangeUSDValueAttributedString: NSAttributedString {
        return NSAttributedString(string: marketPriceValue, attributes: [
            .foregroundColor: Colors.appGrayLabel,
            .font: Fonts.regular(size: 12)
        ])
    }

    private var fiatValue: String {
        if let fiatValue = EthCurrencyHelper(ticker: ticker).fiatValue(value: token.optionalDecimalValue) {
            return NumberFormatter.usd(format: .fiatFormat).string(from: fiatValue) ?? "-"
        } else {
            return "-"
        }
    }

    var fiatValueAttributedString: NSAttributedString {
        return NSAttributedString(string: amount_USD, attributes: [
            .foregroundColor: Screen.TokenCard.Color.subtitle,
            .font: Fonts.bold(size: 12)
        ])
    }

    var alpha: CGFloat {
        return isVisible ? 1.0 : 0.4
    }

    var iconImage: Subscribable<TokenImage> {
        token.icon
    }

    var blockChainTagViewModel: BlockchainTagLabelViewModel {
        return .init(server: token.server)
    }
}
