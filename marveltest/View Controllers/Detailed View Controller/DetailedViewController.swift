//
//  DetailedViewController.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 27/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController, Storyboardable {
    
    // MARK: - Outlets
    
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet weak var desctionTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    var viewModel : DetailedViewViewModel?
    
    
    // MARK: - View
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        guard let viewModel = viewModel else {return}
        
        nameLabel.text = viewModel.name
        desctionTextView.text = viewModel.description
        avatarImageView.kf.setImage(with: viewModel.image)
    }
    
}
