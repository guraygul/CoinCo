//
//  HomeController.swift
//  CoinCo
//
//  Created by Güray Gül on 3.05.2024.
//

import UIKit
import SafariServices

class HomeController: UIViewController {
    
    // MARK: - Variables
    
    private let viewModel: HomeControllerViewModel
    private let sortOptions: [String] = ["Price", "Market Cap", "24h Volume", "Change", "Listed At"]
    private var filteredCoins: [Coin] = []
    
    // MARK: - UI Components
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search by name or symbol", attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        searchBar.searchTextField.leftView?.tintColor = .white
        
        searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .normal)
        searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .highlighted)
        
        searchBar.barTintColor = Theme.backgroundColor
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    
    private let mainHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let welcomeView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.headerColor
        return view
    }()
    
    private let sortView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.backgroundColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        return view
    }()
    
    private let welcomeLabel = UILabelFactory(text: "Welcome, Güray")
        .fontSize(of: 24)
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
    
    private let welcomeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var welcomeVStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [welcomeLabel, learnMoreButton])
        vStack.spacing = 8
        vStack.axis = .vertical
        vStack.distribution = .fill
        vStack.alignment = .leading
        return vStack
    }()
    
    private lazy var welcomeHStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [welcomeVStack, welcomeImageView])
        vStack.spacing = 8
        vStack.axis = .horizontal
        vStack.distribution = .fill
        vStack.alignment = .leading
        return vStack
    }()
    
    private lazy var sortHStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [rankingListLabel, sortButton])
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        hStack.spacing = 16
        hStack.alignment = .center
        return hStack
    }()
    
    private let rankingListLabel = UILabelFactory(text: "Ranking List")
        .fontSize(of: 24)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sort By", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Theme.tintColor
        button.layer.cornerRadius = 20
        
        if let downImage = UIImage(systemName: "arrow.down") {
            button.setImage(downImage, for: .normal)
            button.tintColor = .white
        }
        
        var configuration = UIButton.Configuration.plain()
        
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        button.configuration = configuration
        
        button.addTarget(self, action: #selector(showSortOptions), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortMenu: UIAlertController = {
        let alertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        for option in sortOptions {
            let action = UIAlertAction(title: option, style: .default) { [weak self] action in
                self?.sortTableViewBy(option: option)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
        return alertController
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Theme.backgroundColor
        tv.register(CoinCell.self, forCellReuseIdentifier: CoinCell.identifier)
        return tv
    }()
    
    // MARK: - LifeCycle
    
    init(viewModel: HomeControllerViewModel = HomeControllerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.showsCancelButton = false
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.filteredCoins = self.viewModel.coins
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        navigationItem.title = "CoinCo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hideHairline()
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.backgroundColor = Theme.headerColor
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        welcomeView.addSubview(welcomeHStack)
        sortView.addSubview(sortHStack)
        mainHeaderView.addSubview(welcomeView)
        mainHeaderView.addSubview(sortView)
        mainHeaderView.addSubview(searchBar)
        
        tableView.tableHeaderView = mainHeaderView
        view.addSubview(tableView)
        
        welcomeImageView.image = UIImage(named: "headerImageNew")
        
        tableView.separatorStyle = .none
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        mainHeaderView.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        rankingListLabel.translatesAutoresizingMaskIntoConstraints = false
        sortHStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeVStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeHStack.translatesAutoresizingMaskIntoConstraints = false
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        sortView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            mainHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainHeaderView.heightAnchor.constraint(equalToConstant: 260),
            
            welcomeView.topAnchor.constraint(equalTo: mainHeaderView.topAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor),
            welcomeView.heightAnchor.constraint(equalToConstant: 170),
            
            welcomeLabel.leadingAnchor.constraint(equalTo: welcomeView.leadingAnchor, constant: 16),
            welcomeLabel.topAnchor.constraint(equalTo: welcomeView.topAnchor, constant: 16),
            learnMoreButton.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 16),
            learnMoreButton.bottomAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: -72),
            
            welcomeImageView.bottomAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: 4),
            welcomeImageView.trailingAnchor.constraint(equalTo: welcomeView.trailingAnchor, constant: 48),
            
            sortView.topAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: -32),
            sortView.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor),
            sortView.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor),
            sortView.bottomAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            
            sortHStack.topAnchor.constraint(equalTo: sortView.topAnchor, constant: 16),
            sortHStack.leadingAnchor.constraint(equalTo: sortView.leadingAnchor),
            sortHStack.trailingAnchor.constraint(equalTo: sortView.trailingAnchor),
            
            rankingListLabel.leadingAnchor.constraint(equalTo: sortView.leadingAnchor, constant: 16),
            sortButton.trailingAnchor.constraint(equalTo: sortView.trailingAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: rankingListLabel.bottomAnchor, constant: 16),
            searchBar.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor, constant: 16),
            searchBar.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor, constant: -16),
            searchBar.bottomAnchor.constraint(equalTo: sortView.bottomAnchor),
        ])
    }
}

