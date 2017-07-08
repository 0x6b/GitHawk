//
//  Samples.swift
//  Freetime
//
//  Created by Ryan Nystrom on 6/26/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation

func runningInSample() -> Bool {
    return Bundle.main.object(forInfoDictionaryKey: "RUN_AS_SAMPLE") as? Bool ?? false
}

func sampleUserSession() -> GithubUserSession? {
    guard runningInSample() else { return nil }
    return GithubUserSession(token: "1234")
}

func loadSample(path: String) -> Any? {
    guard runningInSample() else { return nil }
    let url = Bundle.main.url(forResource: path, withExtension: "json")!
    let data = try! Data(contentsOf: url)
    return try! JSONSerialization.jsonObject(with: data, options: [])
}
