//
//  DetailsViewController.swift
//  ShowGitHubRepo
//
//  Created by Алексей Усанов on 31/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Kingfisher

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var ibInfo: UILabel!
    @IBOutlet weak var ibLanguage: UILabel!
    @IBOutlet weak var ibGitClone: UIButton!
    @IBOutlet weak var ibUpdate: UILabel!
    @IBOutlet weak var ibCreate: UILabel!
    @IBOutlet weak var ibDescription: UITextView!
    @IBOutlet weak var ibFork: UILabel!
    @IBOutlet weak var ibOwnerAvatar: UIImageView!
    @IBOutlet weak var ibOwnerName: UILabel!
    @IBOutlet weak var ibRepoName: UILabel!
    @IBOutlet weak var ibWatch: UILabel!
    @IBOutlet weak var ibStar: UILabel!
    @IBOutlet weak var ibLicense: UILabel!
    
    var full_name = String()
    
    //   private var detail = RepoDetail(avatar_url: "", login: "", name: "", stargazers_count: "", watchers_count: "", forks: "", description: "", created_at: "", updated_at: "", clone_url: "", language: "", spdx_id: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getDetails()
    }
    
    @IBAction func clone(_ sender: UIButton) {
        UIPasteboard.general.string = sender.title(for: .normal)
        let alert = UIAlertController(title: "Copy to clipboard", message: "URL copied to clipboard!", preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func getDetails() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request("\(App.Network.repoDetails)\(self.full_name)").responseJSON { (response) in
            switch response.result {
            case .failure(let error):
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let back = UIAlertAction(title: "Back", style: .cancel, handler: { (action) in
                    self.navigationController?.popViewController(animated: true)
                })
                let again = UIAlertAction(title: "Refresh", style: .default, handler: { (_) in
                    self.getDetails()
                })
                alert.addAction(back)
                alert.addAction(again)
                self.present(alert, animated: true, completion: nil)
            case .success(let result):
                let res = result as! [String:Any]
                let owner = res["owner"] as! [String:Any]
                let license = res["license"] as? [String:Any]
                
                App.data.repoDetail = RepoDetail(avatar_url: owner["avatar_url"] as! String,
                                                 login: owner["login"] as! String,
                                                 name: res["name"] as! String,
                                                 stargazers_count: String(describing: res["stargazers_count"]!),
                                                 watchers_count: String(describing: res["watchers_count"]!),
                                                 forks: String(describing: res["forks"]!),
                                                 description: res["description"] as! String,
                                                 created_at: res["created_at"] as! String,
                                                 updated_at: res["updated_at"] as! String,
                                                 clone_url: res["clone_url"] as! String,
                                                 language: res["language"] as? String,
                                                 spdx_id: license!["spdx_id"] as? String)
                self.updateUI()
                MBProgressHUD.hide(for: self.view, animated: true)
                
            }
        }
    }
    
    private func updateUI() {
        let img = ImageResource(downloadURL: URL(string: App.data.repoDetail.avatar_url)!, cacheKey: App.data.repoDetail.avatar_url)
        self.ibOwnerAvatar.kf.setImage(with: img, placeholder: UIImage(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
        self.ibOwnerName.text = App.data.repoDetail.login
        self.ibRepoName.text = App.data.repoDetail.name
        self.ibStar.text = "Star: \(App.data.repoDetail.stargazers_count)"
        self.ibWatch.text = "Watch: \(App.data.repoDetail.watchers_count)"
        self.ibFork.text = "Fork: \(App.data.repoDetail.forks)"
        self.ibDescription.text = "\(App.data.repoDetail.description)"
        self.ibCreate.text = "Create at: \(self.dateConvert(string: "\(App.data.repoDetail.created_at)"))"
        self.ibUpdate.text = "Last update at: \(self.dateConvert(string: "\(App.data.repoDetail.updated_at)"))"
        self.ibGitClone.setTitle("\(App.data.repoDetail.clone_url)", for: .normal)
        self.ibLanguage.text = "Language: \(App.data.repoDetail.language!)"
        self.ibInfo.text = "tap to copy on clipboard"
        if App.data.repoDetail.spdx_id != nil {
            self.ibLicense.text = "License: \(App.data.repoDetail.spdx_id!)"
        } else {
            self.ibLicense.text = "License: -"
        }
    }
    
    private func dateConvert(string: String) -> String {
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: string)!
        dateFormatter.dateFormat = "dd.MM.yyyy"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
}


