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
    private let address: Address
    private var currentAddress: Address
    
    private let cityPicker = UIPickerView()
    private let statePicker = UIPickerView()
    
    private let cities: [String]
    private let states: [String]
    
    init(address: Address) {
        self.address = address
        self.currentAddress = address
        self.cities = AddressManager.shared.getUniqueCities()
        self.states = AddressManager.shared.getUniqueStates()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Editar Dirección"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        // Aquí puedes crear un formulario bonito con UILabel + UIPickerView o UITextField + toolbar con picker
        // Para simplicidad, usaré dos botones que abren pickers en alertas
        
        let stack = UIStackView(arrangedSubviews: [
            createEditableField(title: "Ciudad", value: currentAddress.city, action: #selector(editCity)),
            createEditableField(title: "Estado/Provincia", value: currentAddress.stateProvince, action: #selector(editState))
        ])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Guardar", style: .done, target: self, action: #selector(saveChanges))
    }
    
    private func createEditableField(title: String, value: String, action: Selector) -> UIView {
        let container = UIView()
        let label = UILabel()
        let valueLabel = UILabel()
        let button = UIButton(type: .system)
        
        label.text = title
        label.font = .boldSystemFont(ofSize: 16)
        valueLabel.text = value
        valueLabel.tag = 100 // para identificar después
        button.setTitle("Cambiar", for: .normal)
        button.addTarget(self, action: action, for: .touchUpInside)
        
        // Layout simple...
        // (puedes mejorarlo con stack views)
        return container
    }
    
    @objc private func editCity() {
        showPicker(title: "Seleccionar Ciudad", options: cities, current: currentAddress.city) { selected in
            self.currentAddress.city = selected
            self.reloadUI()
        }
    }
    
    @objc private func editState() {
        showPicker(title: "Seleccionar Estado/Provincia", options: states, current: currentAddress.stateProvince) { selected in
            self.currentAddress.stateProvince = selected
            self.reloadUI()
        }
    }
    
    private func showPicker(title: String, options: [String], current: String, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: title, message: "\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: 270, height: 160))
        picker.dataSource = self
        picker.delegate = self
        // Seleccionar valor actual
        if let index = options.firstIndex(of: current) {
            picker.selectRow(index, inComponent: 0, animated: false)
        }
        
        alert.view.addSubview(picker)
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Aceptar", style: .default) { _ in
            let selectedRow = picker.selectedRow(inComponent: 0)
            completion(options[selectedRow])
        })
        
        present(alert, animated: true)
    }
    
    @objc private func saveChanges() {
        currentAddress.modifiedDate = Date()
        AddressManager.shared.updateAddress(currentAddress)
        delegate?.didUpdateAddress()
        navigationController?.popViewController(animated: true)
    }
    
    private func reloadUI() {
        // Recargar las etiquetas de ciudad y estado
        view.subviews.forEach { $0.removeFromSuperview() }
        setupUI()
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension EditAddressViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cities.count // o states según el caso
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cities[row] // ajustar según picker
    }
}
