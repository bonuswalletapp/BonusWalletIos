// Copyright © 2018 Stormbird PTE. LTD.

import Foundation
import UIKit
import BigInt
import PromiseKit

struct TokenViewControllerViewModel {
    private let shortFormatter = EtherNumberFormatter.short
    private let transactionType: TransactionType
    private let session: WalletSession
    private let assetDefinitionStore: AssetDefinitionStore
    private (set) var tokenActionsProvider: TokenActionsProvider
    var chartHistory: [ChartHistory] = []

    var token: TokenObject? {
        switch transactionType {
        case .nativeCryptocurrency(let token, _, _):
            //TODO might as well just make .nativeCryptocurrency hold the TokenObject instance too
//            return TokensDataStore.etherToken(forServer: session.server)
            return token
        case .erc20Token(let token, _, _):
            return token
        case .erc875Token, .erc875TokenOrder, .erc721Token, .erc721ForTicketToken, .erc1155Token, .dapp, .tokenScript, .claimPaidErc875MagicLink:
            return nil
        }
    }

    var actions: [TokenInstanceAction] {
        guard let token = token else { return [] }
        let xmlHandler = XMLHandler(token: token, assetDefinitionStore: assetDefinitionStore)
        let actionsFromTokenScript = xmlHandler.actions
        let key = TokenActionsServiceKey(tokenObject: token)

        if actionsFromTokenScript.isEmpty {
            switch token.type {
            case .erc875:
                return []
            case .erc721:
                return []
            case .erc721ForTickets:
                return []
            case .erc1155:
                return []
            case .erc20:
                let actions: [TokenInstanceAction] = [
                    .init(type: .erc20Send),
                    .init(type: .erc20Receive)
                ]

                return actions + tokenActionsProvider.actions(token: key)
            case .nativeCryptocurrency:
                let actions: [TokenInstanceAction] = [
                    .init(type: .erc20Send),
                    .init(type: .erc20Receive)
                ]
                switch token.server {
                case .xDai:
                    return [.init(type: .erc20Send), .init(type: .erc20Receive)] + tokenActionsProvider.actions(token: key)
                case .main, .kovan, .ropsten, .rinkeby, .poa, .sokol, .classic, .callisto, .goerli, .artis_sigma1, .artis_tau1, .binance_smart_chain, .binance_smart_chain_testnet, .heco, .heco_testnet, .custom, .fantom, .fantom_testnet, .avalanche, .avalanche_testnet, .polygon, .mumbai_testnet, .optimistic, .optimisticKovan, .cronosTestnet, .arbitrum, .palm, .palmTestnet:
                    return actions + tokenActionsProvider.actions(token: key)
                }
            }
        } else {
            switch token.type {
            case .erc875, .erc721, .erc721ForTickets, .erc1155:
                return actionsFromTokenScript
            case .erc20:
                return actionsFromTokenScript + tokenActionsProvider.actions(token: key)
            case .nativeCryptocurrency:
//                TODO we should support retrieval of XML (and XMLHandler) based on address + server. For now, this is only important for native cryptocurrency. So might be ok to check like this for now
                if let server = xmlHandler.server, server.matches(server: token.server) {
                    return actionsFromTokenScript + tokenActionsProvider.actions(token: key)
                } else {
                    //TODO .erc20Send and .erc20Receive names aren't appropriate
                    let actions: [TokenInstanceAction] = [
                        .init(type: .erc20Send),
                        .init(type: .erc20Receive)
                    ]

                    return actions + tokenActionsProvider.actions(token: key)
                }
            }
        }
    }

    var tokenScriptStatus: Promise<TokenLevelTokenScriptDisplayStatus> {
        if let token = token {
            let xmlHandler = XMLHandler(token: token, assetDefinitionStore: assetDefinitionStore)
            return xmlHandler.tokenScriptStatus
        } else {
            assertImpossibleCodePath()
            return .value(.type2BadTokenScript(isDebugMode: false, message: "Unknown", reason: nil))
        }
    }

    var fungibleBalance: BigInt? {
        switch transactionType {
        case .nativeCryptocurrency:
            return session.balanceCoordinator.ethBalanceViewModel.value
        case .erc20Token(let tokenObject, _, _):
            return tokenObject.valueBigInt
        case .erc875Token, .erc875TokenOrder, .erc721Token, .erc721ForTicketToken, .erc1155Token, .dapp, .tokenScript, .claimPaidErc875MagicLink:
            return nil
        }
    }

    var balanceViewModel: BalanceBaseViewModel? {
        switch transactionType {
        case .nativeCryptocurrency:
            return session.balanceCoordinator.subscribableEthBalanceViewModel.value
        case .erc20Token(let token, _, _):
            return session.balanceCoordinator.subscribableTokenBalance(token.addressAndRPCServer).value
        case .erc875Token, .erc875TokenOrder, .erc721Token, .erc721ForTicketToken, .erc1155Token, .dapp, .tokenScript, .claimPaidErc875MagicLink:
            return nil
        }
    }

    init(transactionType: TransactionType, session: WalletSession, assetDefinitionStore: AssetDefinitionStore, tokenActionsProvider: TokenActionsProvider) {
        self.transactionType = transactionType
        self.session = session
        self.assetDefinitionStore = assetDefinitionStore
        self.tokenActionsProvider = tokenActionsProvider
    }

    var destinationAddress: AlphaWallet.Address {
        return transactionType.contract
    }

    var backgroundColor: UIColor {
        return Colors.appBackground
    }

