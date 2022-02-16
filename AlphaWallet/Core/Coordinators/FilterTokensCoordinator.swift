//
//  FilterTokensCoordinator.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 30.03.2020.
//

import UIKit

class FilterTokensCoordinator {
    private enum FilterKeys: String {
        case swap
    }

    private let assetDefinitionStore: AssetDefinitionStore
    private let tokenActionsService: TokenActionsServiceType
    var singleChainTokenCoordinators = [SingleChainTokenCoordinator]()
    private var address: String = ""
    private var name: String = ""
    private var symbol: String = ""
    private var tokenType: TokenType? = nil
    private var decimals: String = ""
    private var balance: String = ""
    
    private var ERC875TokenBalance: [String] = []

    private var ERC875TokenBalanceAmount: Int {
        var balance = 0
        if !ERC875TokenBalance.isEmpty {
            for _ in 0...ERC875TokenBalance.count - 1 {
                balance += 1
            }
        }
        return balance
    }

    init(assetDefinitionStore: AssetDefinitionStore, tokenActionsService: TokenActionsServiceType) {
        self.assetDefinitionStore = assetDefinitionStore
        self.tokenActionsService = tokenActionsService
    }

    func filterTokens(tokens: [TokenObject], filter: WalletFilter) -> [TokenObject] {
        let filteredTokens: [TokenObject]
        switch filter {
        case .all:
            filteredTokens = tokens
        case .type(let types):
            filteredTokens = tokens.filter { types.contains($0.type) }
        case .currencyOnly:
            filteredTokens = tokens.filter { Constants.isPartnerContracts(name: $0.symbol) }
        case .assetsOnly:
            filteredTokens = tokens.filter { $0.type != .nativeCryptocurrency && $0.type != .erc20 }
        case .collectiblesOnly:
            filteredTokens = tokens.filter { ($0.type == .erc721 || $0.type == .erc1155) && !$0.balance.isEmpty }
        case .keyword(let keyword):
            let lowercasedKeyword = keyword.trimmed.lowercased()
            if lowercasedKeyword.isEmpty {
                filteredTokens = tokens
            } else {
                filteredTokens = tokens.filter {
                    if lowercasedKeyword == "erc20" || lowercasedKeyword == "erc 20" {
                        return $0.type == .erc20
                    } else if lowercasedKeyword == "erc721" || lowercasedKeyword == "erc 721" {
                        return $0.type == .erc721
                    } else if lowercasedKeyword == "erc875" || lowercasedKeyword == "erc 875" {
                        return $0.type == .erc875
                    } else if lowercasedKeyword == "erc1155" || lowercasedKeyword == "erc 1155" {
                        return $0.type == .erc1155
                    } else if lowercasedKeyword == "tokenscript" {
                        let xmlHandler = XMLHandler(token: $0, assetDefinitionStore: assetDefinitionStore)
                        return xmlHandler.hasNoBaseAssetDefinition && (xmlHandler.server?.matches(server: $0.server) ?? false)
                    } else if lowercasedKeyword == FilterKeys.swap.rawValue {
                        let key = TokenActionsServiceKey(tokenObject: $0)
                        return tokenActionsService.isSupport(token: key)
                    } else {
                        return $0.name.trimmed.lowercased().contains(lowercasedKeyword) ||
                                $0.symbol.trimmed.lowercased().contains(lowercasedKeyword) ||
                                $0.contract.lowercased().contains(lowercasedKeyword) ||
                                $0.title(withAssetDefinitionStore: assetDefinitionStore).trimmed.lowercased().contains(lowercasedKeyword) ||
                                $0.titleInPluralForm(withAssetDefinitionStore: assetDefinitionStore).trimmed.lowercased().contains(lowercasedKeyword)
                    }
                }
            }
        }

        return filteredTokens
    }

    func filterTokens(tokens: [PopularToken], walletTokens: [TokenObject], filter: WalletFilter) -> [PopularToken] {
        var filteredTokens: [PopularToken] = tokens.filter { token in
            !walletTokens.contains(where: { $0.contractAddress.sameContract(as: token.contractAddress) }) && !token.name.isEmpty
        }

        switch filter {
        case .all:
            break //no-op
        case .type, .currencyOnly, .assetsOnly, .collectiblesOnly:
            filteredTokens = []
        case .keyword(let keyword):
            let lowercasedKeyword = keyword.trimmed.lowercased()
            if lowercasedKeyword.isEmpty {
                break //no-op
            } else {
                filteredTokens = filteredTokens.filter {
                    return $0.name.trimmed.lowercased().contains(lowercasedKeyword)
                }
            }
        }

        return filteredTokens
    }