// MARK: - TableView Functions

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCoins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        
        let coin = filteredCoins[indexPath.row]
        cell.configure(with: coin)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let coin = self.viewModel.coins[indexPath.row]
        let vm = DetailControllerViewModel(coin: coin)
        let vc = DetailController(viewModel: vm)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // Show the dropdown menu when the sort button is tapped
    @objc private func showSortOptions() {
        let alertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        for option in sortOptions {
            let action = UIAlertAction(title: option, style: .default) { [weak self] action in
                self?.sortTableViewBy(option: option)
            }
            alertController.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
    
    // TODO: Add arrows for ascending sort and descend sort
    private func sortTableViewBy(option: String) {
        switch option {
        case "Price":
            viewModel.coins.sort { coin1, coin2 in
                if let price1 = coin1.price, let price2 = coin2.price {
                    return scientificToDouble(price1) > scientificToDouble(price2)
                }
                return false
            }
        case "Market Cap":
            viewModel.coins.sort { coin1, coin2 in
                if let marketCap1 = coin1.marketCap, let marketCap2 = coin2.marketCap {
                    return scientificToDouble(marketCap1) > scientificToDouble(marketCap2)
                }
                return false
            }
        case "24h Volume":
            viewModel.coins.sort { coin1, coin2 in
                if let volume1 = coin1.the24HVolume, let volume2 = coin2.the24HVolume {
                    return scientificToDouble(volume1) > scientificToDouble(volume2)
                }
                return false
            }
        case "Change":
            viewModel.coins.sort { coin1, coin2 in
                if let change1 = coin1.change, let change2 = coin2.change {
                    return scientificToDouble(change1) > scientificToDouble(change2)
                }
                return false
            }
        case "Listed At":
            viewModel.coins.sort { coin1, coin2 in
                if let listedAt1 = coin1.listedAt, let listedAt2 = coin2.listedAt {
                    return listedAt1 > listedAt2
                }
                return false
            }
        default:
            break
        }
        tableView.reloadData()
    }
    
    private func scientificToDouble(_ scientificNumber: String) -> Double {
        if let doubleValue = Double(scientificNumber) {
            return doubleValue
        }
        return 0.0 // Default value or handle error as needed
    }
    
    @objc func openWithSafari() {
        if let url = URL(string: "https://tr.tradingview.com") {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
}
extension HomeController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterCoins(with: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = nil
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
    }
    
    private func filterCoins(with searchText: String) {
        if searchText.isEmpty {
            // If the search text is empty, show all coins
            filteredCoins = viewModel.coins
        } else {
            // Filter coins based on search text
            filteredCoins = viewModel.coins.filter { coin in
                return coin.name?.lowercased().contains(searchText.lowercased()) ?? false ||
                coin.symbol?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        tableView.reloadData()
    }
    
}

extension HomeController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterCoins(with: searchText)
    }

}



#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
