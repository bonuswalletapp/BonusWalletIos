// Copyright © 2020 Stormbird PTE. LTD.

import UIKit

struct WalletConnectSessionCellViewModel {
    let session: WalletConnectSession
    let server: RPCServer

    var backgroundColor: UIColor {
        Colors.appWhite
    }

    var serverIconImage: Subscribable<Image> {
        server.walletConnectIconImage
    }

    var sessionNameAttributedString: NSAttributedString {
        return .init(string: "\(session.dAppInfo.peerMeta.name)", attributes: [
            .font: Fonts.bold(size: 14),
            .foregroundColor: Colors.appText
        ])
    }

    var sessionURLAttributedString: NSAttributedString {
        return .init(string: session.dAppInfo.peerMeta.url.absoluteString, attributes: [
            .font: Fonts.regular(size: 12),
            .foregroundColor: R.color.dove()!
        ])
    }

    var sessionIconURL: URL? {
        return session.dAppInfo.peerMeta.icons.first
    }
    
}
