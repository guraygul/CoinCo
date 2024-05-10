//
//  ScrollView.swift
//  CoinCo
//
//  Created by Güray Gül on 9.05.2024.
//

import UIKit

protocol ScrollViewDelegate: AnyObject {
    func openDetailWithSafari()
}

final class ScrollView: UIScrollView {
    
    private let viewModel: DetailControllerViewModel
    weak var customDelegate: ScrollViewDelegate?
    
    init(frame: CGRect = .zero, viewModel: DetailControllerViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupConstraints()
        setupFormatting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        button.addTarget(self, action: #selector(openDetailWithSafari), for: .touchUpInside)
        
        var configuration = UIButton.Configuration.plain()
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 40, bottom: 16, trailing: 40)
        button.configuration = configuration
        
        return button
    }()
    
    private let marketCapLabel = UILabelFactory(text: "Market Cap:")
        .fontSize(of: 16, weight: .regular)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let marketCapPriceLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .bold)
        .textColor(with: .white)
        .textAlignment(.right)
        .build()
    
    private let rankLabel = UILabelFactory(text: "Coin Rank:")
        .fontSize(of: 16, weight: .regular)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let rankNumberLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .bold)
        .textColor(with: .white)
        .textAlignment(.right)
        .build()
    
    private let volumeLabel = UILabelFactory(text: "24 Hour Volume:")
        .fontSize(of: 16, weight: .regular)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let volumeNumberLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .semibold)
        .textColor(with: .white)
        .textAlignment(.right)
        .build()
    
    private let btcPriceLabel = UILabelFactory(text: "Price to BTC:")
        .fontSize(of: 16, weight: .regular)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private let btcPriceMumberLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16, weight: .semibold)
        .textColor(with: .white)
        .textAlignment(.right)
        .build()
    
    private lazy var marketCapHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(marketCapLabel)
        .addArrangedSubview(marketCapPriceLabel)
        .alignment(.center)
        .distribution(.fill)
        .build()
    
    private lazy var rankHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(rankLabel)
        .addArrangedSubview(rankNumberLabel)
        .alignment(.center)
        .distribution(.fill)
        .build()
    
    private lazy var volumeHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(volumeLabel)
        .addArrangedSubview(volumeNumberLabel)
        .alignment(.center)
        .distribution(.fill)
        .build()
    
    private lazy var btcHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(btcPriceLabel)
        .addArrangedSubview(btcPriceMumberLabel)
        .alignment(.center)
        .distribution(.fill)
        .build()
    
    private lazy var vStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(lineChartView)
        .addArrangedSubview(marketCapHStack)
        .addArrangedSubview(rankHStack)
        .addArrangedSubview(volumeHStack)
        .addArrangedSubview(btcHStack)
        .addArrangedSubview(learnMoreButton)
        .spacing(16)
        .alignment(.fill)
        .build()
    
    private lazy var headerSubHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(changeImageView)
        .addArrangedSubview(coinChangeLabel)
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
    
    private class LineChartView: UIView {
        var dataPoints: [Double] = [] {
            didSet {
                setNeedsDisplay()
            }
        }
        
        override func draw(_ rect: CGRect) { // Sparkline Graph
            super.draw(rect)
            
            guard !dataPoints.isEmpty else { return }
            
            let maxValue = (dataPoints.max() ?? 0.0) * 1.01
            let minValue = (dataPoints.min() ?? 0.0) / 1.01
            let range = maxValue - minValue
            
            let numberOfLines = 5
            let lineSpacing = rect.height / CGFloat(numberOfLines - 1)
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
    
    @objc func openDetailWithSafari() {
        customDelegate?.openDetailWithSafari()
    }
    
    private func setupFormatting() {
        priceLabel.text = viewModel.coin.price
        coinChangeLabel.text = viewModel.coin.change
        
        rankNumberLabel.text = String(viewModel.coin.rank ?? 0)
        
        if let sparkline = viewModel.coin.sparkline {
            let values = sparkline.compactMap { Double($0) }
            lineChartView.dataPoints = values
        }
        
        guard var urlString = viewModel.coin.iconURL else { return }
        
        if urlString.contains("svg") {
            urlString = urlString.replacingOccurrences(of: "svg", with: "png")
        }
        let url = URL(string: urlString)
        coinLogo.sd_setImage(with: url, placeholderImage: UIImage(systemName: "questionmark"), context: nil)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        guard let priceString = viewModel.coin.price, let price = Double(priceString) else {
            priceLabel.text = "$N/A"
            return
        }
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            priceLabel.text = formattedPrice
        } else {
            priceLabel.text = "$N/A"
        }
        
        guard let marketCapString = viewModel.coin.marketCap, let marketCapPrice = Double(marketCapString) else {
            marketCapPriceLabel.text = "$N/A"
            return
        }
        
        let formattedMarketCap = formatNumber(marketCapPrice)
        marketCapPriceLabel.text = formattedMarketCap
        
        guard let volumeString = viewModel.coin.the24HVolume, let volumePrice = Double(volumeString) else {
            volumeNumberLabel.text = "$N/A"
            return
        }
        
        let formattedVolume = formatNumber(volumePrice)
        volumeNumberLabel.text = formattedVolume
        
        func formatNumber(_ number: Double) -> String {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.maximumFractionDigits = 3
            formatter.decimalSeparator = "."
            
            let trillion = 1_000_000_000_000.0
            let billion = 1_000_000_000.0
            let million = 1_000_000.0
            
            if number >= trillion {
                let formattedNumber = number / trillion
                return formatter.string(from: NSNumber(value: formattedNumber))! + " Trillion"
            } else if number >= billion {
                let formattedNumber = number / billion
                return formatter.string(from: NSNumber(value: formattedNumber))! + " Billion"
            } else if number >= million {
                let formattedNumber = number / million
                return formatter.string(from: NSNumber(value: formattedNumber))! + " Million"
            } else {
                return formatter.string(from: NSNumber(value: number))!
            }
        }
        
        if let btcPriceString = viewModel.coin.btcPrice {
            let btcPrice = scientificToDouble(btcPriceString)
            let formattedString: String
            if btcPrice == 1 {
                formattedString = String(format: "%.0f BTC", btcPrice)
            } else {
                let formatter = NumberFormatter()
                formatter.numberStyle = .decimal
                formatter.maximumFractionDigits = 10
                
                formattedString = (formatter.string(from: NSNumber(value: btcPrice)) ?? "0") + " BTC"
            }
            btcPriceMumberLabel.text = formattedString
        } else {
            btcPriceMumberLabel.text = "0 BTC"
        }
        
        func scientificToDouble(_ scientificNumber: String) -> Double {
            if let doubleValue = Double(scientificNumber) {
                return doubleValue
            }
            return 0.0
        }
        
        // MARK: - Coin change images
        
        if let change = viewModel.coin.change, let changeDouble = Double(change) {
            let absChange = abs(changeDouble)
            if changeDouble > 0 {
                coinChangeLabel.text = "\(absChange)%"
                changeImageView.image = UIImage(systemName: "chevron.up")?.withTintColor(.green, renderingMode: .alwaysOriginal)
            } else if changeDouble < 0 {
                coinChangeLabel.text = "\(absChange)%"
                changeImageView.image = UIImage(systemName: "chevron.down")?.withTintColor(.red, renderingMode: .alwaysOriginal)
            } else {
                coinChangeLabel.text = "\(absChange)%"
                changeImageView.image = UIImage(systemName: "chevron.up.chevron.down")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
                changeImageView.image = nil
            }
        } else {
            coinChangeLabel.text = "N/A"
            coinChangeLabel.textColor = .black
            changeImageView.image = nil
        }
    }
    
    private func setupConstraints() {
        super.layoutSubviews()
        
        backgroundColor = Theme.backgroundColor
        
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor)
        ])
        
        contentView.addSubview(changeImageView)
        contentView.addSubview(headerHStack)
        
        NSLayoutConstraint.activate([
            headerHStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            headerHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            headerHStack.heightAnchor.constraint(equalToConstant: 80),
            
            coinLogo.widthAnchor.constraint(equalTo: headerHStack.heightAnchor)
        ])
        
        contentView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            vStack.topAnchor.constraint(equalTo: headerHStack.bottomAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            lineChartView.topAnchor.constraint(equalTo: vStack.topAnchor, constant: 20),
            lineChartView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            lineChartView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            lineChartView.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        learnMoreButton.addSubview(learnMoreLabel)
        
        learnMoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //            learnMoreButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 120),
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
                    marketCap: "1064845170034",
                    price: "56373.67522635439",
                    listedAt: 1330214400,
                    tier: 1,
                    change: "-3.61",
                    rank: 1,
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
                    coinrankingURL: "https://coinranking.com/coin/Qwsogvtv82FCd+bitcoin-btc",
                    the24HVolume: "39591261551",
                    btcPrice: "7.51874139e-10"
                )
            )
        )
    )
    return navC
}
