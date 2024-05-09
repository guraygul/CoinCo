//
//  WelcomeView.swift
//  CoinCo
//
//  Created by Güray Gül on 9.05.2024.
//

import UIKit
import SafariServices

protocol WelcomeViewDelegate: AnyObject {
    func openSafari()
}

final class WelcomeView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupConstraints()
    }
    
    weak var delegate: WelcomeViewDelegate?
    
    private let welcomeLabel = UILabelFactory(text: "Welcome, Güray")
        .fontSize(of: 24, weight: .regular)
        .numberOf(lines: 0)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private lazy var learnMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Learn More", for: .normal)
        button.setTitleColor(Theme.backgroundColor, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        
        button.addTarget(self, action: #selector(openWithSafari), for: .touchUpInside)
        var configuration = UIButton.Configuration.plain()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = configuration
        
        return button
    }()
    
    private let welcomeImageView = UIImageViewFactory(image: UIImage(named: "headerImageNew"))
        .build()
    
    private lazy var welcomeVStack = UIStackViewFactory(axis: .vertical)
        .addArrangedSubview(welcomeLabel)
        .addArrangedSubview(learnMoreButton)
        .alignment(.leading)
        .build()
    
    lazy var welcomeHStack = UIStackViewFactory(axis: .horizontal)
        .addArrangedSubview(welcomeVStack)
        .addArrangedSubview(welcomeImageView)
        .alignment(.leading)
        .build()
    
    private func setupConstraints() {
        super.layoutSubviews()
        
        backgroundColor = Theme.headerColor
        
        addSubview(welcomeHStack)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            welcomeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            learnMoreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            learnMoreButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            welcomeImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            welcomeImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 48)
        ])
    }
    
    @objc func openWithSafari() {
        delegate?.openSafari()
    }
    
}

#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
