//
//  MetroSearchView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 29/9/23.
//

import Foundation

class MetroSearchView: NibLoadingView {
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - IBActions
    
    @IBAction func closePressed(_ sender: Any) {
        removeFromSuperview()
    }
}
