//
//  AddressListViewController.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 29/04/26.
//

import UIKit

class AddressListViewController: UIViewController {
    
    private let tableView = UITableView()
    private var addresses: [Address] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Catálogo de Direcciones"
        setupTableView()
        loadAddresses()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.register(AddressTableViewCell.self, forCellReuseIdentifier: "AddressCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadAddresses() {
        addresses = AddressManager.shared.addresses
        tableView.reloadData()
    }
}

// MARK: - UITableView DataSource & Delegate
extension AddressListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCell", for: indexPath) as! AddressTableViewCell
        let address = addresses[indexPath.row]
        cell.configure(with: address)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let address = addresses[indexPath.row]
        let editVC = EditAddressViewController(address: address)
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }
}

// MARK: - Delegate para refrescar lista
extension AddressListViewController: EditAddressDelegate {
    func didUpdateAddress() {
        loadAddresses()
    }
}
