//
//  HistoryViewController.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController, Storyboardable {
    
    // MARK: - Properties
    var viewModel: HistoryViewViewModel?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: CharacterTableViewCell.nibName, bundle: .main), forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        }
    }
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    func setupView() {
        guard let viewModel = viewModel else {
            return
        }
        viewModel.updateUI = { [unowned self] in
            self.tableView.reloadData()
        }
    }
}
// MARK: - TableView Delegate
extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else{
            fatalError("can't be true")
        }
        guard let viewModel = viewModel else { fatalError("can't be true") }
        
        let cellViewModel = viewModel.cellViewModelForIndex(indexPath: indexPath)
        cell.config(with: cellViewModel)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { fatalError("can't be true") }
        
        viewModel.selectedTableRow(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