    var showAlternativeAmount: Bool {
        guard let coinTicker = session.balanceCoordinator.coinTicker(transactionType.addressAndRPCServer), coinTicker.price_usd > 0 else {
            return false
        }
        return true
    }
    
    var ticker: CoinTicker? {
        guard let coinTicker = session.balanceCoordinator.coinTicker(transactionType.addressAndRPCServer) else { return nil }
        return coinTicker
    }

    var sendButtonTitle: String {
        return R.string.localizable.send()
    }

    var receiveButtonTitle: String {
        return R.string.localizable.receive()
    }
    
    private var amount_USD: String {
        if let token = token {
            let string = shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals)
            if let floatValue = Double(string), let value = EthCurrencyHelper(ticker: ticker).marketPrice {
                let nummber = floatValue * value
                return NumberFormatter.usd(format: .withTrailingCurrency).string(from: nummber) ?? "_"
            }
            return string
        }
        return "-"
    }
    
    private var amount: String {
        if let token = token {
            let string = shortFormatter.string(from: BigInt(token.value) ?? BigInt(), decimals: token.decimals)
            return string
        }
        return "-"
    }

    private var title: String {
        if let token = token {
            if !token.symbol.isEmpty {
                return "\(token.shortTitleInPluralForm(withAssetDefinitionStore: assetDefinitionStore)) (\(token.symbol))"
            } else {
                return token.shortTitleInPluralForm(withAssetDefinitionStore: assetDefinitionStore)
            }
        } else {
            return "-"
        }
    }

    var titleAttributedString: NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            .foregroundColor: Colors.headerThemeColor,
            .font: Fonts.bold(size: 14)
        ])
    }
    
    private var marketPriceValue: String {
        if let value = EthCurrencyHelper(ticker: ticker).marketPrice {
            return NumberFormatter.usd.string(from: value) ?? "-"
        } else {
            return "-"
        }
    }

    var cryptoValueAttributedString: NSAttributedString {
        return NSAttributedString(string: amount_USD, attributes: [
            .foregroundColor: Screen.TokenCard.Color.subtitle,
            .font: Fonts.regular(size: 9)
        ])
    }

    private var valuePercentageChangeColor: UIColor {
        return Screen.TokenCard.Color.valueChangeValue(ticker: ticker)
    }

    private var apprecation24hoursBackgroundColor: UIColor {
        valuePercentageChangeColor.withAlphaComponent(0.07)
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

    private var apprecation24hoursAttributedString: NSAttributedString {
        let valuePercentageChangeValue: String = {
            switch EthCurrencyHelper(ticker: ticker).change24h {
            case .appreciate(let percentageChange24h):
                return "(+\(percentageChange24h)%)"
            case .depreciate(let percentageChange24h):
                return "(\(percentageChange24h)%)"
            case .none:
                return "-"
            }
        }()

        return NSAttributedString(string: valuePercentageChangeValue, attributes: [
            .foregroundColor: valuePercentageChangeColor,
            .font: Fonts.regular(size: 9)
        ])
    }

    private var priceChangeUSDValue: String {
        if let token = token, let result = EthCurrencyHelper(ticker: ticker).valueChanged24h(value: token.optionalDecimalValue) {
            return NumberFormatter.usd(format: .withTrailingCurrency).string(from: result) ?? "-"
        } else {
            return "-"
        }
    }

    var priceChangeUSDValueAttributedString: NSAttributedString {
        return NSAttributedString(string: marketPriceValue, attributes: [
            .foregroundColor: Colors.priceColor,
            .font: Fonts.regular(size: 9)
        ])
    }
    
    var fiatValueAttributedString: NSAttributedString {
        return NSAttributedString(string: amount.replacingOccurrences(of: "$", with: ""), attributes: [
            .foregroundColor: Colors.headerThemeColor,
            .font: Fonts.bold(size: 14)
        ])
    }

    var alpha: CGFloat {
        return 1.0
    }

    var iconImage: Subscribable<TokenImage>? {
        token?.icon
    }

    var blockChainTagViewModel: BlockchainTagLabelViewModel? {
        guard let server = token?.server else { return nil }
        return .init(server: server)
    }

    private func amountAccordingRPCServer(currencyAmount: String?) -> String? {
        if token?.server.isTestnet == true {
            return nil
        } else {
            return currencyAmount
        }
    }

    func fiatValueAttributedString(currencyAmount: String?) -> NSAttributedString {
        return NSAttributedString(string: amountAccordingRPCServer(currencyAmount: currencyAmount) ?? "-", attributes: [
            .foregroundColor: Screen.TokenCard.Color.title,
            .font: Screen.TokenCard.Font.valueChangeValue
        ])
    }

    private func priceChangeUSDValue(ticker: CoinTicker?) -> String {
        if let token = token, let result = EthCurrencyHelper(ticker: ticker).valueChanged24h(value: token.optionalDecimalValue) {
            return NumberFormatter.usd.string(from: result) ?? "-"
        } else {
            return "-"
        }
    }

    func apprecation24hoursBackgroundColor(ticker: CoinTicker?) -> UIColor {
        valuePercentageChangeColor(ticker: ticker).withAlphaComponent(0.07)
    }

    var apprecationViewModel: ApprecationViewModel {
        .init(icon: apprecation24hoursImage, valueAttributedString: apprecation24hoursAttributedString, backgroundColor: apprecation24hoursBackgroundColor)
    }

    private func valuePercentageChangeColor(ticker: CoinTicker?) -> UIColor {
        return Screen.TokenCard.Color.valueChangeValue(ticker: ticker)
    } 
    
}
