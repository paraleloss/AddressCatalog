//
//  EditAddressViewController.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 30/04/26.
//

import UIKit

protocol EditAddressDelegate: AnyObject {
    func didUpdateAddress()
}

class EditAddressViewController: UIViewController {
    
    weak var delegate: EditAddressDelegate?
    
    private let originalAddress: Address
    private var editedAddress: Address
    
    private let scrollView = UIScrollView()
    private let contentStack = UIStackView()
    
    private let addressLineLabel = UILabel()
    private let cityTextField = UITextField()
    private let stateTextField = UITextField()
    private let postalCodeLabel = UILabel()
    private let countryLabel = UILabel()
    
    init(address: Address) {
        self.originalAddress = address
        self.editedAddress = address
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editar Dirección"
        view.backgroundColor = .systemBackground
        
        setupNavigationBar()
        setupUI()
        populateData()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(saveChanges))
    }
    
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentStack)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        
        contentStack.axis = .vertical
        contentStack.spacing = 24
        contentStack.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 20)
        contentStack.isLayoutMarginsRelativeArrangement = true
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentStack.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        let addressSection = createSection(title: "Dirección", value: editedAddress.addressLine1)
        
        let citySection = createEditableSection(title: "Ciudad", textField: cityTextField)
        cityTextField.placeholder = "Ingrese la ciudad"

        let stateSection = createEditableSection(title: "Estado / Provincia", textField: stateTextField)
        stateTextField.placeholder = "Ingrese el estado o provincia"
        
        postalCodeLabel.text = "Código Postal: \(editedAddress.postalCode)"
        countryLabel.text = "País: \(editedAddress.countryRegion)"

        contentStack.addArrangedSubview(addressSection)
        contentStack.addArrangedSubview(citySection)
        contentStack.addArrangedSubview(stateSection)
        contentStack.addArrangedSubview(createSection(title: "Código Postal", value: editedAddress.postalCode))
        contentStack.addArrangedSubview(createSection(title: "País", value: editedAddress.countryRegion))
    }
    
    private func populateData() {
        cityTextField.text = editedAddress.city
        stateTextField.text = editedAddress.stateProvince
    }
    
    // MARK: - create sections
    private func createSection(title: String, value: String) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 17)
        valueLabel.numberOfLines = 0
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        return stack
    }
    
    private func createEditableSection(title: String, textField: UITextField) -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .secondaryLabel
        
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 17)
        textField.autocapitalizationType = .words
        textField.clearButtonMode = .whileEditing
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(textField)
        return stack
    }
    
    // MARK: - Save
    @objc private func saveChanges() {
        editedAddress.city = cityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? editedAddress.city
        editedAddress.stateProvince = stateTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? editedAddress.stateProvince

        editedAddress.modifiedDate = Date()
        AddressManager.shared.updateAddress(editedAddress)
        delegate?.didUpdateAddress()
        navigationController?.popViewController(animated: true)
    }
}