    func sortDisplayedTokens(tokens: [TokenObject]) -> [TokenObject] {
        let nativeCryptoAddressInDatabase = Constants.nativeCryptoAddressInDatabase.eip55String

        let result = tokens.filter {
            $0.shouldDisplay
        }.sorted(by: {
            if let value1 = $0.sortIndex.value, let value2 = $1.sortIndex.value {
                return value1 < value2
            } else {
                let contract0 = $0.contract
                let contract1 = $1.contract

                if contract0 == nativeCryptoAddressInDatabase && contract1 == nativeCryptoAddressInDatabase {
                    return $0.server.displayOrderPriority < $1.server.displayOrderPriority
                } else if contract0 == nativeCryptoAddressInDatabase {
                    return true
                } else if contract1 == nativeCryptoAddressInDatabase {
                    return false
                } else if $0.server != $1.server {
                    return $0.server.displayOrderPriority < $1.server.displayOrderPriority
                } else {
                    return false
                }
            }
        })

        return result
    }

    func sortDisplayedTokens(tokens: [TokenObject], sortTokensParam: SortTokensParam) -> [TokenObject] {
        let result = tokens.filter {
            $0.shouldDisplay
        }.sorted(by: {
            switch sortTokensParam {
            case .byField(let field, let direction):
                switch (field, direction) {
                case (.name, .ascending):
                    return $0.name.lowercased() < $1.name.lowercased()
                case (.name, .descending):
                    return $0.name.lowercased() > $1.name.lowercased()
                case (.value, .ascending):
                    return $0.value.lowercased() < $1.value.lowercased()
                case (.value, .descending):
                    return $0.value.lowercased() > $1.value.lowercased()
                }
            case .mostUsed:
                // NOTE: not implemented yet
                return false
            }
        })

        return result
    }
}

extension FilterTokensCoordinator {
    
    private func singleChainTokenCoordinator(forServer server: RPCServer) -> SingleChainTokenCoordinator? {
        singleChainTokenCoordinators.first { $0.isServer(server) }
    }

    private func fetchContractData(forServer server: RPCServer, address: AlphaWallet.Address, inViewController viewController: TokensViewController) {
        guard let coordinator = singleChainTokenCoordinator(forServer: server) else { return }
        coordinator.fetchContractData(for: address) { data in
            switch data {
            case .name(let name):
                self.name = name
            case .symbol(let symbol):
                self.symbol = symbol
            case .balance(let balance, let tokenType):
                let filteredTokens = balance.filter { isNonZeroBalance($0, tokenType: tokenType) }
                self.ERC875TokenBalance = filteredTokens
                self.balance = self.ERC875TokenBalanceAmount.description
            case .decimals(let decimals):
                self.decimals = String(decimals)
            case .nonFungibleTokenComplete(_, _, _, let tokenType):
                self.tokenType = tokenType
            case .fungibleTokenComplete:
                self.tokenType = .erc20
            case .delegateTokenComplete:
                self.tokenType = .erc20
            case .failed:
                break
            }
            self.addToken(server: server)
        }
    }

    func addToken(server: RPCServer) {
        guard self.validate() else { return }
        let contract = self.address
        let name = self.name
        let symbol = self.symbol
        let decimals = Int(self.decimals) ?? 0
        guard let tokenType = self.tokenType else { return }
        //TODO looks wrong to mention ERC875TokenBalance specifically
        var balance: [String] = self.ERC875TokenBalance
        guard let address = AlphaWallet.Address(string: contract) else {
            return
        }

        if balance.isEmpty {
            balance.append("0")
        }
        let ercToken = ERCToken(
            contract: address,
            server: server,
            name: name,
            symbol: symbol,
            decimals: decimals,
            type: tokenType,
            balance: balance)
        guard let coordinator = singleChainTokenCoordinator(forServer: ercToken.server) else { return }
        _ = coordinator.add(token: ercToken)
    }
    
    private func validate() -> Bool {
        var isValid: Bool = true
        if address.trimmed.isEmpty {
            isValid = false
        }
        if name.trimmed.isEmpty {
            isValid = false
        }
        if symbol.trimmed.isEmpty {
            isValid = false
        }

        if let tokenType = tokenType {
            switch tokenType {
            case .nativeCryptocurrency, .erc20:
                if decimals.trimmed.isEmpty {
                    isValid = false
                }
            case .erc721, .erc875, .erc721ForTickets, .erc1155:
                if decimals.trimmed.isEmpty {
                    isValid = false
                }
            }
        } else {
            isValid = false
        }

        return isValid
    }
    
}
