//
//  DetailController.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit
import SafariServices

class DetailController: UIViewController, ScrollViewDelegate {
    
    // MARK: - Variables
    
    private let viewModel: DetailControllerViewModel
    
    private lazy var scrollView = ScrollView(viewModel: viewModel)
    
    // MARK: - UI Components
    
    @objc func openDetailWithSafari() {
        openWithSafari(urlString: viewModel.coin.coinrankingURL)
    }
    
    private func openWithSafari(urlString: String?) {
        if let urlString = urlString, let url = URL(string: urlString) {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
    // MARK: - LifeCycle
    
    init(viewModel: DetailControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIConfigurations()
        setupUIConstraints()
        scrollView.customDelegate = self
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCoinURL))
        navigationItem.rightBarButtonItem = shareButton
    }
    
    @objc private func shareCoinURL() {
        guard let coinURLString = viewModel.coin.coinrankingURL,
              let coinURL = URL(string: coinURLString) else {
            return
        }
        
        let defaultText = "Look what I found: \(coinURL)"
        
        let activityViewController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    // MARK: - UI Setup
    
    private func setupUIConfigurations() {
        view.backgroundColor = Theme.backgroundColor
        
        navigationItem.title = "\(viewModel.coin.name ?? "N/A") (\(viewModel.coin.symbol ?? "N/A"))"
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.backgroundColor = Theme.backgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUIConstraints() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            //            scrollView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
            //            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
    }
}

#Preview {
    let navC = UINavigationController(
        rootViewController: DetailController(
            viewModel: DetailControllerViewModel(
                coin: Coin(
                    uuid: "12",
                    symbol: "BTC",
                    name: "Bitcoin",
                    color: "sd",
                    iconURL: "https://cdn.coinranking.com/bOabBYkcX/bitcoin_btc.svg",
                    marketCap: "kjh",
                    price: "56373.67522635439",
                    listedAt: 77,
                    tier: 77,
                    change: "-3.61",
                    rank: 3923,
                    sparkline: ["4715.4375223749312028370000",
                                "4722.8789864350595339700000",
                                "4693.9693025495911456560000",
                                "4678.7370398969002769900000",
                                "4637.4853844689948272420000",
                                "4620.0116032821695915870000",
                                "4569.9082933638150160750000",
                                "4548.5300541672684575480000",
                                "4564.2711526581927423000000",
                                "4571.0670361527786139490000",
                                "4560.8160722546258528110000",
                                "4590.0318275517076160800000",
                                "4550.0047792789710169440000",
                                "4485.9078343022111878520000",
                                "4502.4625939380200916270000",
                                "4522.5879153436378028530000",
                                "4521.2610722271239601980000",
                                "4557.4963905387275931140000",
                                "4578.7760383161348676970000",
                                "4570.3170096134283850390000",
                                "4554.6981689954878421810000",
                                "4519.1186938022496516710000",
                                "4515.7213415128057478380000",
                                "4511.1845370567258973840000",
                                "4533.7472619353070976610000",
                                "4557.9859723682906789340000",
                                "4517.0619083572751804960000"],
                    lowVolume: false,
                    coinrankingURL: "ds",
                    the24HVolume: "sd",
                    btcPrice: "ds"
                )
            )
        )
    )
    return navC
}
