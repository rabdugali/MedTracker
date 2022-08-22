//
//  ViewController.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit
import CoreData

class MedicationViewController: UIViewController, TabBarModel {

    private lazy var collectionView: UICollectionView = makeCollectionView()
    private lazy var addButton: UIBarButtonItem = makeAddButton()
    
    private let viewModel: MedicationViewModel
    private let factory: ViewControllerFactory
    
    private var medications: [Medication] {
        viewModel.medications
    }
    
    let tabBarTitle: String = Constans.medicationTitle
    let tabBarImage: UIImage = Images.pillImage
    
    init(viewModel: MedicationViewModel, factory: ViewControllerFactory) {
        self.viewModel = viewModel
        self.factory = factory
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
        viewModel.fetchMedications()
    }
    
}

//MARK: - Layout

extension MedicationViewController {
    
    private func setup() {
        title = tabBarTitle
        navigationItem.rightBarButtonItem = addButton
        viewModel.delegate = self
    }
    
    private func setupLayout() {
        view.addSubview(collectionView)
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }

    private func makeCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemGray5
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MedicationInfoCollectionViewCell.self, forCellWithReuseIdentifier: Constans.medicationCellIdentifier)
        return collectionView
    }
    
    private func makeAddButton() -> UIBarButtonItem {
        let button = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAddButton)
        )
        return button
    }
    
}

//MARK: - Actions

extension MedicationViewController {
    
    @objc private func didTapAddButton() {
        let vc = factory.makeMedicationAddViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - MedicationViewModelDelegate

extension MedicationViewController: MedicationViewModelDelegate {
    func didUpdateMedications(_: [Medication]) {
        collectionView.reloadData()
    }
}

//MARK: - MedicationInfoCellDelegate

extension MedicationViewController: MedicationInfoCellDelegate {
    func didTapDeleteButton(_ medication: Medication) {
        viewModel.didTapDeleteButton(self, medication)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension MedicationViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constans.medicationCellIdentifier, for: indexPath) as! MedicationInfoCollectionViewCell
        cell.delegate = self
        cell.configureCell(medications[indexPath.item], for: .medication)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(
            top: Self.insetForSection,
            left: Self.insetForSection,
            bottom: Self.insetForSection,
            right: Self.insetForSection
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(
            width: collectionView.bounds.width - Self.innerInsets,
            height: Self.cellHeight
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Self.spacingInsets
    }
    
}

//MARK: - Constans

extension MedicationViewController {
    private static let spacingInsets: CGFloat = 12
    private static let innerInsets: CGFloat = 40
    private static let insetForSection: CGFloat = 20
    private static let cellHeight: CGFloat = 100
}
