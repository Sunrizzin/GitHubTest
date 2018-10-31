//
//  RepoTableViewCell.swift
//  ShowGitHubRepo
//
//  Created by Алексей Усанов on 30/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var ownerName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
