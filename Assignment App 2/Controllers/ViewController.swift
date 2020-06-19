//
//  ViewController.swift
//  Assignment App 2
//
//  Created by Roman Kavinskyi on 17.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	let tableView = UITableView()
	
	var networkManager = NetworkManager()
	var people = [PersonModel]()
	var stopIndexPath = Int()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		networkManager.delegate = self
		networkManager.fetchData()
		setupTableView()
		
	}
	
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.identifier)
		tableView.refreshControl = UIRefreshControl()
		tableView.refreshControl?.addTarget(self, action: #selector(tableViewPulledDown), for: .valueChanged)
		tableView.rowHeight = 80
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
		])
	}
	
	@objc private func tableViewPulledDown() {
		if people.count == 0 {
			networkManager.fetchData()
			DispatchQueue.main.async {
				self.tableView.refreshControl?.endRefreshing()
			}
		}
		if people.count < 11 {
			DispatchQueue.main.async {
				self.tableView.refreshControl?.endRefreshing()
			}
		} else {
	
			people.removeAll()

			networkManager.page = 1 //after deleting redundant people, start loading from the 1 page
			networkManager.fetchData()
			tableView.reloadData()
			stopIndexPath = 0 // this will let me to call willDisplayCell again
			
			DispatchQueue.main.async {
				self.tableView.refreshControl?.endRefreshing()
			}
		}
		
	}
	
	
}
extension ViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: false)
	}
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		
		if indexPath.row == people.count - 1 && indexPath.row != stopIndexPath {
			stopIndexPath = indexPath.row  // prevents from Double-Calling this method
			
			networkManager.page += 1
			networkManager.fetchData()
		}
	}
	
	
}

extension ViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		people.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.identifier, for: indexPath) as! TableViewCell
		cell.name.text = people[indexPath.row].name
		cell.email.text = people[indexPath.row].email
		cell.avatar.downloaded(from: people[indexPath.row].avatar)
		return cell
	}
	
	
}

extension ViewController: NetworkManagerDelegate {
	func didUpdateData(_ networkManager: NetworkManager, person: [PersonModel]) {
		people.append(contentsOf: person)
		DispatchQueue.main.async {
			self.tableView.reloadData()
			
		}
		
	}
	
	func didFailWithError(error: Error) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Ooops, an error!", message: error.localizedDescription, preferredStyle: .alert)
			let action = UIAlertAction(title: "OK", style: .default, handler: nil)
			alert.addAction(action)
			self.present(alert, animated: true)
		}
	}
	
	
}





