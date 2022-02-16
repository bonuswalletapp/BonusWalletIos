// Copyright © 2021 Stormbird PTE. LTD.
import Foundation
import BigInt

enum TransactionRow {
    case standalone(TransactionInstance)
    //TODO this seems to overlap with the `ActivityRowModel.parentTransaction`
    case group(TransactionInstance)
    case item(transaction: TransactionInstance, operation: LocalizedOperationObjectInstance)
    case activity(transaction: TransactionInstance, activity: Activity)

    var transaction: TransactionInstance {
        switch self {
        case .standalone(let transaction), .group(let transaction), .item(transaction: let transaction, _), .activity(transaction: let transaction, _):
            return transaction
        }
    }

    var id: String {
        transaction.id
    }
    var blockNumber: Int {
        transaction.blockNumber
    }
    var transactionIndex: Int {
        transaction.transactionIndex
    }
    var from: String {
        switch self {
        case .standalone(let transaction):
            return transaction.operation?.from ?? transaction.from
        case .group(let transaction):
            return transaction.from
        case .item(_, operation: let operation):
            return operation.from
        case .activity(_, activity: let activity):
            if let address = activity.values.card.fromAddressValue?.address {
                return address
            } else {
                return ""
            }
        }
    }
    var to: String {
        switch self {
        case .standalone(let transaction):
            return transaction.operation?.to ?? transaction.to
        case .group(let transaction):
            return transaction.to
        case .item(_, operation: let operation):
            return operation.to
        case .activity(_, activity: let activity):
            if let address = activity.values.card.toAddressValue?.address {
                return address
            } else {
                return ""
            }
        }
    }
    var value: String {
        switch self {
        case .standalone(let transaction):
            return transaction.operation?.value ?? transaction.value
        case .group(let transaction):
            return transaction.value
        case .item(_, operation: let operation):
            return operation.value
        case .activity(_, activity: let activity):
            if let amount = activity.values.card.amountUIntValue {
                let formatter = EtherNumberFormatter.short
                let value = formatter.string(from: BigInt(amount), decimals: activity.tokenObject.decimals)
                return value
            } else {
                return ""
            }
        }
    }
    var gas: String {
        transaction.gas
    }
    var gasPrice: String {
        transaction.gasPrice
    }
    var gasUsed: String {
        transaction.gasUsed
    }
    var nonce: String {
        transaction.nonce
    }
    var date: Date {
        transaction.date
    }
    var state: TransactionState {
        transaction.state
    }
    var server: RPCServer {
        transaction.server
    }

    var operation: LocalizedOperationObjectInstance? {
        switch self {
        case .standalone(let transaction):
            return transaction.operation
        case .group:
            return nil
        case .item(_, operation: let operation):
            return operation
        case .activity(let transaction, _):
            return transaction.operation
        }
    }
}
