//
//  TabBar.swift
//  Movilidad
//
//  Created by Diego Quimbo on 31/1/22.
//

import UIKit

public class TabBar: UIView {
    
    lazy private var tabCollectionViewFlowLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        return flowLayout
    }()
    
    // The collection view that contains the tabs
    lazy internal var tabCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: self.tabCollectionViewFlowLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor.clear
        cv.setCollectionViewLayout(self.tabCollectionViewFlowLayout, animated: true)
        cv.register(TabIconCollectionViewCell.self, forCellWithReuseIdentifier: "IconCell")
        
        return cv
    }()
    
    internal var tabs: [Tab] = []
    internal var tabCollectionViewPreviousContentOffset: CGFloat = 0
    public var tabWidth: CGFloat?
    public var height: CGFloat?
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    public init(tabs: [Tab]) {
        super.init(frame: CGRect.zero)
        
        self.tabs = tabs
        
        setupView()
    }
    
    open func reload() {
        setupLayout()
        tabCollectionView.reloadData()
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(tabCollectionView)
        
        setupLayout()
    }
    
    private func setupLayout() {
        guard tabs.count != 0 else { return }
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            tabCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            // Collection view constraints
            tabCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            tabCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            tabCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.92),
        ])
    }
}
