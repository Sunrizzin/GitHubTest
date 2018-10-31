//
//  AppConstants.swift
//  ShowGitHubRepo
//
//  Created by Алексей Усанов on 31/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import Foundation
import UIKit

struct App {
    struct Network {
        static let allRepo           = "https://api.github.com/repositories"
        static let repoDetails       = "https://api.github.com/repos/"
    }
    struct data {
        static var repo = [RepoModel]()
        static var repoSearch = [RepoModel]()
        static var repoDetail = RepoDetail(avatar_url: "", login: "", name: "", stargazers_count: "", watchers_count: "", forks: "", description: "", created_at: "", updated_at: "", clone_url: "", language: "", spdx_id: "")
    }
}
