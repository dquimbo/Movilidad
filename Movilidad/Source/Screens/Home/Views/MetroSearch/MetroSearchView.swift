//
//  MetroSearchView.swift
//  Movilidad
//
//  Created by Diego Quimbo on 29/9/23.
//

import UIKit

protocol MetroSearchViewDelegate: AnyObject {
    func tileSearchHasSelected(guid: String)
}

class MetroSearchView: NibLoadingView {

    // IBOutlets
    @IBOutlet weak var searchTableView: UITableView! {
        didSet {
            searchTableView.register(GeneralSearchCell.nib,
                                     forCellReuseIdentifier: GeneralSearchCell.reuseIdentifier)
            searchTableView.dataSource = self
            searchTableView.delegate = self
        }
    }

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            if #available(iOS 13.0, *) {
                searchBar.searchTextField.textColor = .black
            }
        }
    }

    // Public Properties
    weak var delegate: MetroSearchViewDelegate?

    // Private Properties
    private let vM = MetroSearchViewModel()

    // MARK: - Lifecycle
    required init(frame: CGRect, delegate: MetroSearchViewDelegate) {
        self.delegate = delegate
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

// MARK: - UITableViewDataSource
extension MetroSearchView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vM.getNumberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GeneralSearchCell.reuseIdentifier, for: indexPath) as! GeneralSearchCell
        let operation = vM.getTile(row: indexPath.row)
        cell.configure(viewModel: GeneralSearchCellViewModel(operation: operation))
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MetroSearchView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let operation = vM.getTile(row: indexPath.row)
        guard let guid = operation.id else { return }

        delegate?.tileSearchHasSelected(guid: guid)
    }
}

// MARK: - UISearchBarDelegate
extension MetroSearchView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        vM.updateFilteredTiles(searchText: searchText)
        searchTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
