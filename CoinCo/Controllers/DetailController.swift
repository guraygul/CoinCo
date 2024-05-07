//
//  DetailController.swift
//  CoinCo
//
//  Created by Güray Gül on 4.05.2024.
//

import UIKit

class DetailController: UIViewController {
    
    // MARK: - Variables
    private let viewModel: DetailControllerViewModel
    
    // MARK: - UI Components
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        return sv
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let coinLogo: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "questionmark")
        iv.tintColor = .label
        return iv
    }()
    
    private let rankLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 32, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let currentPrice: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.text = "Current Price"
        return label
    }()
    
    private let marketCapLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.text = "Error"
        return label
    }()
    
    private let maxSupplyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    private let changeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let coinChangeLabel = UILabelFactory(text: "Error")
        .fontSize(of: 16)
        .textColor(with: Theme.accentGrey)
        .build()
    
    private lazy var vStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [lineChartView, rankLabel, marketCapLabel, maxSupplyLabel])
        vStack.axis = .vertical
        vStack.spacing = 12
        vStack.distribution = .fill
        vStack.alignment = .center
        return vStack
    }()
    
    private lazy var headerSubHStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [changeImageView, coinChangeLabel])
        vStack.axis = .horizontal
        vStack.spacing = 4
        vStack.distribution = .fill
        vStack.alignment = .center
        return vStack
    }()
    
    private lazy var headerVStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [currentPrice, priceLabel, headerSubHStack])
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .leading
        return vStack
    }()
    
    private lazy var headerHStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [headerVStack, coinLogo])
        hStack.axis = .horizontal
        hStack.spacing = 16
        hStack.distribution = .fill
        hStack.alignment = .center
        return hStack
    }()
    
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
            
            // Draw horizontal lines
            let numberOfLines = 5
            let lineSpacing = rect.height / CGFloat(numberOfLines + 1)
            let linePath = UIBezierPath()
            
            for i in 1...numberOfLines {
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
        chartView.layer.borderColor = Theme.accentGrey.cgColor // Set border color
        chartView.layer.borderWidth = 0.3 // Set border width
        return chartView
    }()
    
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
        setupUI()
        
        rankLabel.text = String(describing: viewModel.coin.rank)
        priceLabel.text = viewModel.coin.price
        marketCapLabel.text = viewModel.coin.marketCap
        maxSupplyLabel.text = viewModel.coin.the24HVolume
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
    
    private func setupUI() {
        
        view.addSubview(scrollView)
        view.backgroundColor = Theme.backgroundColor
        
        navigationItem.title = "\(viewModel.coin.name ?? "N/A") (\(viewModel.coin.symbol ?? "N/A"))"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.backgroundColor = Theme.backgroundColor
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        scrollView.addSubview(contentView)
        scrollView.backgroundColor = Theme.backgroundColor
        
        contentView.addSubview(changeImageView)
        contentView.addSubview(headerHStack)
        contentView.addSubview(vStack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        vStack.translatesAutoresizingMaskIntoConstraints = false
        headerHStack.translatesAutoresizingMaskIntoConstraints = false
        changeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = UILayoutPriority(1)
        height.isActive = true
        
        // TODO: Create a Draw function in DetailControllerView.swift
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            
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
            lineChartView.heightAnchor.constraint(equalToConstant: 400)
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
