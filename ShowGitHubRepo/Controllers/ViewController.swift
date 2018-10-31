//
//  ViewController.swift
//  ShowGitHubRepo
//
//  Created by Алексей Усанов on 30/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import Kingfisher

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var ibAllRepo: UITableView!
    var searchActive: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(tv: ibAllRepo)
        self.setupUI()
        self.getAllRepo()
    }
    
    private func setupTableView(tv: UITableView) {
        tv.tableFooterView = UIView()
    }
    
    private func setupUI() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func getAllRepo() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        Alamofire.request(App.Network.allRepo).responseJSON { (response)
            in
            switch response.result {
            case .failure(let error):
                MBProgressHUD.hide(for: self.view, animated: true)
                let alert = UIAlertController(title: "Error!", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let again = UIAlertAction(title: "Refresh", style: .default, handler: { (_) in
                    self.getAllRepo()
                })
                alert.addAction(again)
                self.present(alert, animated: true, completion: nil)
            case .success(let result):
                App.data.repo.removeAll()
                let res = result as! [[String:Any]]
                for i in 0..<res.count {
                    let owner = res[i]["owner"] as! [String:Any]
                    App.data.repo.append(RepoModel(name: res[i]["name"] as! String,
                                                   full_name: res[i]["full_name"] as! String,
                                                   description: res[i]["description"] as? String,
                                                   html_url: res[i]["html_url"] as! String,
                                                   owner: Owner(login: owner["login"] as! String,
                                                                avatar_url: owner["avatar_url"] as! String)))
                    if i == res.count - 1 {
                        self.ibAllRepo.reloadData()
                        MBProgressHUD.hide(for: self.view, animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        self.getAllRepo()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "details" {
            if let indexPath = self.ibAllRepo.indexPathForSelectedRow {
                let vc = segue.destination as! DetailsViewController
                if self.searchActive {
                    vc.full_name = App.data.repoSearch[indexPath.row].full_name
                } else {
                    vc.full_name = App.data.repo[indexPath.row].full_name
                }
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchActive {
            return App.data.repoSearch.count
        } else {
            return App.data.repo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repo") as! RepoTableViewCell
        if self.searchActive {
            let img = ImageResource(downloadURL: URL(string: App.data.repoSearch[indexPath.row].owner.avatar_url)!, cacheKey: App.data.repoSearch[indexPath.row].owner.avatar_url)
            cell.logoImage.kf.setImage(with: img, placeholder: UIImage(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.ownerName.text = App.data.repoSearch[indexPath.row].owner.login
            cell.repoName.text = App.data.repoSearch[indexPath.row].name
        } else {
            let img = ImageResource(downloadURL: URL(string: App.data.repo[indexPath.row].owner.avatar_url)!, cacheKey: App.data.repo[indexPath.row].owner.avatar_url)
            cell.logoImage.kf.setImage(with: img, placeholder: UIImage(named: "logo"), options: nil, progressBlock: nil, completionHandler: nil)
            cell.ownerName.text = App.data.repo[indexPath.row].owner.login
            cell.repoName.text = App.data.repo[indexPath.row].name
        }
        return cell
    }
}

extension ViewController:UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.ibAllRepo.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchActive = true
        App.data.repoSearch.removeAll()
        for i in 0..<App.data.repo.count {
            if App.data.repo[i].name.uppercased().range(of: searchText.uppercased()) != nil {
                App.data.repoSearch.append(App.data.repo[i])
                self.ibAllRepo.reloadData()
            } else {
                self.ibAllRepo.reloadData()
            }
        }
    }
}
