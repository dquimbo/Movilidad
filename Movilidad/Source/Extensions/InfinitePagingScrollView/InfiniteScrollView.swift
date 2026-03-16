//
//  InfiniteScrollView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 15/2/22.
//

import UIKit

class InfiniteScrollView: NibLoadingView {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.backgroundColor = .clear
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.isPagingEnabled = true
            scrollView.delegate = self
            
            let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didRecognizeSwipe))
            swipeLeftRecognizer.numberOfTouchesRequired = 2
            swipeLeftRecognizer.direction = .left
            scrollView.addGestureRecognizer(swipeLeftRecognizer)
            
            let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didRecognizeSwipe))
            swipeRightRecognizer.numberOfTouchesRequired = 2
            swipeRightRecognizer.direction = .right
            scrollView.addGestureRecognizer(swipeRightRecognizer)
        }
    }
    @IBOutlet weak var contentScrollView: UIView!
    @IBOutlet weak var stackContentScrollView: UIStackView!
    
    
    // Properties
    var datasource: [UIView]? {
        didSet {
            modifyDatasource()
        }
    }
    
    private var _datasource: [UIView]? {
        didSet {
            setupContentView()
        }
    }
    
    private var _currentIndex = 0
    
    // MARK: - Public Functions
    func insertView(newView: UIView) {
        guard _datasource != nil else { return }
        
        datasource!.append(newView)
        
        // Scroll to new added item
        let xValue = scrollView.frame.size.width * CGFloat(_datasource!.count - 1)
        scrollView.contentOffset = CGPoint(x: xValue, y: 0)
    }
    
    func removeView(accessibilityIdentifier: String) {
        guard _datasource != nil else { return }
        
        datasource!.removeAll(where: {$0.accessibilityIdentifier == accessibilityIdentifier})
        
        let xValue = scrollView.frame.size.width * CGFloat(_datasource!.count - 1)
        scrollView.contentOffset = CGPoint(x: xValue, y: 0)
    }
    
    func layoutWillChange(size: CGSize) {
        let xValue = size.width * CGFloat(_currentIndex)
        scrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: true)
    }
    
    func scrollToView(index: Int) {
        let xValue = scrollView.frame.size.width * CGFloat(index)
        scrollView.setContentOffset(CGPoint(x: xValue, y: 0), animated: true)
    }
}

// MARK: - Private Functions
private extension InfiniteScrollView {
    
    private func modifyDatasource() {
        guard let tempInput = datasource, tempInput.count >= 2 else {
            // Only have one view.. it's not neccessary make it scrollable
            self._datasource = datasource
            return
        }

        // Loop scroll
//        let firstLast = (tempInput.first!.copyView(), tempInput.last!.copyView())
//        tempInput.append(firstLast.0)
//        tempInput.insert(firstLast.1, at: 0)
        
        self._datasource = tempInput
    }
    
    private func setupContentView() {
        let subviews = stackContentScrollView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }

        guard let data = _datasource else { return }

        for i in 0..<data.count {
            self.stackContentScrollView.addArrangedSubview(data[i])

            let constraints = [
                data[i].heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                data[i].widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            ]

            data[i].reloadViewInScroll()
            
            NSLayoutConstraint.activate(constraints)
        }
        
        _currentIndex = _datasource!.count - 1
    }
    
    @objc func didRecognizeSwipe(recognizer: UISwipeGestureRecognizer) {
        let x = recognizer.direction == .right ? scrollView.contentOffset.x - scrollView.frame.width : scrollView.contentOffset.x + scrollView.frame.width
        let nextRect = CGRect(x: x,
                              y: 0,
                              width: scrollView.frame.width,
                              height: scrollView.frame.height)
        
        scrollView.scrollRectToVisible(nextRect, animated: true)
        
        if recognizer.direction == .right {
            // Go to previous screen
            if _currentIndex > 0 {
                _currentIndex -= 1
            }
            
        } else {
            // Go to next screen
            if _currentIndex < _datasource!.count - 1 {
                _currentIndex += 1
            }
        }
    }
}

extension InfiniteScrollView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard _datasource != nil else { return }
//
//        let x = scrollView.contentOffset.x
//        if x >=  scrollView.frame.size.width * CGFloat(_datasource!.count - 1) {
//            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width , y: 0)
//        } else if x == 0 {
//            self.scrollView.contentOffset = CGPoint(x: scrollView.frame.size.width * CGFloat(_datasource!.count - 2), y: 0)
//        }
    }
}
