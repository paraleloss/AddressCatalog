//
//  AddressTableViewCell.swift
//  AddressesCatalog
//
//  Created by Saúl Pérez on 29/04/26.
//

import UIKit

class AddressTableViewCell: UITableViewCell {
    
    private let addressLabel = UILabel()
    private let cityStateLabel = UILabel()
    private let dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupUI() {
        contentView.addSubview(addressLabel)
        contentView.addSubview(cityStateLabel)
        contentView.addSubview(dateLabel)
        
        addressLabel.font = .systemFont(ofSize: 16, weight: .medium)
        cityStateLabel.font = .systemFont(ofSize: 14)
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .secondaryLabel
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        cityStateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            cityStateLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 4),
            cityStateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cityStateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: cityStateLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with address: Address) {
        addressLabel.text = "\(address.addressLine1)"
        cityStateLabel.text = "\(address.city), \(address.stateProvince)"
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = "Modificado: \(formatter.string(from: address.modifiedDate))"
    }
}
