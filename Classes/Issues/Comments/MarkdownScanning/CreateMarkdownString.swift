//
//  CreateMarkdownString.swift
//  Freetime
//
//  Created by Ryan Nystrom on 6/8/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import CocoaMarkdown

func CreateMarkdownString(
    body: String,
    width: CGFloat,
    attributes: CMTextAttributes,
    inset: UIEdgeInsets
    ) -> NSAttributedStringSizing? {
    let data = body.data(using: .utf8)
    guard let document = CMDocument(data: data, options: [.hardBreaks]),
        let attributedString = document.attributedString(with: attributes)
        else { return nil }

    return NSAttributedStringSizing(
        containerWidth: width,
        attributedText: attributedString,
        inset: inset
    )
}
