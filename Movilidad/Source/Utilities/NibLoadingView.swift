//
//  NibLoadingView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 13/1/22.
//

import UIKit

class NibLoadingView: UIView {
    
    var view: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    /// Create a view from a Xib and add it to this UIView
    func xibSetup() {
        view = loadViewFromXib()
        view.frame = bounds
        view?.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    
    /// Load a Nib which matches the name of this UIView
    func loadViewFromXib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        
        if let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            return view
        }
        return UIView()
    }
}
