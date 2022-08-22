//
//  MedicationCollectionViewCell.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit

enum CollectionViewCellType {
    case medication
    case today
}

protocol MedicationInfoCellDelegate: AnyObject {
    func didTapConfirmButton(_ medication: Medication)
    func didTapDeleteButton(_ medication: Medication)
}

extension MedicationInfoCellDelegate {
    func didTapConfirmButton(_ medication: Medication) { }
    func didTapDeleteButton(_ medication: Medication) { }
}

class MedicationInfoCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MedicationInfoCellDelegate?
    
    private var type: CollectionViewCellType = .today
    private lazy var nameLabel: UILabel = makeNameLabel()
    private lazy var dozeLabel: UILabel = makeDescriptionLabel()
    private lazy var timeLabel: UILabel = makeDescriptionLabel()
    private lazy var confirmButton = makeConfirmButton()
    private lazy var deleteButton = makeDeleteButton()
    private var medication: Medication?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(_ model: Medication, for type: CollectionViewCellType) {
        guard
            let name = model.name,
            let doze = model.doze,
            let intakeTime = model.intakeTime
        else {
            return
        }
        if type == .medication {
            confirmButton.isHidden = true
            deleteButton.isHidden = false
        } else {
            confirmButton.isHidden = false
            deleteButton.isHidden = true
        }
        self.type = type
        self.medication = model
        nameLabel.text = name
        dozeLabel.text = "Doze: \(doze)"
        timeLabel.text = "Time: \(intakeTime.prettyTime())"
    }
}

//MARK: - Layout

extension MedicationInfoCollectionViewCell {
    
    private func setupLayout() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        
        contentView.addSubview(nameLabel)
        nameLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.sideInsets).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.sideInsets).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.sideInsets).isActive = true
        
        contentView.addSubview(timeLabel)
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.sideInsets).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.sideInsets).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.innerInsets).isActive = true
        
        contentView.addSubview(dozeLabel)
        dozeLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        dozeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.sideInsets).isActive = true
        dozeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.sideInsets).isActive = true
        dozeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        dozeLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor).isActive = true
        
        contentView.addSubview(confirmButton)
        confirmButton.layer.cornerRadius = Self.buttonSize / 2
        confirmButton.heightAnchor.constraint(equalToConstant: Self.buttonSize).isActive = true
        confirmButton.widthAnchor.constraint(equalToConstant: Self.buttonSize).isActive = true
        confirmButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -Self.sideInsets).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.innerInsets).isActive = true
        
        contentView.addSubview(deleteButton)
        deleteButton.layer.cornerRadius = Self.buttonSize / 2
        deleteButton.heightAnchor.constraint(equalToConstant: Self.buttonSize).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: Self.buttonSize).isActive = true
        deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -Self.sideInsets).isActive = true
        deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Self.innerInsets).isActive = true
    }
    
    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(Self.descriptionFontSize)
        return label
    }
    
    private func makeConfirmButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemGreen
        button.setImage(Images.checkmarkImage, for: .normal)
        button.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        return button
    }
    
    private func makeDeleteButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = .systemRed
        button.setImage(Images.trashImage, for: .normal)
        button.addTarget(self, action: #selector(didTapDeleteButton), for: .touchUpInside)
        return button
    }
}

//MARK: - Actions

extension MedicationInfoCollectionViewCell {
    @objc private func didTapConfirmButton() {
        guard let medication = medication else { return }
        delegate?.didTapConfirmButton(medication)
    }
    
    @objc private func didTapDeleteButton() {
        guard let medication = medication else { return }
        delegate?.didTapDeleteButton(medication)
    }
}

//MARK: - Constans

extension MedicationInfoCollectionViewCell {
    private static let innerInsets: CGFloat = 12
    private static let sideInsets: CGFloat = 20
    private static let descriptionFontSize: CGFloat = 12
    private static let buttonSize: CGFloat = 32
}
