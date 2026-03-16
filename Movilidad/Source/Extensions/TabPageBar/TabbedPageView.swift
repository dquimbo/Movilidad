//
//  TabbedPageView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 31/1/22.
//

import UIKit

open class TabbedPageView: UIView {
    open weak var delegate: TabbedPageViewDelegate?
    
    // The container view that contains the tab content (views)
    private lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        
        return view
    }()
    
    // View that contains the collection view that displays the different pages
    private lazy var tabContentView: TabContentView = {
        let tcv = TabContentView(views: [])
        tcv.translatesAutoresizingMaskIntoConstraints = false
        
        tcv.backgroundColor = .clear
        return tcv
    }()
    
    // View that holds the tabs and selection slider
    public lazy var tabBar: TabBar = {
        let tb = TabBar(frame: CGRect.zero)
        tb.translatesAutoresizingMaskIntoConstraints = false
        
        return tb
    }()
    
    // Determines if the user can manually swipe through the tab views or if they're required to press the tab headers in order to change tabs
    public var isManualScrollingEnabled: Bool = false
    
    private var tabs: [Tab] = []
    private var indexSelected = 0
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    /// Adds the necessary subviews to the `TabbedPageView`
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        clipsToBounds = true
        
        addSubview(containerView)
        addSubview(tabBar)
        containerView.addSubview(tabContentView)
    }
    
    /// Adds the necessary constraints to the subviews of the `TabbedPageView`
    ///
    /// Called when the `TabbedPageView`'s is reloaded after the delegate and datasource are set
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            tabBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            
            // Container view constraint
            containerView.topAnchor.constraint(equalTo: tabBar.bottomAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            // Tab bar constraints
            tabBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tabBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            (tabBar.height == nil ?
                tabBar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.07) :
                tabBar.heightAnchor.constraint(equalToConstant: tabBar.height!)),
            
            // Container view constraint
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            
            // Tab content view constraints
            tabContentView.topAnchor.constraint(equalTo: containerView.topAnchor),
            tabContentView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            tabContentView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            tabContentView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }
    
    private func initializeTabBar() {
        var tabsList:[Tab] = []
        for index in 0..<tabs.count {
            let tab = tabs[index]
            tabsList.append(tab)
        }
        
        DispatchQueue.main.async {
            self.tabBar.tabs = tabsList
            if self.tabBar.tabWidth == nil {
                self.tabBar.tabWidth = self.bounds.size.width / CGFloat(tabsList.count)
            }
            self.tabBar.tabCollectionView.delegate = self
            self.tabBar.tabCollectionView.dataSource = self
            self.tabBar.reload()
        }
    }
    
    private func initializeTabContents() {
        let parentViewController = getViewController(for: self)
        
        var views:[UIView] = []
        for index in 0..<tabs.count {
            let tab = tabs[index]
            
            switch tab.source {
            case .view(let view):
                views.append(view)
            case .viewController(let viewController):
                parentViewController?.addChild(viewController)
                viewController.didMove(toParent: parentViewController)
                
                views.append(viewController.view)
            }
        }
        
        tabContentView.views = views
        tabContentView.tabContentCollectionView.isScrollEnabled = isManualScrollingEnabled
        tabContentView.tabContentCollectionView.reloadData()
    }
    
    public func reloadData() {
        // Once the tabs are set, create the tab bar
        initializeTabBar()
        
        // Once the views are set, initialize the tab contents
        initializeTabContents()
        
        // Add constraints
        setupLayout()
    }
    
    public func setTabs(tabs: [Tab]) {
        self.tabs = tabs
        changeTabSelected(index: 0)
    }
    
    public func reloadLayout() {
        tabContentView.tabContentCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    private func getViewController(for view: UIView) -> UIViewController? {
        if let nextResponder = view.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = view.next as? UIView {
            return getViewController(for: nextResponder)
        } else {
            return nil
        }
    }
}

extension TabbedPageView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Only animates if the tab selected is the previous or next to the current tab
        let animated = indexPath.row - 1 == self.indexSelected || indexPath.row + 1 == self.indexSelected  ? true : false
        tabContentView.tabContentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
        
        delegate?.tabbedPageView(self, didSelectTabAt: indexPath.row)
        
        changeTabSelected(index: indexPath.row)
    }
    
    func changeTabSelected(index: Int) {
        self.indexSelected = index
        let tabSelected = tabs[index]
        
        tabs = tabs.map({ tab -> Tab in
            var modifyTab = tab
            modifyTab.isSelected = tab.id == tabSelected.id
            
            return modifyTab
        })
        
        tabBar.tabCollectionView.reloadData()
    }
}

extension TabbedPageView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tab = tabs[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IconCell", for: indexPath) as! TabIconCollectionViewCell
        cell.imageView.image = tab.isSelected ? tab.type.iconTabSelected : tab.type.iconTab
        
        return cell
    }
}

extension TabbedPageView : UICollectionViewDelegateFlowLayout {
    // responsible for telling the layout the size of a given cell
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.tabBar.tabWidth ?? 0, height: collectionView.bounds.size.height)
    }
    
    //  returns the spacing between the cells, headers, and footers. A constant is used to store the value
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0;
    }
}

