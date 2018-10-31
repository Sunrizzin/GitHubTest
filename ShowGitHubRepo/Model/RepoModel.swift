//
//  RepoModel.swift
//  ShowGitHubRepo
//
//  Created by Алексей Усанов on 30/10/2018.
//  Copyright © 2018 Алексей Усанов. All rights reserved.
//

import Foundation

class RepoModel {
    var name: String
    var full_name: String
    var description: String?
    var html_url: String
    var owner: Owner
    
    init(name: String, full_name: String, description: String?, html_url: String, owner: Owner) {
        self.name = name
        self.full_name = full_name
        self.description = description
        self.html_url = html_url
        self.owner = owner
    }
}

class Owner {
    var login: String
    var avatar_url: String
    
    init(login: String, avatar_url: String) {
        self.login = login
        self.avatar_url = avatar_url
    }
}

class RepoDetail {
    var avatar_url: String
    var login: String
    var name: String
    var stargazers_count: String
    var watchers_count: String
    var forks: String
    var description: String
    var created_at: String
    var updated_at: String
    var clone_url: String
    var language: String?
    var spdx_id: String?
    
    init(avatar_url: String, login: String, name: String, stargazers_count: String, watchers_count: String, forks: String, description: String, created_at: String, updated_at: String, clone_url: String, language: String?, spdx_id: String?) {
        self.avatar_url = avatar_url
        self.login = login
        self.name = name
        self.stargazers_count = stargazers_count
        self.watchers_count = watchers_count
        self.forks = forks
        self.description = description
        self.created_at = created_at
        self.updated_at = updated_at
        self.clone_url = clone_url
        self.language = language
        self.spdx_id = spdx_id
    }
}
