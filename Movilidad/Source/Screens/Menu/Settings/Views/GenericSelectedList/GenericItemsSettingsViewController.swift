//
//  GenericItemsSettingsViewController.swift
//  Movilidad
//
//  Created by Diego Quimbo on 9/2/22.
//

import UIKit
import RxSwift
import RxCocoa

class GenericItemsSettingsViewController: UIViewController, NibLoadable {
    
    // IBOutlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
            tableView.register(SettingItemCell.nib,
                               forCellReuseIdentifier: SettingItemCell.reuseIdentifier)
        }
    }
    
    @IBOutlet weak var backContentView: UIView!
    
    // Private vars
    private let disposeBag = DisposeBag()
    private var profiles = BehaviorRelay<[SelectItemProtocol]>(value: [])
    private let vM: GenericItemsSettingsViewModel
    private let popoverStyle: Bool

    // MARK: - Life Cycle
    required init(actionType: GenericItemsSettingsActionType, isPopover: Bool = false) {
        vM = .init(action: actionType)
        popoverStyle = isPopover
        super.init(nibName: GenericItemsSettingsViewController.nibName, bundle: GenericItemsSettingsViewController.bundle)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpRxTableView()
        
        // If the controller is presented as popover hide back button
        backContentView.isHidden = popoverStyle
    }
    
    // MARK: - IBActions
    @IBAction func pressedBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

private extension GenericItemsSettingsViewController {
    func setUpRxTableView() {     
        profiles.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: SettingItemCell.reuseIdentifier, cellType: SettingItemCell.self)) { [weak self] (row, item, cell) in
                guard let self = self else { return }
                let settingItemCellVM = SettingItemViewModel(item: item,
                                                             isFirstCell: row == 0,
                                                             isLastCell: self.vM.isLastItem(row: row),
                                                             isSelected: self.vM.isSelected(row: row))
                cell.configure(viewModel: settingItemCellVM)
        }.disposed(by: disposeBag)
        
        
        tableView.rx.modelSelected(SelectItemProtocol.self)
        .subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            self.vM.itemSelected(item: item)
            
            // Reload TableView
            self.profiles.accept(self.vM.items)
            self.backToMenu()
        }).disposed(by: disposeBag)
        
        profiles.accept(vM.items)
    }
    
    func backToMenu() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self else { return }
            
            if popoverStyle {
                dismiss(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
        }
    }
}
