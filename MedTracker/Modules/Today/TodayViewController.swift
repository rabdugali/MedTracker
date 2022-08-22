//
//  TodayViewController.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit

class TodayViewController: UIViewController, TabBarModel {

    private lazy var collectionView: UICollectionView = makeCollectionView()
    
    private let viewModel: TodayViewModel
    private var medications: [Medication] {
        viewModel.medications
    }
    
    let tabBarTitle: String = Constans.todayTitle
    let tabBarImage: UIImage = Images.calendarImage
    
    init(viewModel: TodayViewModel) {
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
        viewModel.fetchTodayMedications()
    }
    
}

//MARK: - Layout

extension TodayViewController {
    
    private func setup() {
        title = tabBarTitle
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
        collectionView.register(MedicationInfoCollectionViewCell.self, forCellWithReuseIdentifier: Constans.todayCellIdentifier)
        return collectionView
    }
}

//MARK: - TodayViewModelDelegate

extension TodayViewController: TodayViewModelDelegate {
    func didUpdateMedications(_: [Medication]) {
        collectionView.reloadData()
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension TodayViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return medications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constans.todayCellIdentifier, for: indexPath) as! MedicationInfoCollectionViewCell
        cell.delegate = self
        cell.configureCell(medications[indexPath.item], for: .today)
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

//MARK: - MedicationInfoCellDelegate

extension TodayViewController: MedicationInfoCellDelegate {
    func didTapConfirmButton(_ medication: Medication) {
        viewModel.didTapConfirmButton(self, medication)
    }
}

//MARK: - Constans

extension TodayViewController {
    private static let spacingInsets: CGFloat = 12
    private static let innerInsets: CGFloat = 40
    private static let insetForSection: CGFloat = 20
    private static let cellHeight: CGFloat = 100
}
