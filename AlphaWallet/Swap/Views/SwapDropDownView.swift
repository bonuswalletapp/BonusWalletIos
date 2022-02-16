//
//  DropDownView.swift
//  AlphaWallet
//
//  Created by Mac Pro on 01/12/21.
//

import UIKit

class SwapDropDownView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: SwapViewModel!
    private var handler: ((SwapDropDownModel) -> Void)?

    class func instanceFromNib() -> SwapDropDownView {
        return UINib(nibName: "SwapDropDownView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! SwapDropDownView
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: SwapDropDownTableViewCell.cellIdentifier, bundle: nil), forCellReuseIdentifier: SwapDropDownTableViewCell.cellIdentifier)
    }
    
    func configure(viewModel: SwapViewModel, handler: ((SwapDropDownModel) -> Void)?) {
        self.viewModel = viewModel
        self.handler = handler
        tableView.reloadData()
    }

}

extension SwapDropDownView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SwapDropDownTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(model: viewModel.object(at: indexPath.row))
        return cell
    }
}

extension SwapDropDownView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 50
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let handler = handler {
            handler(viewModel.object(at: indexPath.row))
        }
    }
}
