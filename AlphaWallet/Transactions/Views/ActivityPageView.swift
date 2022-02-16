//
//  ActivitiesPageView.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 12.05.2021.
//

import UIKit
import StatefulViewController

struct ActivityPageViewModel {
    var title: String {
        return R.string.localizable.tokenTabActivity()
    }

    let activitiesViewModel: ActivitiesViewModel

    init(activitiesViewModel: ActivitiesViewModel) {
        self.activitiesViewModel = activitiesViewModel
    }
}

protocol ActivitiesPageViewDelegate: class {
    func didTap(activity: Activity, in view: ActivitiesPageView)
    func didTap(transaction: TransactionInstance, in view: ActivitiesPageView)
}

class ActivitiesPageView: UIView, PageViewType {

    var title: String { viewModel.title }

    private var activitiesView: ActivitiesView
    var viewModel: ActivityPageViewModel
    weak var delegate: ActivitiesPageViewDelegate?
    var rightBarButtonItem: UIBarButtonItem?
    
    private let background = UIView()
    private let titleLabel = UILabel()
    private let apprecation24hoursView = ApprecationView()
    private let priceChangeLabel = UILabel()
    private let fiatValueLabel = UILabel()
    private let activityTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Fonts.bold(size: 14)
        label.textColor = Colors.headerThemeColor
        label.text = R.string.localizable.activityTabbarItemTitle()
        return label
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Colors.clear
        return view
    }()
    private let footerView: ButtonsBarBackgroundView?
    private let cryptoValueLabel = UILabel()
    private var viewsWithContent: [UIView] {
        [titleLabel, apprecation24hoursView, priceChangeLabel]
    }

    private lazy var changeValueContainer: UIView = [priceChangeLabel, apprecation24hoursView].asStackView(spacing: 5)

    private var tokenIconImageView: TokenImageView = {
        let imageView = TokenImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var blockChainTagLabel = BlockchainTagLabel()

    init(viewModel: ActivityPageViewModel, sessions: ServerDictionary<WalletSession>, footerBar: ButtonsBarBackgroundView?) {
        self.viewModel = viewModel
        self.footerView = footerBar
        activitiesView = ActivitiesView(viewModel: viewModel.activitiesViewModel, sessions: sessions)
        activitiesView.translatesAutoresizingMaskIntoConstraints = false

        super.init(frame: .zero)

        activitiesView.delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(background)
        containerView.addSubview(activityTitleLabel)
        let mainStackView = [containerView, activitiesView].asStackView(axis: .vertical)
        if let footerBar = footerBar {
            mainStackView.addArrangedSubview(footerBar)
        }
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        background.translatesAutoresizingMaskIntoConstraints = false
        priceChangeLabel.textAlignment = .center
        fiatValueLabel.textAlignment = .center
        fiatValueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        fiatValueLabel.setContentHuggingPriority(.required, for: .horizontal)

        let col0 = tokenIconImageView
        let row1 = [cryptoValueLabel, UIView.spacerWidth(flexible: true), changeValueContainer, blockChainTagLabel].asStackView(spacing: 5, alignment: .center)
        let col1 = [
            [titleLabel, UIView.spacerWidth(flexible: true), fiatValueLabel].asStackView(spacing: 5),
            UIView.spacer(height: 5),
            row1
        ].asStackView(axis: .vertical)
        let stackView = [col0, col1].asStackView(spacing: 12, alignment: .center)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        background.addSubview(stackView)

        NSLayoutConstraint.activate([
            tokenIconImageView.heightAnchor.constraint(equalToConstant: 40),
            tokenIconImageView.widthAnchor.constraint(equalToConstant: 40),
            row1.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            stackView.anchorsConstraint(to: background, edgeInsets: .init(top: 12, left: 20, bottom: 16, right: 12)),
            tokenIconImageView.widthAnchor.constraint(equalToConstant: 40),
            background.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 15),
            background.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            activityTitleLabel.topAnchor.constraint(equalTo: background.bottomAnchor, constant: 17),
            activityTitleLabel.leadingAnchor.constraint(equalTo: background.leadingAnchor),
            activityTitleLabel.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            activityTitleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0),
            mainStackView.anchorsConstraintSafeArea(to: self)
        ])
        configure(viewModel: viewModel)
    }

    deinit {
        activitiesView.resetStatefulStateToReleaseObjectToAvoidMemoryLeak()
    }

    required init?(coder: NSCoder) {
        return nil
    }

    func configure(viewModel: ActivityPageViewModel) {
        self.viewModel = viewModel
        activitiesView.configure(viewModel: viewModel.activitiesViewModel)
        activitiesView.applySearch(keyword: nil)
        activitiesView.endLoading()
//        containerView.isHidden = !activitiesView.hasContent()
//        self.footerView?.isHidden = !activitiesView.hasContent()
    }
    
    func configure(viewModel: TokenViewControllerViewModel) {
        background.backgroundColor = Colors.appWhite
        background.cornerRadius = 8
        background.borderWidth = 1
        background.borderColor = Colors.headerThemeColor
        background.layer.shadowOpacity = 0.6
        titleLabel.attributedText = viewModel.titleAttributedString
        titleLabel.baselineAdjustment = .alignCenters

        cryptoValueLabel.attributedText = viewModel.cryptoValueAttributedString
        cryptoValueLabel.baselineAdjustment = .alignCenters
        apprecation24hoursView.configure(viewModel: viewModel.apprecationViewModel)

        priceChangeLabel.attributedText = viewModel.priceChangeUSDValueAttributedString

        fiatValueLabel.attributedText = viewModel.fiatValueAttributedString

        viewsWithContent.forEach {
            $0.alpha = viewModel.alpha
        }
        tokenIconImageView.subscribable = viewModel.iconImage
        if let blockChainTagViewModel = viewModel.blockChainTagViewModel {
            blockChainTagLabel.configure(viewModel: blockChainTagViewModel)
            changeValueContainer.isHidden = !blockChainTagViewModel.blockChainNameLabelHidden
        }
       
    }
    
}

extension ActivitiesPageView: ActivitiesViewDelegate {

    func didPressActivity(activity: Activity, in view: ActivitiesView) {
        delegate?.didTap(activity: activity, in: self)
    }

    func didPressTransaction(transaction: TransactionInstance, in view: ActivitiesView) {
        delegate?.didTap(transaction: transaction, in: self)
    }
}
