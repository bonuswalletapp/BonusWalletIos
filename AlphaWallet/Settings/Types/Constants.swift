// Copyright SIX DAY LLC. All rights reserved.

import Foundation
import BigInt
import web3swift

public struct Constants {
    public static let keychainKeyPrefix = "alphawallet"
    public static let xdaiDropPrefix = Data(bytes:
        [0x58, 0x44, 0x41, 0x49, 0x44, 0x52, 0x4F, 0x50]
    ).hex()

    public static let mainnetMagicLinkHost = "aw.app"
    public static let legacyMagicLinkHost = "app.awallet.io"
    public static let classicMagicLinkHost = "classic.aw.app"
    public static let callistoMagicLinkHost = "callisto.aw.app"
    public static let kovanMagicLinkHost = "kovan.aw.app"
    public static let ropstenMagicLinkHost = "ropsten.aw.app"
    public static let rinkebyMagicLinkHost = "rinkeby.aw.app"
    public static let poaMagicLinkHost = "poa.aw.app"
    public static let sokolMagicLinkHost = "sokol.aw.app"
    public static let xDaiMagicLinkHost = "xdai.aw.app"
    public static let goerliMagicLinkHost = "goerli.aw.app"
    public static let artisSigma1MagicLinkHost = "artis_sigma1.aw.app"
    public static let artisTau1MagicLinkHost = "artis_tau1.aw.app"
    public static let binanceMagicLinkHost = "binance.aw.app"
    public static let binanceTestMagicLinkHost = "test-binance.aw.app"
    public static let hecoMagicLinkHost = "heco.aw.app"
    public static let hecoTestMagicLinkHost = "test-heco.aw.app"
    public static let customMagicLinkHost = "custom.aw.app"
    public static let fantomMagicLinkHost = "fantom.aw.app"
    public static let fantomTestMagicLinkHost = "test-fantom.aw.app"
    public static let avalancheMagicLinkHost = "avalanche.aw.app"
    public static let avalancheTestMagicLinkHost = "test-avalanche.aw.app"
    public static let maticMagicLinkHost = "polygon.aw.app"
    public static let mumbaiTestMagicLinkHost = "test-polygon.aw.app"
    public static let optimisticMagicLinkHost = "optimistic.aw.app"
    public static let optimisticTestMagicLinkHost = "optimistic-kovan.aw.app"
    public static let cronosTestMagicLinkHost = "test-cronos.aw.app"
    public static let arbitrumMagicLinkHost = "arbitrum.aw.app"
    public static let palmMagicLinkHost = "palm.aw.app"
    public static let palmTestnetMagicLinkHost = "palmTestnet.aw.app"

    public enum Currency {
        static let usd = "USD"
    }
    // Magic link networks
    public static let legacyMagicLinkPrefix = "https://app.awallet.io/"

    // fee master
    public static let paymentServer = "https://paymaster.stormbird.sg/api/claimToken"
    public static let paymentServerSpawnable = "https://paymaster.stormbird.sg/api/claimSpawnableToken"
    public static let paymentServerSupportsContractEndPoint = "https://paymaster.stormbird.sg/api/checkContractIsSupportedForFreeTransfers"
    public static let paymentServerClaimedToken = "https://paymaster.stormbird.sg/api/checkIfSignatureIsUsed"
    public static let currencyDropServer = "https://paymaster.stormbird.sg/api/claimFreeCurrency"

    // social
    public static let website = "https://jaxwallet.io/"
    public static let twitterUsername = ""
    public static let redditGroupName = ""
    public static let facebookUsername = ""

    // support
    public static let supportEmail = "feedback@jaxwallet.io"
    public static let dappsBrowserURL = "https://beta.jax.money/exchange.html"

    //Ethereum null variables
    public static let nullTokenId = "0x0000000000000000000000000000000000000000000000000000000000000000"
    public static let nullTokenIdBigUInt = BigUInt(0)
    public static let burnAddressString = "0x000000000000000000000000000000000000dEaD"
    static let nullAddress = AlphaWallet.Address(uncheckedAgainstNullAddress: "0x0000000000000000000000000000000000000000")!
    static let nativeCryptoAddressInDatabase = nullAddress

