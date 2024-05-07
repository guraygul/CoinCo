//
//  HomeController.swift
//  CoinCo
//
//  Created by Güray Gül on 3.05.2024.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Variables
    
    private let viewModel: HomeControllerViewModel
    private let sortOptions: [String] = ["Price", "Market Cap", "24h Volume", "Change", "Listed At"]
    
    // MARK: - UI Components
    
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    // TODO: Add a search bar
    
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
    
    private let tableViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Theme.backgroundColor
        tv.layer.cornerRadius = 20
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
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // TODO: Solve this little bug about navBar Title
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        view.backgroundColor = Theme.headerColor
        
        //tableViewContainer.backgroundColor = navigationController?.navigationBar.barTintColor
    
        headerView.addSubview(rankingListLabel)
        headerView.addSubview(sortButton)
        tableView.tableHeaderView = headerView
        tableViewContainer.addSubview(tableView)
        view.addSubview(tableViewContainer)
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        rankingListLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableViewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            
            headerView.topAnchor.constraint(equalTo: tableView.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: tableView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 70),
            
            rankingListLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            rankingListLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 24),
            
            sortButton.leadingAnchor.constraint(equalTo: rankingListLabel.trailingAnchor, constant: 122),
            sortButton.centerYAnchor.constraint(equalTo: rankingListLabel.centerYAnchor)
        ])
    }
}

// MARK: - TableView Functions

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        
        let coin = self.viewModel.coins[indexPath.row]
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
    
    // Sort the table view data based on the selected option
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
    
    
}


#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
