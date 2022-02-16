//
//  SwapViewController.swift
//  AlphaWallet
//
//  Created by Mac Pro on 01/12/21.
//

import UIKit

class SwapViewController: UIViewController {

    @IBOutlet weak var toView: UIView!
    @IBOutlet weak var exchangeView: UIView!
    @IBOutlet weak var exchangeFromCurrencyImageVIew: UIImageView!
    @IBOutlet weak var exchangeFromBalanceLabel: UILabel!
    @IBOutlet weak var exchangeFromCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeFromCurrencyTextField: UITextField!
    @IBOutlet weak var exchangeToCurrencyImageVIew: UIImageView!
    @IBOutlet weak var exchangeToCurrencyLabel: UILabel!
    @IBOutlet weak var exchangeToCurrencyTextField: UITextField!
    @IBOutlet weak var exchangeToBalanceLabel: UILabel!

    @IBOutlet weak var currencyConversionView: UIView!
    @IBOutlet weak var currencyConversionLabel: UILabel!

    @IBOutlet weak var swapButton: UIButton!
    
    @IBOutlet weak var exchangeFromDropDownButton: UIButton!
    @IBOutlet weak var exchangeToDropDownButton: UIButton!
    @IBOutlet weak var enterAmountButton: UIButton!
    
    private let viewModel = SwapViewModel()
    private var dropDownView: SwapDropDownView?
    var fromCurrencyItem: SwapDropDownModel?
    var toCurrencyItem: SwapDropDownModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = viewModel.backgroundColor
        self.title = viewModel.navigationTitle
        currencyConversionView.isHidden = true
        fromCurrencyItem = viewModel.object(at: 0)
        toCurrencyItem = viewModel.object(at: 1)
        exchangeFromCurrencyTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        exchangeToCurrencyTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        configureUI()
    }
    
    @IBAction func swapButtonAction(_ sender: Any) {
        let swapModel = fromCurrencyItem
        fromCurrencyItem = toCurrencyItem
        toCurrencyItem = swapModel
        
        let fromValue = exchangeFromCurrencyTextField.text
        exchangeFromCurrencyTextField.text = exchangeToCurrencyTextField.text
        exchangeToCurrencyTextField.text = fromValue
        configureUI()
    }
    
    @objc func textDidChange(_ sender: UITextField) {
        self.configureUI()
    }
    
    @IBAction func exchangeFromDropDownButtonAction(_ sender: UIButton) {
        let dropDown = createDropDown(button: sender, view: exchangeView)
        self.dropDownView = dropDown
        dropDown.configure(viewModel: viewModel) { [weak self] (item) in
            guard let self = self else { return }
            self.fromCurrencyItem = item
            self.configureUI()
        }
        view.addSubview(dropDown)
    }
    
    @IBAction func exchangeToDropDownButtonAction(_ sender: UIButton) {
        let dropDown = createDropDown(button: sender, view: toView)
        self.dropDownView = dropDown
        dropDown.configure(viewModel: viewModel) { [weak self] (item) in
            guard let self = self else { return }
            self.toCurrencyItem = item
            self.configureUI()
        }
        view.addSubview(dropDown)
    }
    
    private func createDropDown(button: UIButton, view: UIView) -> SwapDropDownView {
        removeDropDrowView()
        let dropDown = SwapDropDownView.instanceFromNib()
        let xPosition = view.frame.origin.x + button.frame.origin.x
        let yPosition = view.frame.origin.y + button.frame.origin.y + button.frame.size.height
        let width = button.frame.size.width
        dropDown.frame = CGRect(x: xPosition, y: yPosition, width: width, height: viewModel.dropDownHeight())
        dropDown.cornerRadius = 8
        dropDown.borderWidth = 2
        dropDown.borderColor = Colors.headerThemeColor
        return dropDown
    }

    func removeDropDrowView() {
        dropDownView?.removeFromSuperview()
    }
    
    @IBAction func enterAmountButtonAction(_ sender: Any) {
        removeDropDrowView()
        if isSwapButon() {
            let controller = ConfirmSwapViewController(nibName: "ConfirmSwapViewController", bundle: nil)
            controller.modalPresentationStyle = .overCurrentContext
            controller.fromCurrencyItem = fromCurrencyItem
            controller.toCurrencyItem = toCurrencyItem
            controller.fromValue = exchangeFromCurrencyTextField.text
            controller.toValue = exchangeToCurrencyTextField.text
            controller.delegate = self
            controller.modalTransitionStyle = .crossDissolve
            tabBarController?.present(controller, animated: true, completion: nil)
        }
    }
    
    func configureUI() {
        if let item = fromCurrencyItem {
            self.exchangeFromCurrencyLabel.text = item.title
            self.exchangeFromCurrencyImageVIew.image = item.image
        }
        
        if let item = toCurrencyItem {
            self.exchangeToCurrencyLabel.text = item.title
            self.exchangeToCurrencyImageVIew.image = item.image
        }
        currencyConversionView.isHidden = true
        if let from = exchangeFromCurrencyLabel.text, let to = exchangeToCurrencyLabel.text, let fromValue = exchangeFromCurrencyTextField.text, let toValue = exchangeToCurrencyTextField.text, !from.isEmpty, !to.isEmpty, !fromValue.isEmpty, !toValue.isEmpty {
            currencyConversionView.isHidden = false
            if fromCurrencyItem?.title == toCurrencyItem?.title {
                currencyConversionLabel.text = "\(fromValue) \(from) - \(fromValue) \(to)"
            } else {
                currencyConversionLabel.text = "\(fromValue) \(from) - \(toValue) \(to)"
            }
        }
        self.removeDropDrowView()
        self.isSwapButon()
    }
    
    @discardableResult
    private func isSwapButon() -> Bool {
        if fromCurrencyItem != nil && toCurrencyItem != nil {
            enterAmountButton.setTitle(viewModel.swapButtonTitle(isSwap: true), for: .normal)
            return true
        }
        enterAmountButton.setTitle(viewModel.swapButtonTitle(isSwap: false), for: .normal)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeDropDrowView()
    }
    
}

extension SwapViewController: ConfirmSwapDelegate {
    func confirm(fromCurrency: SwapDropDownModel, toCurrency: SwapDropDownModel) {
        let controller = WaitSwapConfirmationViewController(nibName: "WaitSwapConfirmationViewController", bundle: nil)
        controller.modalPresentationStyle = .overCurrentContext
        controller.fromCurrencyItem = fromCurrency
        controller.toCurrencyItem = toCurrency
        controller.modalTransitionStyle = .crossDissolve
        tabBarController?.present(controller, animated: true, completion: nil)
    }
}