    // FIFA hardcoded FIFA token address
    static let ticketContractAddress = AlphaWallet.Address(string: "0xA66A3F08068174e8F005112A8b2c7A507a822335")!
    static let ticketContractAddressRopsten = AlphaWallet.Address(string: "0xD8e5F58DE3933E1E35f9c65eb72cb188674624F3")!

    // UEFA hardcoded addresses
    static let uefaMainnet = AlphaWallet.Address(string: "0x89D142Bef8605646881C68dcD48cDAF17FE597dC")!
    static let uefaRpcServer = RPCServer.main

    //UEFA 721 balances function hash
    static let balances165Hash721Ticket = "0xc84aae17"

    //OpenSea links for erc721 assets
    public static let openseaAPI = "https://api.opensea.io/"
    public static let openseaRinkebyAPI = "https://rinkeby-api.opensea.io/"
    //Using "kat" instead of "cryptokitties" to avoid being mistakenly detected by app review as supporting CryptoKitties
    public static let katContractAddress = "0x06012c8cf97bead5deae237070f9587f8e7a266d"

    //xDai dapps
    static let xDaiBridge = URL(string: "https://bridge.xdaichain.com/")!
    static let arbitrumBridge = URL(string: "https://bridge.arbitrum.io/")!
    static let buyXDaiWitRampUrl = "https://buy.ramp.network/?hostApiKey=\(Constants.Credentials.rampApiKey)&hostLogoUrl=https%3A%2F%2Falphawallet.com%2Fwp-content%2Fthemes%2Falphawallet%2Fimg%2Falphawallet-logo.svg&hostAppName=AlphaWallet&swapAsset=xDai"

    static func buyWitRampUrl(asset: String) -> String {
        "https://buy.ramp.network/?hostApiKey=\(Constants.Credentials.rampApiKey)&hostLogoUrl=https%3A%2F%2Falphawallet.com%2Fwp-content%2Fthemes%2Falphawallet%2Fimg%2Falphawallet-logo.svg&hostAppName=AlphaWallet&swapAsset=\(asset)"
    }

    //ENS
    static let ENSRecordsContractAddress = AlphaWallet.Address(string: "0x4976fb03C32e5B8cfe2b6cCB31c09Ba78EBaBa41")!
    static let ENSRecordsContractAddressPOA = AlphaWallet.Address(string: "0xF60cd4F86141D7Fe4A1A9961451Ea09230A14617")!
    static let ENSRegistrarAddress = AlphaWallet.Address(string: "0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e")!
    static let ENSRegistrarRopsten = ENSRegistrarAddress
    static let ENSRegistrarRinkeby = ENSRegistrarAddress
    static let ENSRegistrarGoerli = ENSRegistrarAddress

    static let highStandardGasThresholdGwei = BigInt(55)
    //DAS
    static let dasLookupURL = URL(string: "https://indexer.da.systems/")!

    //Misc
    public static let etherReceivedNotificationIdentifier = "etherReceivedNotificationIdentifier"
    public static let alertReceivedNotificationIdentifier = "alertReceivedNotificationIdentifier"
    static let legacy875Addresses = [AlphaWallet.Address(string: "0x830e1650a87a754e37ca7ed76b700395a7c61614")!,
                                            AlphaWallet.Address(string: "0xa66a3f08068174e8f005112a8b2c7a507a822335")!]
    static let legacy721Addresses = [
        AlphaWallet.Address(string: "0x06012c8cf97bead5deae237070f9587f8e7a266d")!,
        AlphaWallet.Address(string: "0xabc7e6c01237e8eef355bba2bf925a730b714d5f")!,
        AlphaWallet.Address(string: "0x71c118b00759b0851785642541ceb0f4ceea0bd5")!,
        AlphaWallet.Address(string: "0x7fdcd2a1e52f10c28cb7732f46393e297ecadda1")!
    ]

