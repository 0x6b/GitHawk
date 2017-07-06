//
//  WebviewCellHeightCache.swift
//  Freetime
//
//  Created by Ryan Nystrom on 7/5/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import Foundation
import IGListKit

final class WebviewCellHeightCache: IssueCommentHtmlCellDelegate {

    private var htmlSizes = [String: CGSize]()
    private weak var sectionController: ListSectionController? = nil

    init(sectionController: ListSectionController) {
        self.sectionController = sectionController
    }

    // MARK: Public API

    func height(model: IssueCommentHtmlModel) -> CGFloat {
        return htmlSizes[model.html]?.height ?? Styles.Sizes.tableCellHeight
    }

    // MARK: IssueCommentHtmlCellDelegate

    func webViewDidLoad(cell: IssueCommentHtmlCell, html: String) {
        guard htmlSizes[html] == nil,
            let sectionController = self.sectionController
            else { return }
        htmlSizes[html] = cell.webViewPreferredSize()
        UIView.performWithoutAnimation {
            sectionController.collectionContext?.invalidateLayout(for: sectionController)
        }
    }

}

