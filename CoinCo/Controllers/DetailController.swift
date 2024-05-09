//
//  DetailController.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit
import SafariServices

class DetailController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: DetailControllerViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let contentView = UIViewFactory()
        .build()
    
    private let coinLogo = UIImageViewFactory(image: UIImage(systemName: "questionmark"))
        .contentMode(.scaleAspectFit)
        .build()
    
    private let priceLabel = UILabelFactory(text: "Error")
        .textColor(with: .white)
        .fontSize(of: 32, weight: .bold)
        .build()
    
    private let currentPriceLabel = UILabelFactory(text: "Current Price")
        .textColor(with: .white)
        .fontSize(of: 16, weight: .light)
        .build()
    
    private let changeImageView = UIImageViewFactory()
        .build()
    
    private let coinChangeLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .semibold)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let learnMoreLabel = UILabelFactory(text: "Learn More")
        .fontSize(of: 20, weight: .bold)
        .textColor(with: Theme.graphLineColor)
        .build()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(openWithSafari(_:)), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 40, bottom: 16, trailing: 40)
        button.configuration = configuration
        
        return button
    }()
    
    @objc func openWithSafari(_ sender: UIButton) {
        openWithSafari(urlString: viewModel.coin.coinrankingURL)
    }
    
    private lazy var vStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(lineChartView)
        .addArrangedSubview(learnMoreButton)
        .spacing(64)
        .distribution(.fill)
        .alignment(.center)
        .build()
    
    private lazy var headerSubHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(changeImageView)
        .addArrangedSubview(coinChangeLabel)
        .spacing(4)
        .alignment(.center)
        .build()
    
    private lazy var headerVStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(currentPriceLabel)
        .addArrangedSubview(priceLabel)
        .addArrangedSubview(headerSubHStack)
        .alignment(.leading)
        .build()
    
    private lazy var headerHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(headerVStack)
        .addArrangedSubview(coinLogo)
        .spacing(16)
        .alignment(.center)
        .build()
    
    class LineChartView: UIView {
        var dataPoints: [Double] = [] {
            didSet {
                setNeedsDisplay()
            }
        }
        
        //            -Sparkline Graph-
        override func draw(_ rect: CGRect) {
            super.draw(rect)
            
            guard !dataPoints.isEmpty else { return }
            
            let maxValue = (dataPoints.max() ?? 0.0) * 1.01
            let minValue = (dataPoints.min() ?? 0.0) / 1.01 // Get the minimum value
            let range = maxValue - minValue
            
            let numberOfLines = 5 // Change to accommodate 5 lines + upper and lower bounds
            let lineSpacing = rect.height / CGFloat(numberOfLines - 1) // Subtract 1 to account for upper bound
            let linePath = UIBezierPath()
            
            for i in 0..<numberOfLines {
                let y = lineSpacing * CGFloat(i)
                linePath.move(to: CGPoint(x: 0, y: y))
                linePath.addLine(to: CGPoint(x: rect.width, y: y))
            }
            
            Theme.accentGrey.setStroke()
            linePath.lineWidth = 0.3
            linePath.stroke()
            
            // Draw graph lines
            let path = UIBezierPath()
            path.lineWidth = 5.0
            Theme.graphLineColor.setStroke()
            
            for (index, value) in dataPoints.enumerated() {
                let x = CGFloat(index) * (rect.width / CGFloat(dataPoints.count - 1))
                let y = rect.height - CGFloat((value - minValue) / range) * rect.height
                if index == 0 {
                    path.move(to: CGPoint(x: x, y: y))
                } else {
                    path.addLine(to: CGPoint(x: x, y: y))
                }
            }
            
            path.stroke()
        }
        
    }
    
    private lazy var lineChartView: LineChartView = {
        let chartView = LineChartView()
        chartView.backgroundColor = .clear
        return chartView
    }()
    
    @objc func openWithSafari(urlString: String?) {
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
        
        priceLabel.text = viewModel.coin.price
        coinChangeLabel.text = viewModel.coin.change
        
        guard var urlString = viewModel.coin.iconURL else { return }
        
        if let sparkline = viewModel.coin.sparkline {
            let values = sparkline.compactMap { Double($0) }
            lineChartView.dataPoints = values
        }
        
        // TODO: Create a Helper for image
        
        if urlString.contains("svg") {
            urlString = urlString.replacingOccurrences(of: "svg", with: "png")
        }
        let url = URL(string: urlString)
        self.coinLogo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"), context: nil)
        
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let priceString = viewModel.coin.price, let price = Double(priceString) else {
            self.priceLabel.text = "$N/A"
            return
        }
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            self.priceLabel.text = formattedPrice
        } else {
            self.priceLabel.text = "$N/A"
        }
        
        // MARK: - Coin change images
        
        if let change = viewModel.coin.change, let changeDouble = Double(change) {
            let absChange = abs(changeDouble)
            if changeDouble > 0 {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.up")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            } else if changeDouble < 0 {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            } else {
                self.coinChangeLabel.text = "\(absChange)%"
                self.changeImageView.image = UIImage(systemName: "chevron.up.chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                self.changeImageView.image = nil
            }
        } else {
            self.coinChangeLabel.text = "N/A"
            self.coinChangeLabel.textColor = .black
            self.changeImageView.image = nil
        }
        
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
        
        scrollView.backgroundColor = Theme.backgroundColor
    }
    
    private func setupUIConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        contentView.addSubview(changeImageView)
        contentView.addSubview(headerHStack)
        contentView.addSubview(vStack)
        
        learnMoreButton.addSubview(learnMoreLabel)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            headerHStack.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            headerHStack.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
            headerHStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16),
            headerHStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            headerHStack.heightAnchor.constraint(equalToConstant: 80),
            
            coinLogo.widthAnchor.constraint(equalTo: headerHStack.heightAnchor),
            
            vStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: headerHStack.bottomAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            lineChartView.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lineChartView.heightAnchor.constraint(equalToConstant: 300),
            
            learnMoreButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 64),
            learnMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            learnMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            learnMoreLabel.centerXAnchor.constraint(equalTo: learnMoreButton.centerXAnchor),
            learnMoreLabel.centerYAnchor.constraint(equalTo: learnMoreButton.centerYAnchor)
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