    static let ethDenverXDaiPartnerContracts = [
        (name: "DEN", contract: AlphaWallet.Address(string: "0x6a814843de5967cf94d7720ce15cba8b0da81967")!),
        (name: "BURN", contract: AlphaWallet.Address(string: "0x94819805310cf736198df0de856b0ff5584f0903")!),
        (name: "BURN", contract: AlphaWallet.Address(string: "0xdec31651bec1fbbff392aa7de956d6ee4559498b")!),
        (name: "BURN", contract: AlphaWallet.Address(string: "0xa95d505e6933cb790ed3431805871efe4e6bbafd")!),
        (name: "DEN", contract: AlphaWallet.Address(string: "0xbdc3df563a3959a373916b724c683d69ba4097f7")!),
        (name: "DEN", contract: AlphaWallet.Address(string: "0x6e251ee9cadf0145babfd3b64664a9d7f941fcc3")!),
        (name: "BUFF", contract: AlphaWallet.Address(string: "0x3e50bf6703fc132a94e4baff068db2055655f11b")!),
        (name: "ETHD2019", contract: AlphaWallet.Address(string: "0xa16b70E8fAd839E62aBBa2d962E4ca5a28aF9e76")!)
    ]

//    static let partnerContracts = [
//
//    ]
    
    static let bscPartnerContracts = [
        (name: "WJXN", contract: AlphaWallet.Address(string: "0xCA1262E77FB25C0A4112CFC9BAD3FF54F617F2E6")!),
    ]

//    static let rinkebyPartnerContracts = [
//        (name: "WJXN", contract: AlphaWallet.Address(string: "0xc43860f43daA9448C483C103Af5C851ec5B6aD3e")!),
//    ]
    
    static let bscTestPartnerContracts = [
        (name: "WJXN", contract: AlphaWallet.Address(string: "0x3a171b7c5d671e3c4bb5823b8fd265f4e4e9a399")!),
        (name: "BUSD", contract: AlphaWallet.Address(string: "0xa51bcdc792285598ba7443c71d557e0b7df6f991")!),
        (name: "WJAX", contract: AlphaWallet.Address(string: "0x783f4a2efab4f34d6a0d88b71cf1fac6d9b46ff0")!),
        (name: "JAX DOLLAR", contract: AlphaWallet.Address(string: "0xb8bdd95b52ea5b815aaa214aedb8d01aed787157")!),
        (name: "JAX RUPEE", contract: AlphaWallet.Address(string: "0xec7d5848f88246ca6984b8019d08b8524793b062")!),
    ]
    
    static func isPartnerContracts(name: String) -> Bool {
        for contract in bscPartnerContracts where name == contract.name {
            return true
        }
        for contract in bscTestPartnerContracts where name == contract.name {
            return true
        }
        return false
    }

    static let ensContractOnMainnet = AlphaWallet.Address.ethereumAddress(eip55String: "0x57f1887a8BF19b14fC0dF6Fd9B2acc9Af147eA85")

    static let defaultEnabledServers: [RPCServer] = [.binance_smart_chain]
    static let defaultEnabledTestnetServers: [RPCServer] = [.binance_smart_chain_testnet]

    static let tokenScriptUrlSchemeForResources = "tokenscript-resource:///"

    //validator API
    static let tokenScriptValidatorAPI = "https://aw.app/api/v1/verifyXMLDSig"

    static let launchShortcutKey = "com.stormbird.alphawallet.qrScanner"

    //CurrencyFormatter
    static let formatterFractionDigits = 2

    //EtherNumberFormatter
    static let etherFormatterFractionDigits = 4

    static let defaultSortTokensParams: [SortTokensParam] =  [
        .byField(field: .name, direction: .ascending),
        .byField(field: .name, direction: .descending),
        .byField(field: .value, direction: .ascending),
        .byField(field: .value, direction: .descending)
    ]
}

public struct UnitConfiguration {
    public static let gasPriceUnit: EthereumUnit = .gwei
    public static let gasFeeUnit: EthereumUnit = .ether
    public static let finneyUnit: EthereumUnit = .finney
}

extension URL {
    static var forResolvingDAS: URL {
        return Constants.dasLookupURL
    }
}
