//
//  CharacterTableViewCell.swift
//  marveltest
//
//  Created by Dmitriy Nikolin on 29/05/2020.
//  Copyright © 2020 dnikolin. All rights reserved.
//

import UIKit
import Kingfisher

class CharacterTableViewCell: UITableViewCell {
    
    // MARK: - Type Properties
    static let reuseIdentifier = "CharacterTableViewCell"
    static let nibName = "CharacterTableViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.kf.indicatorType = .activity
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    
    // MARK: - Configuration
    func config(with characterModel: CharacterTableViewCellModel) {
        activityIndicator.stopAnimating()
        nameLabel.text = characterModel.name
        descriptionLabel.text = characterModel.description
        avatarImageView.kf.setImage(with: characterModel.image)
    }
    func config(with characterModel: HistoryCharacterTableViewCellModel) {
        activityIndicator.stopAnimating()
        nameLabel.text = characterModel.name
        descriptionLabel.text = characterModel.description
        avatarImageView.kf.setImage(with: characterModel.image)
    }
    func configForLoading() {
        activityIndicator.startAnimating()
        nameLabel.text = ""
        descriptionLabel.text = ""
        avatarImageView.image = nil
    }
}
