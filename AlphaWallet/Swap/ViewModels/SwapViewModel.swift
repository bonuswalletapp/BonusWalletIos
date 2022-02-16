//
//  SwapViewModel.swift
//  AlphaWallet
//
//  Created by Mac Pro on 01/12/21.
//

import UIKit

struct SwapViewModel {
    
    private let data: [SwapDropDownModel] = [SwapDropDownModel(title: "WJXN", image: R.image.dummy1()), SwapDropDownModel(title: "J-USD", image: R.image.dummy2()), SwapDropDownModel(title: "J-INR", image: R.image.dummy3())]

    var backgroundColor: UIColor {
        Colors.appBackground
    }

    var navigationTitle: String {
        R.string.localizable.browserTabbarItemTitle()
    }
    
    func numberOfRows() -> Int {
        return data.count
    }
    
    func object(at index: Int) -> SwapDropDownModel {
        return data[index]
    }
    
    func dropDownHeight() -> CGFloat {
        return CGFloat(data.count * 44)
    }
    
    func swapButtonTitle(isSwap: Bool) -> String {
        return isSwap ? R.string.localizable.browserTabbarItemTitle() :  R.string.localizable.browserButtonSwapIntialTitle()
    }
    
}

struct SwapDropDownModel {
    let title: String
    let image: UIImage?
    
    init(title: String, image: UIImage?) {
        self.title = title
        self.image = image
    }
}
