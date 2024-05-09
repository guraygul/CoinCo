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
    
    private class LineChartView: UIView {
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
    
    @objc func openDetailWithSafari() {
        customDelegate?.openDetailWithSafari()
    }
    
    private func setupFormatting() {
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
            learnMoreButton.topAnchor.constraint(equalTo: lineChartView.bottomAnchor, constant: 64),
            learnMoreButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            learnMoreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 50),
            
            learnMoreLabel.centerXAnchor.constraint(equalTo: learnMoreButton.centerXAnchor),
            learnMoreLabel.centerYAnchor.constraint(equalTo: learnMoreButton.centerYAnchor)
        ])
    }
}
