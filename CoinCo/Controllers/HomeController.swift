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
    
    // MARK: - UI Components
    
    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let trendingLabel = UILabelFactory(text: "Trending")
        .fontSize(of: 24)
        .textColor(with: Theme.accentWhite)
        .build()
    
    private let tableViewContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = Theme.backgroundColor
        tv.layer.masksToBounds = true
        tv.layer.cornerRadius = 30
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
    
    // MARK: - UI Setup
    
    private func setupUI() {
        navigationItem.title = "CoinCo"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = Theme.headerColor
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.backgroundColor = Theme.headerColor
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        tableViewContainer.layer.cornerRadius = 20
        tableViewContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableViewContainer.backgroundColor = navigationController?.navigationBar.barTintColor
        
        tableViewContainer.addSubview(tableView)
        view.addSubview(tableViewContainer)
        tableView.tableHeaderView = headerView
        headerView.addSubview(trendingLabel)
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        tableViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            trendingLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 16),
            trendingLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16)
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
}

#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
