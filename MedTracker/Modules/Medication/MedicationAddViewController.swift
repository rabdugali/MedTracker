//
//  MedicationAddViewController.swift
//  MedTracker
//
//  Created by ra on 8/20/22.
//

import UIKit

class MedicationAddViewController: UIViewController {

    private lazy var nameTextField: UITextField = makeTextField()
    private lazy var timeLabel: UILabel = makeLabel(Strings.time)
    private lazy var dozeLabel: UILabel = makeLabel(Strings.doze)
    private lazy var datePicker: UIDatePicker = makeDatePicker()
    private lazy var dozePicker: UIPickerView = makePickerView()
    private lazy var saveButton: UIButton = makeSaveButton()
    
    private let viewModel: MedicationAddViewModel
    
    init(viewModel: MedicationAddViewModel) {
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
}

//MARK: - Layout

extension MedicationAddViewController {
    private func setup() {
        title = Constans.addMedicationTitle
        view.backgroundColor = .systemGray5
        viewModel.delegate = self
        viewModel.setIntakeTime(datePicker.date.currentTimeZone())
    }
    
    private func setupLayout() {
        view.addSubview(nameTextField)
        nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        nameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Self.innerInsets).isActive = true
        
        let breakLine = makeBreakLine()
        view.addSubview(breakLine)
        breakLine.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        breakLine.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        breakLine.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: Self.breakLineInset).isActive = true
        
        view.addSubview(datePicker)
        datePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        datePicker.topAnchor.constraint(equalTo: breakLine.bottomAnchor, constant: Self.breakLineInset).isActive = true
        
        view.addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        timeLabel.topAnchor.constraint(equalTo: datePicker.topAnchor).isActive = true
        timeLabel.bottomAnchor.constraint(equalTo: datePicker.bottomAnchor).isActive = true
        
        let breakLine2 = makeBreakLine()
        view.addSubview(breakLine2)
        breakLine2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        breakLine2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        breakLine2.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: Self.breakLineInset).isActive = true

        view.addSubview(dozePicker)
        dozePicker.widthAnchor.constraint(equalToConstant: Self.dozePickerWidth).isActive = true
        dozePicker.heightAnchor.constraint(equalToConstant: Self.dozePickerHeight).isActive = true
        dozePicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        dozePicker.topAnchor.constraint(equalTo: breakLine2.bottomAnchor).isActive = true
        
        view.addSubview(dozeLabel)
        dozeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        dozeLabel.topAnchor.constraint(equalTo: dozePicker.topAnchor).isActive = true
        dozeLabel.bottomAnchor.constraint(equalTo: dozePicker.bottomAnchor).isActive = true
        
        view.addSubview(saveButton)
        saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Self.innerInsets).isActive = true
        saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Self.innerInsets).isActive = true
        saveButton.topAnchor.constraint(equalTo: dozePicker.bottomAnchor, constant: Self.innerInsets).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: Self.saveButtonHeight).isActive = true
    }
    
    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = Strings.name
        textField.returnKeyType = .done
        textField.delegate = self
        return textField
    }
    
    private func makeBreakLine() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }
    
    private func makeDatePicker() -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .time
        datePicker.minuteInterval = 5
        datePicker.addTarget(
            self,
            action: #selector(dateChanged),
            for: .valueChanged
        )
        return datePicker
    }
    
    private func makePickerView() -> UIPickerView {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        picker.delegate = self
        picker.dataSource = self
        return picker
    }
    
    private func makeSaveButton() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(
            self,
            action: #selector(didTapSaveButton),
            for: .touchUpInside
        )
        return button
    }
}

//MARK: - Actions

extension MedicationAddViewController {
    @objc private func dateChanged() {
        viewModel.setIntakeTime(datePicker.date.currentTimeZone())
    }
    
    @objc private func didTapSaveButton() {
        viewModel.didTapSaveButton(self)
    }
}

//MARK: - MedicationAddViewModelDelegate

extension MedicationAddViewController: MedicationAddViewModelDelegate {
    func didAddMedication() {
        navigationController?.popViewController(animated: true)
    }
}

//MARK: - UITextFieldDelegate

extension MedicationAddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        viewModel.setName(text)
    }
}

//MARK: - UIPickerViewDelegate

extension MedicationAddViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return Self.dozeNumber
        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + 1)"
        }
        return Strings.pills
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component > 0 { return }
        viewModel.setDoze(row + 1)
    }
}

//MARK: - Constans

extension MedicationAddViewController {
    private static let innerInsets: CGFloat = 20
    private static let breakLineInset: CGFloat = 10
    private static let dozePickerWidth: CGFloat = 150
    private static let dozePickerHeight: CGFloat = 100
    private static let saveButtonHeight: CGFloat = 50
    private static let dozeNumber: Int = 10
}
