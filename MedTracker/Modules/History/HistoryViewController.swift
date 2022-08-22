//
//  HistoryViewController.swift
//  MedTracker
//
//  Created by ra on 8/21/22.
//

import UIKit

class HistoryViewController: UIViewController, TabBarModel {

    private lazy var tableView: UITableView = makeTableView()
    
    private let viewModel: HistoryViewModel
    private var history: [History] {
        viewModel.history
    }
    
    let tabBarTitle: String = Constans.historyTitle
    let tabBarImage: UIImage = Images.chartBarImage
    
    init(viewModel: HistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchHistory()
    }
}

//MARK: - Layout

extension HistoryViewController {
    
    private func setup() {
        title = tabBarTitle
        viewModel.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(tableView)
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func makeTableView() -> UITableView {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .systemGray5
        tableView.alwaysBounceVertical = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constans.historyCellIdentifier)
        return tableView
    }
}

//MARK: - HistoryViewModelDelegate

extension HistoryViewController: HistoryViewModelDelegate {
    func didUpdateHistory(_: [History]) {
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return history[section].date.prettyDate()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history[section].takenMedications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constans.historyCellIdentifier)!
        let model = history[indexPath.section].takenMedications[indexPath.row]
        return configuredCell(cell, with: model)
    }
    
    private func configuredCell(_ cell: UITableViewCell, with model: Medication) -> UITableViewCell {
        var content = cell.defaultContentConfiguration()
        content.text = model.name
        if let doze = model.doze {
            content.secondaryText = "Doze: \(doze)"
        }
        cell.contentConfiguration = content
        return cell
    }
}


//MARK: - Constans

extension HistoryViewController {
    private static let spacingInsets: CGFloat = 12
    private static let innerInsets: CGFloat = 40
    private static let insetForSection: CGFloat = 20
    private static let cellHeight: CGFloat = 100
}
