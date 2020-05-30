//
//  SearchViewController.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class SearchViewController: UIViewController, Storyboardable {
    
    // MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.keyboardDismissMode = .onDrag
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UINib(nibName: CharacterTableViewCell.nibName, bundle: .main), forCellReuseIdentifier: CharacterTableViewCell.reuseIdentifier)
        }
    }
    @IBOutlet weak var noResultsLabel: UILabel!
    @IBOutlet weak var detailedImageView: UIImageView! {
        didSet {
            detailedImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet weak var detailedNameLabel: UILabel!
    @IBOutlet weak var detailedDescriptionLabel: UILabel!
    
    // MARK: - Properties
    var viewModel: SearchViewModel?
    let disposeBag = DisposeBag()
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupView()
    }
    
    // MARK: - Setup
    func setupView() {
        searchBar.rx.text.orEmpty.debounce(.milliseconds(450),scheduler: MainScheduler.instance).distinctUntilChanged()
            .subscribe(onNext: { [unowned self] searchString in
                self.viewModel?.searchCharacters(with: searchString)
            })
            .disposed(by: disposeBag)
        
        tableView.rx.contentOffset.subscribe { point in
            if self.tableView.isNearBottomEdge() {
                self.viewModel?.loadmore()
            }
        }.disposed(by: disposeBag)
        
        viewModel?.updateUI = { [unowned self] in
            self.tableView.reloadData()
            if self.viewModel?.numberOfRows == 0 {
                self.tableView.isHidden = true
                self.noResultsLabel.isHidden = false
            }
            else {
                self.tableView.isHidden = false
                self.noResultsLabel.isHidden = true
            }
        }
        viewModel?.showAlert = { [unowned self] message in
            let errorAlert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(errorAlert, animated: true)
        }
        viewModel?.updateDetailedView = { [unowned self] in
            
            self.detailedNameLabel.text = self.viewModel?.detailedViewName
            self.detailedDescriptionLabel.text = self.viewModel?.detailedDescription
            self.detailedImageView.kf.setImage(with: self.viewModel?.detailedCharacterImage)
        }
    }
}
// MARK: - SearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
// MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.reuseIdentifier, for: indexPath) as? CharacterTableViewCell else{
            fatalError("can't be true")
        }
        guard let viewModel = viewModel else { fatalError("can't be true") }
        
        let char = viewModel.characterForIndexPath(indexPath: indexPath)
        if char != nil {
            let cellViewModel = CharacterTableViewCellModel(character: char!)
            
            cell.config(with: cellViewModel)
        }
        else
        {
            cell.configForLoading()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { fatalError("can't be true") }
        
        viewModel.selectedTableRow(indexPath: indexPath)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
