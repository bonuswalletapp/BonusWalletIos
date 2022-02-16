//
//  ConfirmSwapViewController.swift
//  AlphaWallet
//
//  Created by Mac Pro on 02/12/21.
//

import UIKit

protocol ConfirmSwapDelegate: AnyObject {
    func confirm(fromCurrency: SwapDropDownModel, toCurrency: SwapDropDownModel)
}

class ConfirmSwapViewController: UIViewController {
    
    @IBOutlet weak var fromCurrencyTextField: UITextField!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var fromCurrencyLabel: UILabel!
    @IBOutlet weak var fromCurrencyView: UIView!
    @IBOutlet weak var fromView: UIView!
    @IBOutlet weak var fromTitleLabel: UIView!
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var transactionFeeValueTitleLabel: UILabel!
    @IBOutlet weak var transactionView: UIView!
    @IBOutlet weak var priceValueLabel: UILabel!
    @IBOutlet weak var priceTitleLabel: UILabel!
    @IBOutlet weak var swapButton: UIButton!
    @IBOutlet weak var toCurrencyTextField: UITextField!
    @IBOutlet weak var transactionFeeTitleLabel: UILabel!
    @IBOutlet weak var transactionStackView: UIStackView!
    @IBOutlet weak var toCurrencyLabel: UILabel!
    @IBOutlet weak var tpCurrencyView: UIView!
    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var toTitleLabel: UIView!
    @IBOutlet weak var headerTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var markUpFeeTitleLabel: UILabel!
    @IBOutlet weak var markFeeValueLabel: UILabel!
    @IBOutlet weak var markUpFeeTitleLabel1: UILabel!
    @IBOutlet weak var markFeeValueLabel1: UILabel!
    @IBOutlet weak var markFeeStackView1: UIStackView!
    @IBOutlet weak var markFeeStackView: UIStackView!
    
    var fromCurrencyItem: SwapDropDownModel?
    var toCurrencyItem: SwapDropDownModel?
    var fromValue: String?
    var toValue: String?
    weak var delegate: ConfirmSwapDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toCurrencyTextField.text = toValue
        fromCurrencyTextField.text = fromValue
        fromCurrencyTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        toCurrencyTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        configureUI()
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        self.configureUI()
    }
    
    func configureUI() {
        if let item = fromCurrencyItem {
            self.fromCurrencyLabel.text = item.title
        }
        
        if let item = toCurrencyItem {
            self.toCurrencyLabel.text = item.title
        }
        
        if let from = fromCurrencyLabel.text, let to = toCurrencyLabel.text, let fromValue = fromCurrencyTextField.text, let toValue = toCurrencyTextField.text, !from.isEmpty, !to.isEmpty, !fromValue.isEmpty, !toValue.isEmpty {
            if fromCurrencyItem?.title == toCurrencyItem?.title {
                priceValueLabel.text = "\(fromValue) \(from) - \(fromValue) \(to)"
            } else {
                priceValueLabel.text = "\(fromValue) \(from) - \(toValue) \(to)"
            }
        }

    }

    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func swapButtonAction(_ sender: Any) {
        let swapModel = fromCurrencyItem
        fromCurrencyItem = toCurrencyItem
        toCurrencyItem = swapModel
        
        let fValue = fromCurrencyTextField.text
        fromCurrencyTextField.text = toCurrencyTextField.text
        toCurrencyTextField.text = fValue
        
        configureUI()
    }
    
    @IBAction func confirmButtonAction(_ sender: Any) {
        self.dismiss(animated: true) { [weak self] in
            guard let self = self, let fromCurrencyItem = self.fromCurrencyItem, let toCurrencyItem = self.toCurrencyItem else { return }
            self.delegate?.confirm(fromCurrency: fromCurrencyItem, toCurrency: toCurrencyItem)
        }
    }
}
