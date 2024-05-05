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
    
    private let trendingLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .blue
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
        self.navigationItem.title = "CoinCo"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.view.backgroundColor = .systemBackground
        
        tableView.tableHeaderView = headerView
        headerView.addSubview(trendingLabel)
        
        self.view.addSubview(tableView)
        
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        trendingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
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
