//
//  SettingsViewController.swift
//  Freetime
//
//  Created by Ryan Nystrom on 5/15/17.
//  Copyright © 2017 Ryan Nystrom. All rights reserved.
//

import UIKit
import SnapKit
import IGListKit

final class SettingsViewController: UIViewController, ListAdapterDataSource, GithubSessionListener {

    // injected
    fileprivate let sessionManager: GithubSessionManager
    weak var rootNavigationManager: RootNavigationManager? = nil

    fileprivate lazy var adapter: ListAdapter = { ListAdapter(updater: ListAdapterUpdater(), viewController: self) }()

    private let addKey = "add" as ListDiffable
    private let signoutKey = "signout" as ListDiffable
    private let reportKey = "report" as ListDiffable
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.alwaysBounceVertical = true
        view.contentInset = UIEdgeInsets(
            top: Styles.Sizes.tableSectionSpacing,
            left: 0,
            bottom: Styles.Sizes.tableSectionSpacing,
            right: 0
        )
        view.backgroundColor = UIColor.groupTableViewBackground
        return view
    }()

    init(
        sessionManager: GithubSessionManager,
        rootNavigationManager: RootNavigationManager
        ) {
        self.sessionManager = sessionManager
        self.rootNavigationManager = rootNavigationManager
        super.init(nibName: nil, bundle: nil)
        sessionManager.addListener(listener: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adapter.dataSource = self
        adapter.collectionView = collectionView

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(SettingsViewController.onDone)
        )
    }
    
    // MARK: Accessibility
    
    override func accessibilityPerformEscape() -> Bool {
        onDone()
        return true
    }

    // MARK: Private API

    @objc private func onDone() {
        dismiss(animated: true)
    }

    // MARK: ListAdapterDataSource

    func objects(for listAdapter: ListAdapter) -> [ListDiffable] {
        return [
            addKey,
            sessionManager,
            reportKey,
            signoutKey
        ]
    }

    func listAdapter(_ listAdapter: ListAdapter, sectionControllerFor object: Any) -> ListSectionController {
        guard let object = object as? ListDiffable else { fatalError("Object not diffable") }
        if object === addKey, let mgr = rootNavigationManager {
            return SettingsAddAccountSectionController(rootNavigationManager: mgr)
        } else if object === signoutKey {
            return SettingsSignoutSectionController(sessionManager: sessionManager)
        } else if object === reportKey {
            return SettingsReportSectionController()
        } else if object is GithubSessionManager {
            return SettingsUsersSectionController()
        }
        fatalError("Unhandled object: \(object)")
    }

    func emptyView(for listAdapter: ListAdapter) -> UIView? { return nil }

    // MARK: GithubSessionListener

    func didFocus(manager: GithubSessionManager, userSession: GithubUserSession) {
        adapter.performUpdates(animated: false)
    }

    func didRemove(manager: GithubSessionManager, userSessions: [GithubUserSession], result: GithubSessionResult) {
        adapter.performUpdates(animated: false)
    }

}
