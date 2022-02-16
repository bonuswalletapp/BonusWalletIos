//
//  WaitSwapConfirmationViewController.swift
//  AlphaWallet
//
//  Created by Mac Pro on 02/12/21.
//

import UIKit

class WaitSwapConfirmationViewController: UIViewController {
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var headingTitleLabel: UILabel!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    
    @IBOutlet weak var safeAreaView: UIView!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var conversionLabel: UILabel!
    @IBOutlet weak var indicatorImageView: UIImageView!
    
    var fromCurrencyItem: SwapDropDownModel?
    var toCurrencyItem: SwapDropDownModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    func configureUI() {
        if let fromCurrencyItem = fromCurrencyItem, let toCurrencyItem = toCurrencyItem {
            conversionLabel.text = " Swapping 0.00001 \(fromCurrencyItem.title) for 0.000001 \(toCurrencyItem.title)"
        }
        if let url = Bundle.main.url(forResource: "loading", withExtension: "gif"), let data = try? Data(contentsOf: url) {
            let loadingGif = UIImage.gifImageWithData(data)
            indicatorImageView.image = loadingGif
        }
    }
    @IBAction func closeButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
