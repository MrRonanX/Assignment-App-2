//
//  TableViewCell.swift
//  Assignment App 2
//
//  Created by Roman Kavinskyi on 17.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
	
	static let identifier = "TableViewCell"
	
	var avatar = UIImageView()
	var personalView = UIView()
	let name = UILabel()
	let email = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		
		setupCell()
		// avatar.sizeThatFits(CGSize(width: 40, height: 40))
	
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	
	private func setupCell() {
		addSubview(avatar)
		let size = CGFloat(60)
		avatar.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			avatar.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
			avatar.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			avatar.widthAnchor.constraint(equalToConstant: size),
			avatar.heightAnchor.constraint(equalToConstant: size),
//			avatar.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
		])
		
		addSubview(personalView)
		personalView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			personalView.leadingAnchor.constraint(equalTo: avatar.trailingAnchor, constant: 10),
			personalView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
			personalView.heightAnchor.constraint(equalToConstant: size),
			personalView.widthAnchor.constraint(equalToConstant: bounds.width - avatar.bounds.width - 20),
			personalView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
		])
		
		personalView.addSubview(name)
		name.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			name.topAnchor.constraint(equalTo: personalView.topAnchor, constant: 7),
			name.leadingAnchor.constraint(equalTo: personalView.leadingAnchor),
			name.heightAnchor.constraint(equalToConstant: 20)
		])
		
		personalView.addSubview(email)
		email.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			email.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
			email.leadingAnchor.constraint(equalTo: personalView.leadingAnchor),
			email.heightAnchor.constraint(equalToConstant: 20)
		])
	}

}
