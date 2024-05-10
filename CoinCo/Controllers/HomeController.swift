//
//  HomeController.swift
//  CoinCo
//
//  Created by Güray Gül on 3.05.2024.
//

import UIKit
import SafariServices

class HomeController: UIViewController, WelcomeViewDelegate, SortViewDelegate {
    
    // MARK: - Variables
    
    private let viewModel: HomeControllerViewModel
    private let sortOptions: [String] = ["Price", "Market Cap", "24h Volume", "Change", "Listed At"]
    private var tapGesture: UITapGestureRecognizer!
    
    private lazy var welcomeView = WelcomeView()
    private lazy var sortView = SortView()
    
    // MARK: - UI Components
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        
        searchBar.searchTextField.attributedPlaceholder =  NSAttributedString.init(string: "Search by name or symbol", attributes: [NSAttributedString.Key.foregroundColor: Theme.accentGrey])
        searchBar.searchTextField.leftView?.tintColor = .white
        
        searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .normal)
        searchBar.setImage(UIImage(systemName: "x.circle.fill"), for: .clear, state: .highlighted)
        
        searchBar.barTintColor = Theme.backgroundColor
        searchBar.searchTextField.textColor = .white
        searchBar.tintColor = .white
        
        searchBar.showsCancelButton = true
        return searchBar
    }()
    
    private let mainHeaderView = UIViewFactory()
        .build()
    
    private let emptyView = UIViewFactory()
        .backgroundColor(.clear)
        .build()
    
    private let emptyImageView = UIImageViewFactory(image: UIImage(named: "emptyViewWhite"))
        .build()
    
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
        
        setupUIConfigurations()
        setupUIConstraints()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        welcomeView.delegate = self
        sortView.delegate = self
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.isEnabled = false
        
        self.viewModel.onCoinsUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UI Setup
    
    private func setupUIConfigurations() {
        navigationItem.title = "CoinCo"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.hideHairline()
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.largeTitleTextAttributes = [.foregroundColor: Theme.accentWhite]
        appearance.backgroundColor = Theme.headerColor
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
        searchBar.showsCancelButton = false
        
        tableView.separatorStyle = .none
        
        emptyView.isHidden = true
    }
    
    private func setupUIConstraints() {
        view.addSubview(tableView)
        
        emptyView.addSubview(emptyImageView)
        tableView.tableHeaderView = mainHeaderView
        tableView.backgroundView = emptyView
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        mainHeaderView.addSubview(welcomeView)
        mainHeaderView.addSubview(sortView)
        mainHeaderView.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            mainHeaderView.topAnchor.constraint(equalTo: tableView.topAnchor),
            mainHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainHeaderView.heightAnchor.constraint(equalToConstant: 260),
            
            emptyView.topAnchor.constraint(equalTo: mainHeaderView.bottomAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyImageView.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor),
            emptyImageView.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor),
            emptyImageView.leadingAnchor.constraint(equalTo: emptyView.leadingAnchor, constant: 8),
            emptyImageView.trailingAnchor.constraint(equalTo: emptyView.trailingAnchor, constant: 8)
        ])
        
        welcomeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            welcomeView.topAnchor.constraint(equalTo: mainHeaderView.topAnchor),
            welcomeView.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor),
            welcomeView.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor),
            welcomeView.heightAnchor.constraint(equalToConstant: 170)
        ])
        
        sortView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            sortView.topAnchor.constraint(equalTo: welcomeView.bottomAnchor, constant: -32),
            sortView.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor),
            sortView.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor),
            sortView.bottomAnchor.constraint(equalTo: mainHeaderView.bottomAnchor)
        ])
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: mainHeaderView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: mainHeaderView.trailingAnchor, constant: -8),
            searchBar.bottomAnchor.constraint(equalTo: mainHeaderView.bottomAnchor)
        ])
    }
}

// MARK: - TableView Functions

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.coinsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as? CoinCell else {
            fatalError("Unable to dequeue CoinCell in HomeController")
        }
        
        if let coin = viewModel.coin(at: indexPath.row) {
            cell.configure(with: coin)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let coin = viewModel.coin(at: indexPath.row) {
            let vm = DetailControllerViewModel(coin: coin)
            let vc = DetailController(viewModel: vm)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    internal func showSortOptions() { // Show the dropdown menu when the sort button is tapped
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
    
    internal func sortTableViewBy(option: String) {
        viewModel.sortCoinsBy(option: option)
        tableView.reloadData()
    }
    
    internal func openSafari() {
        if let url = URL(string: "https://tr.tradingview.com") {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }
    
}
extension HomeController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        tapGesture.isEnabled = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        tapGesture.isEnabled = false
    }
    
    internal func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = nil
        
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
        searchBar.resignFirstResponder()
        
        viewModel.resetFilteredCoins()
        tableView.reloadData()
        emptyView.isHidden = viewModel.numberOfFilteredCoins() > 0
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCoins(with: searchText)
        tableView.reloadData()
        emptyView.isHidden = viewModel.numberOfFilteredCoins() > 0
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
}

extension HomeController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        viewModel.filterCoins(with: searchText)
        tableView.reloadData()
        emptyView.isHidden = viewModel.numberOfFilteredCoins() > 0
    }
}

#Preview {
    let navC = UINavigationController(rootViewController: HomeController())
    return navC
}
